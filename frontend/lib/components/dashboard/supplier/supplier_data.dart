import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Model
import 'package:frontend/modules/suppliers/models/supplier.dart';

class SupplierData extends StatelessWidget {
  final List<Supplier> suppliersList;
  final Function(Supplier) showUpdateDialog;
  final Function(Supplier) showDeleteDialog;

  const SupplierData({
    super.key,
    required this.suppliersList,
    required this.showUpdateDialog,
    required this.showDeleteDialog
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suppliersList.length,
      itemBuilder: (context, index) {
        final group = suppliersList[index];
        return ListTile(
          title: Text(group.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => showUpdateDialog(group),
                icon: Icon(IconlyLight.setting, color: myColor),
              ),
              IconButton(
                onPressed: () => showDeleteDialog(group),
                icon: Icon(IconlyLight.delete, color: Colors.red),
              ),
            ],
          ),
        );
      }
    );
  }
}