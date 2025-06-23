import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/cud_button_group.dart';

// Models
import 'package:frontend/modules/attributes/models/attribute.dart';

class AttributeData extends StatelessWidget {
  final List<Attribute> attributeList;
  final Function(Attribute) showUpdateDialog;
  final Function(Attribute) showDeleteDialog;
  final Function(Attribute) onTapAttribute;
  final Function(Attribute) onTapAddAttributeValue;

  const AttributeData({
    super.key,
    required this.attributeList,
    required this.showUpdateDialog,
    required this.showDeleteDialog,
    required this.onTapAttribute,
    required this.onTapAddAttributeValue
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: attributeList.length,
      itemBuilder: (context, index) {
        final attribute = attributeList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1), 
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Container(
              child: Text('${attribute.name}'),
            ),
            onTap: () => onTapAttribute(attribute),
            trailing: CudButtonGroup(
              buttons: [
                Button(
                  label: "Thêm", 
                  color: myColor, 
                  onTap: () => onTapAddAttributeValue(attribute),
                ),
                Button(
                  label: "Sửa", 
                  color: updateColor, 
                  onTap: () => showUpdateDialog(attribute),
                ),
                Button(
                  label: "Xóa", 
                  color: deleteColor, 
                  onTap: () => showDeleteDialog(attribute),
                ),
              ]
            )
          ),
        );
      },
    );
  }
}