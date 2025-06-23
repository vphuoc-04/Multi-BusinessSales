import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/screens/business-screens/managements/product_management_screen.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

// Models
import 'package:frontend/modules/products/models/product_brand.dart';

// Services
import 'package:frontend/modules/products/services/product_brand_service.dart';
import 'package:frontend/modules/products/services/product_service.dart';

class AddProductForm extends StatefulWidget {
  final int productCategoryId;

  const AddProductForm({required this.productCategoryId, super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final ProductService productService = ProductService();
  final ProductBrandService productBrandService = ProductBrandService();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<void> fetchProductBrand() async {
    setState(() => isLoading = true);
    try {
      final response = await productBrandService.fetchProductBrands();
      setState(() => productBrandList = response);
    } catch (error) {
      print("Error fetching brands: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching brands: $error")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await productService.add(
        productCode: productCodeController.text,
        productCategoryId: widget.productCategoryId,
        name: nameController.text,
        price: double.tryParse(priceController.text) ?? 0,
        brandId: selectedBrandId, // Allow null for brandId
        images: imageFiles,
      );

      setState(() => isLoading = false);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductManagementScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Add product failed!")),
        );
      }
    } catch (error) {
      setState(() => isLoading = false);
      print("Error adding product: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: myColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: productCodeController,
                  decoration: InputDecoration(
                    labelText: "Product Code",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: myColor, width: 2),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Product code is required" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: myColor, width: 2),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Product name is required" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: myColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return "Price is required";
                    if (double.tryParse(value) == null) return "Invalid price format";
                    return null;
                  },
                ),
                SizedBox(height: 16),
                isLoading
                    ? Center(child: LoadingWidget(color: myColor, size: 28))
                    : productBrandList.isEmpty
                        ? Text("No brands available", style: TextStyle(color: Colors.grey))
                        : DropdownButtonFormField<int>(
                            value: selectedBrandId,
                            decoration: InputDecoration(
                              labelText: "Brand",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: myColor, width: 2),
                              ),
                            ),
                            items: [
                              DropdownMenuItem<int>(
                                value: null,
                                child: Text("No Brand"),
                              ),
                              ...productBrandList.map((brand) {
                                return DropdownMenuItem<int>(
                                  value: brand.id,
                                  child: Text(brand.name),
                                );
                              }).toList(),
                            ],
                            onChanged: (int? newValue) {
                              setState(() => selectedBrandId = newValue);
                            },
                            validator: (value) => null, // Brand is optional
                          ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: imageFiles
                      .asMap()
                      .entries
                      .map((entry) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  entry.value,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    setState(() => imageFiles.removeAt(entry.key));
                                  },
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text("Add Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : addProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? LoadingWidget(color: Colors.white, size: 20)
                        : Text(
                            "Add Product",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}