import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/pos/home/product_categories.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onCategoryTapped(int index) {
    print("Selected Category Index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
                child: Container(
                  child: ProductCategories(onCategoryTapped: onCategoryTapped),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}