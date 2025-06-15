import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Model
import 'package:frontend/modules/products/models/product.dart';

// Service
import 'package:frontend/modules/products/services/product_service.dart';

class SearchProduct extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(List<Product>) onSearchResults;
  final int selectedCategoryId; 

  const SearchProduct({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onSearchResults, 
    required this.selectedCategoryId
  }) : super(key: key);
  
  @override
  _InputSearchState createState() => _InputSearchState();
}

class _InputSearchState extends State<SearchProduct> {
  final ProductService productService = ProductService();

  Timer? _debounce;

  void searchProduct(String name) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (name.isEmpty) {
        if (widget.selectedCategoryId == 0) {
          widget.onSearchResults(await productService.fetchProducts());
        } 
        else {
          widget.onSearchResults(await productService.fetchProductByCategory(widget.selectedCategoryId));
        }
      } 
      else {
        try {
          final result = await productService.fetchProductByName(name);
          widget.onSearchResults(result);
        } 
        catch (err) {
          print("Error searching product: $err");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: searchProduct, 
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 200)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: myColor)
          ),
          prefixIcon: Icon(
            IconlyLight.search, 
            color: myColor,
          ),
        ),
      ),
    );
  }
}
