import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/business/pos/product_category_selected.dart';
import 'package:frontend/components/business/pos/product_data.dart';
import 'package:frontend/components/business/pos/search_product.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product.dart';

// Services
import 'package:frontend/modules/products/services/product_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class PosScreen extends StatefulWidget {
  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductService productService = ProductService();
  List<Product> products = [];

  int selectedCategoryId = 0; 

  bool isLoading = true;

  void onCategoryTapped(int? id) {
    if (id == -1) {
      print("Đã chọn TẤT CẢ sản phẩm");
      fetchAllProduct();
    } else if (id != null) {
      print("Đã chọn category ID: $id");
      fetchProductByCategory(id);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllProduct();
    
  }

  // Fetch all products
  Future<void> fetchAllProduct() async {
    try {
      final productList = await productService.fetchProducts();

      setState(() {
        products = productList;
        isLoading = false;
      });

      print(productList);
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  // Fetch products by categoryId
  Future<void> fetchProductByCategory(int category) async {
    try {
      final productList = await productService.fetchProductByCategory(category);

      setState(() {
        products = productList;
        isLoading = false;
      });

    } catch (error) {
      print('Error fetching product by category: $error');
    }
  }

  void updateSearchResults(List<Product> results) {
    setState(() {
      products = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // Cho đổ bóng nếu muốn
        title: Text(
          "POS - Point Of Sales",
        ),
        iconTheme: IconThemeData(color: myColor),
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        child: Center(
          child: Column(
            children: [
              SearchProduct(
                controller: searchController,
                hintText: 'Search product...',
                obscureText: false,
                onSearchResults: updateSearchResults,
                selectedCategoryId: selectedCategoryId,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  child: ProductCategorySelected(onCategoryTapped: onCategoryTapped),
                ),
              ),
              isLoading 
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: LoadingWidget(size: 25, color: myColor),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: products.isEmpty
                          ? Center(
                              child: Text("Không có sản phẩm nào"),
                            )
                          : ProductData(products: products)
                    )
                  )
            ],
          ),
        ),
      ),
    );
  }
}