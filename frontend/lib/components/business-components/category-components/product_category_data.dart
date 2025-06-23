import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/cud_button_group.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

class ProductCategoryData extends StatelessWidget {
  final List<ProductCategory> productCatagoriesList;
  final Function(ProductCategory) showUpdateDialog;
  final Function(ProductCategory) showDeleteDialog;
  final Function(ProductCategory) onTapAddProductToCategory;

  const ProductCategoryData({
    super.key,
    required this.productCatagoriesList,
    required this.showUpdateDialog,
    required this.showDeleteDialog,
    required this.onTapAddProductToCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productCatagoriesList.length,
      itemBuilder: (context, index) {
        final category = productCatagoriesList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(category.name),
            subtitle: Text(
              category.publish == 1
                  ? "Active"
                  : category.publish == 0
                      ? "Inactive"
                      : "Archived",
            ),
            trailing: CudButtonGroup(
              buttons: [
                Button(
                  label: "Thêm",
                  color: myColor,
                  onTap: () => onTapAddProductToCategory(category),
                ),
                Button(
                  label: "Sửa",
                  color: updateColor,
                  onTap: () => showUpdateDialog(category),
                ),
                Button(
                  label: "Xóa",
                  color: deleteColor,
                  onTap: () => showDeleteDialog(category),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
