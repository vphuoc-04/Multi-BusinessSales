import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

class ProductCategoryData extends StatelessWidget {
  final List<ProductCategory> productCatagoriesList;
  final Function(ProductCategory) showUpdateDialog;
  final Function(ProductCategory) showDeleteDialog;

  const ProductCategoryData({
    super.key, 
    required this.productCatagoriesList,
    required this.showUpdateDialog,
    required this.showDeleteDialog
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productCatagoriesList.length,
      itemBuilder: (context, index) {
        final group = productCatagoriesList[index];
        return ListTile(
          title: Text(group.name),
          subtitle: Text(group.publish == 1
              ? "Active"
              : group.publish == 0
                  ? "Inactive"
                  : "Archived"),
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
          )
        );
      },
    );
  }
}
