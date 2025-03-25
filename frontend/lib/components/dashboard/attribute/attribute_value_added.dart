import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Services
import 'package:frontend/modules/attributes/services/attribute_value_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class AttributeValueAdded extends StatefulWidget {
  final int attributeId;

  AttributeValueAdded({required this.attributeId});

  @override
  _AttributeValueAddedState createState() => _AttributeValueAddedState();
}

class _AttributeValueAddedState extends State<AttributeValueAdded> {
  final AttributeValueService attributeValueService = AttributeValueService();
  final TextEditingController valueController = TextEditingController();

  bool isLoading = false;

  Future<void> addAttributeValue() async {
    if (valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Attribute value cannot be empty"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await attributeValueService.add(
      valueController.text,
      widget.attributeId
    );

    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Attribute value added successfully!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message'] ?? "Failed to add attribute value"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Attribute Value")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: "Attribute Value"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addAttributeValue,
              child: isLoading
                  ? LoadingWidget(
                      size: 10,
                      color: myColor,
                    )
                  : Text("Add Value"),
            ),
          ],
        ),
      ),
    );
  }
}
