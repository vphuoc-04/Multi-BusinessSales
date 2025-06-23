import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product.dart';
import 'package:frontend/modules/products/models/product_brand.dart';
import 'package:frontend/modules/products/models/product_category.dart';

// Services
import 'package:frontend/modules/products/services/product_service.dart';
import 'package:frontend/modules/products/services/product_brand_service.dart';
import 'package:frontend/modules/products/services/product_category_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ProductService productService = ProductService();
  final ProductCategoryService productCategoryService = ProductCategoryService();
  final ProductBrandService productBrandService = ProductBrandService();

  List<Product> productList = [];
  List<ProductBrand> productBrandList = [];
  List<ProductCategory> productCategoryList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchProductBrand();
    fetchProductCategory();
  }

  Future<void> fetchProductBrand() async {
    setState(() => isLoading = true);
    try {
      final response = await productBrandService.fetchProductBrands();
      setState(() => productBrandList = response);
    } catch (error) {
      print("Error fetching brands: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchProductCategory() async {
    setState(() => isLoading = true);
    try {
      final response = await productCategoryService.fetchProductCategory();
      setState(() => productCategoryList = response);
    } catch (error) {
      print("Error fetching categories: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final response = await productService.fetchProducts();
      setState(() => productList = response);
    } catch (error) {
      print("Error fetching products: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showEditProductDialog(Product product) {
    final formKey = GlobalKey<FormState>();
    TextEditingController productCodeController = TextEditingController(text: product.productCode);
    TextEditingController nameController = TextEditingController(text: product.name);
    TextEditingController priceController = TextEditingController(text: product.price.toString());
    List<File> imageFiles = [];
    int? selectedBrandId = product.brandId;
    int? selectedCategoryId = product.productCategoryId;

    if (selectedCategoryId != null &&
        !productCategoryList.any((category) => category.id == selectedCategoryId)) {
      selectedCategoryId = null;
    }

    if (selectedBrandId != null &&
        !productBrandList.any((brand) => brand.id == selectedBrandId)) {
      selectedBrandId = null;
    }

    bool isLoadingDialog = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            Future<void> _pickImage() async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                dialogSetState(() {
                  imageFiles.add(File(pickedFile.path));
                });
              }
            }

            Future<void> updateProduct() async {
              if (!formKey.currentState!.validate()) return;

              if (selectedCategoryId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a category")),
                );
                return;
              }

              dialogSetState(() => isLoadingDialog = true);

              try {
                final response = await productService.update(
                  id: product.id,
                  productCode: productCodeController.text,
                  productCategoryId: selectedCategoryId!,
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  brandId: selectedBrandId, 
                  images: imageFiles,
                );

                dialogSetState(() => isLoadingDialog = false);

                if (response['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product updated successfully")),
                  );
                  await fetchProducts();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response['message'] ?? "Update failed")),
                  );
                }
              } catch (error) {
                dialogSetState(() => isLoadingDialog = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error updating product: $error")),
                );
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Update Product", style: Theme.of(context).textTheme.headlineSmall),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: productCodeController,
                        decoration: InputDecoration(
                          labelText: "Product Code",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) => value!.isEmpty ? "Product code is required" : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Product Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) => value!.isEmpty ? "Product name is required" : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: "Price",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Price is required";
                          if (double.tryParse(value) == null) return "Invalid price format";
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      productCategoryList.isEmpty
                          ? Text("No categories available", style: TextStyle(color: Colors.grey))
                          : DropdownButtonFormField<int>(
                              value: selectedCategoryId,
                              decoration: InputDecoration(
                                labelText: "Category",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: productCategoryList.map((category) {
                                return DropdownMenuItem<int>(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                dialogSetState(() => selectedCategoryId = newValue);
                              },
                              validator: (value) => value == null ? "Please select a category" : null,
                            ),
                      SizedBox(height: 16),
                      productBrandList.isEmpty
                          ? Text("No brands available", style: TextStyle(color: Colors.grey))
                          : DropdownButtonFormField<int>(
                              value: selectedBrandId,
                              decoration: InputDecoration(
                                labelText: "Brand",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                                dialogSetState(() => selectedBrandId = newValue);
                              },
                              validator: (value) => null,
                            ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: imageFiles
                            .asMap()
                            .entries
                            .map((entry) => Stack(
                                  children: [
                                    Image.file(entry.value, width: 80, height: 80, fit: BoxFit.cover),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () {
                                          dialogSetState(() => imageFiles.removeAt(entry.key));
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isLoadingDialog ? null : updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isLoadingDialog
                      ? LoadingWidget(color: Colors.white, size: 20)
                      : Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Delete Product", style: Theme.of(context).textTheme.headlineSmall),
          content: Text("Are you sure you want to delete ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      try {
                        await productService.delete(product.id);
                        await fetchProducts();
                        Navigator.pop(context);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error deleting product: $error")),
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? LoadingWidget(size: 20, color: Colors.white)
                  : Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản phẩm", style: TextStyle(color: myColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: myColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 40))
          : productList.isEmpty
              ? Center(child: Text("No products available", style: Theme.of(context).textTheme.bodyLarge))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: borderColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${product.price.toStringAsFixed(2)} \VNĐ",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myColor),
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.imageUrls.length,
                                itemBuilder: (context, imgIndex) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        product.imageUrls[imgIndex].replaceFirst(RegExp(r'^/'), ''),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded || frame != null) {
                                            return child;
                                          }
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            alignment: Alignment.center,
                                            child: LoadingWidget(size: 30, color: myColor),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => showEditProductDialog(product),
                                  icon: Icon(IconlyLight.edit, color: myColor),
                                  tooltip: "Edit",
                                ),
                                IconButton(
                                  onPressed: () => showDeleteDialog(product),
                                  icon: Icon(IconlyLight.delete, color: Colors.red),
                                  tooltip: "Delete",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Add new product feature coming soon!")),
          );
        },
        backgroundColor: myColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}