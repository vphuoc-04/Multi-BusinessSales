import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

// Services
import 'package:frontend/modules/products/services/product_category_service.dart';

class ProductCategorySelected extends StatefulWidget {
  final Function(int?) onCategoryTapped;

  ProductCategorySelected({
    required this.onCategoryTapped
  });

  @override
  _ProductCategorySelectedState createState() => _ProductCategorySelectedState();
}

class _ProductCategorySelectedState extends State<ProductCategorySelected> {
  final ProductCategoryService productCategoryService = ProductCategoryService();
  List<ProductCategory> productCategories = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProductCategories();
  }

  Future<void> fetchProductCategories () async {
    try {
      List<ProductCategory> response = await productCategoryService.fetchProductCategory();

      setState(() {
        productCategories = [
          ProductCategory(id: -1, name: "Tất cả", publish: 1) 
        ]..addAll(response.where((category) => category.publish != 0).toList());
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productCategories.length,
        itemBuilder: (context, index) {
          final category = productCategories[index];
          bool isSelected = selectedIndex == index;
          bool isDisabled = category.publish == 2;

          return GestureDetector(
            onTap: isDisabled
                ? null
                : () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onCategoryTapped(category.id); 
                  },
            child: Container(
              width: 80,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: isDisabled
                    ? Colors.grey[400]
                    : (isSelected ? myColor : const Color.fromARGB(255, 234, 234, 234)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey[700]
                        : (isSelected ? Colors.white : Colors.black),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}