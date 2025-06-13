import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

// Models
import 'package:frontend/modules/products/models/product_brand.dart';

// Services
import 'package:frontend/modules/products/services/product_brand_service.dart';
import 'package:frontend/modules/products/services/product_service.dart';

class AddProduct extends StatefulWidget {
  final int productCategoryId;

  AddProduct({required this.productCategoryId});

  @override
  _ProductAddedState createState() => _ProductAddedState();
}

class _ProductAddedState extends State<AddProduct> {
  final ProductService productService = ProductService();
  final ProductBrandService productBrandService = ProductBrandService();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<File> imageFiles = [];
  List<ProductBrand> productBrandList = [];
  int? selectedBrandId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProductBrand();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFiles.add(File(pickedFile.path));
      });
    }
  }

  // Fetch product
  Future<void> fetchProductBrand() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await productBrandService.fetchProductBrands();
      setState(() {
        productBrandList = response;
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addProduct() async {
    try {
      final response = await productService.add(
        productCode: productCodeController.text,
        productCategoryId: widget.productCategoryId,
        name: nameController.text,
        price: double.tryParse(priceController.text) ?? 0,
        brandId: selectedBrandId!,
        images: imageFiles, 
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product added successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Add product failed!")),
        );
      }
    } catch (error) {
      print("Error add product: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: productCodeController, decoration: InputDecoration(labelText: "Product code")),
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product name")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            isLoading
                ? LoadingWidget(color: myColor, size: 28)
                : DropdownButton<int>(
                    value: selectedBrandId,
                    hint: Text("Choose brand"),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedBrandId = newValue;
                      });
                    },
                    items: productBrandList.map((brand) {
                      return DropdownMenuItem<int>(
                        value: brand.id,
                        child: Text(brand.name),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickImage, child: Text("Choose image")),
            Wrap(
              children: imageFiles.map((file) => Image.file(file, width: 100, height: 100)).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addProduct, child: Text("Add product")),
          ],
        ),
      ),
    );
  }
}
