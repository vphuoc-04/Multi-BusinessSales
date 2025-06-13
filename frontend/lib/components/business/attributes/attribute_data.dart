import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

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
        return ListTile(
          title: Text('${attribute.id} - ${attribute.name}'),
          onTap: () => onTapAttribute(attribute),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onTapAddAttributeValue(attribute),
                icon: Icon(IconlyLight.add_user, color: myColor),
              ),
              IconButton(
                onPressed: () => showUpdateDialog(attribute),
                icon: Icon(IconlyLight.setting, color: myColor),
              ),
              IconButton(
                onPressed: () => showDeleteDialog(attribute),
                icon: Icon(IconlyLight.delete, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}