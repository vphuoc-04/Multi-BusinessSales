import 'package:flutter/material.dart';
import 'package:frontend/modules/attributes/models/attribute.dart';
import 'package:frontend/modules/attributes/models/attribute_value.dart';
import 'package:frontend/modules/attributes/services/attribute_service.dart';
import 'package:frontend/modules/attributes/services/attribute_value_service.dart';

class AttributeSelectionDialog extends StatefulWidget {
  @override
  _AttributeSelectionDialogState createState() => _AttributeSelectionDialogState();
}

class _AttributeSelectionDialogState extends State<AttributeSelectionDialog> {
  final AttributeService attributeService = AttributeService();
  final AttributeValueService attributeValueService = AttributeValueService();

  // Chỉ lưu id đã chọn
  Map<int, int?> selectedValueIds = {}; // key = attributeId, value = attributeValueId

  // Lưu danh sách value theo từng attribute
  Map<int, List<AttributeValue>> attributeValuesMap = {};

  List<Attribute> attributes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttributes();
  }

  Future<void> _fetchAttributes() async {
    final result = await attributeService.fetchAttributes();

    for (final attr in result) {
      final values = await attributeValueService.fetchAttributeValues(attr.id);
      attributeValuesMap[attr.id] = values;
    }

    setState(() {
      attributes = result;
      isLoading = false;
    });
  }

  Widget _buildDropdown(Attribute attribute) {
    final values = attributeValuesMap[attribute.id] ?? [];

    return DropdownButton<int>(
      hint: Text(attribute.name),
      value: selectedValueIds[attribute.id],
      isExpanded: true,
      items: values.map((value) {
        return DropdownMenuItem<int>(
          value: value.id,
          child: Text(value.value),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          selectedValueIds[attribute.id] = val;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return AlertDialog(
      title: Text('Chọn thuộc tính'),
      content: SingleChildScrollView(
        child: Column(
          children: attributes.map((attr) => _buildDropdown(attr)).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            List<AttributeValue> selectedValues = [];

            for (final attr in attributes) {
              final id = selectedValueIds[attr.id];
              final values = attributeValuesMap[attr.id] ?? [];

              AttributeValue? selected;
              try {
                selected = values.firstWhere((v) => v.id == id);
              } catch (e) {
                selected = null;
              }

              if (selected != null) {
                selectedValues.add(selected);
              }
            }

            Navigator.of(context).pop(selectedValues);
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }
}
