import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

// Services
import 'package:frontend/modules/products/services/product_category_service.dart';

class ProductCategories extends StatefulWidget {
  final Function(int) onCategoryTapped;

  ProductCategories({
    required this.onCategoryTapped
  });

  @override
  _ProductCategoriesState createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  final ProductCategoryService productCategoryService = ProductCategoryService();
  List<ProductCategory> productCategories = [];

  int selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductCategories();
  }

  // Fetch product categories
  Future<void> fetchProductCategories() async {
    try {
      List<ProductCategory> response = await productCategoryService.fetchProductCategory();

      setState(() {
        productCategories = response.where((category) => category.publish !=0).toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
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
                  widget.onCategoryTapped(index);
                },
            child: Container(
              width: 70,
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