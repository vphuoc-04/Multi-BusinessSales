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

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

  // Fetch product brands
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

  // Fetch product categories
  Future<void> fetchProductCategory() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await productCategoryService.fetchProductCategory();
      setState(() {
        productCategoryList = response;
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch products
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final response = await productService.fetchProducts();
      setState(() {
        productList = response;
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showEditProductDialog(Product product) {
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

    bool isLoadingCategories = productCategoryList.isEmpty;
    bool isLoadingBrands = productBrandList.isEmpty;

    if (isLoading) {
      productCategoryService.fetchProductCategory().then((response) {
        setState(() {
          productCategoryList = response;
          isLoading = false;
          if (productCategoryList.isNotEmpty) {
            selectedCategoryId = productCategoryList.first.id;
          }
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetch category: $error")),
        );
      });
    }

    if (isLoading) {
      productBrandService.fetchProductBrands().then((response) {
        setState(() {
          productBrandList = response;
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetch brand: $error")),
        );
      });
    }

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFiles.add(File(pickedFile.path));
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            // Di chuyển logic _pickImage và updateProduct vào trong StatefulBuilder
            Future<void> _pickImage() async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                dialogSetState(() {
                  imageFiles.add(File(pickedFile.path));
                });
              }
            }

            Future<void> updateProduct() async {
              if (selectedBrandId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Brnad is required")),
                );
                return;
              }

              // Hiển thị loading trong dialog
              dialogSetState(() {
                isLoading = true;
              });

              try {
                final response = await productService.update(
                  id: product.id,
                  productCode: productCodeController.text,
                  productCategoryId: selectedCategoryId!,
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  brandId: selectedBrandId!,
                  images: imageFiles,
                );

                dialogSetState(() {
                  isLoading = false;
                });

                if (response['success'] == true) {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Update product success")),
                  );
                  try {
                    await fetchProducts();
                  } catch (error) {
                    print("Error fetch product list: $error");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error fetch product list: $error")),
                    );
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response['message'] ?? "Update failed!")),
                  );
                }
              } catch (error) {
                dialogSetState(() {
                  isLoading = false;
                });
                print("Error update product: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $error")),
                );
              }
            }

            return AlertDialog(
              title: Text("Update product"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                        controller: productCodeController,
                        decoration: InputDecoration(labelText: "Product code")),
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Product name")),
                    TextField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number),
                    SizedBox(height: 10),
                    // Dropdown cho danh mục sản phẩm
                    isLoadingCategories
                        ? LoadingWidget(color: myColor, size: 28)
                        : productCategoryList.isEmpty
                            ? Text("Category null")
                            : DropdownButton<int>(
                                value: selectedCategoryId,
                                hint: Text("Choose cateogry"),
                                onChanged: (int? newValue) {
                                  dialogSetState(() {
                                    selectedCategoryId = newValue!;
                                  });
                                },
                                items: productCategoryList.map((category) {
                                  return DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                              ),
                    SizedBox(height: 10),
                    // Dropdown cho thương hiệu sản phẩm
                    isLoadingBrands
                        ? LoadingWidget(color: myColor, size: 28)
                        : productBrandList.isEmpty
                            ? Text("Brand null")
                            : DropdownButton<int>(
                                value: selectedBrandId,
                                hint: Text("Choose brand"),
                                onChanged: (int? newValue) {
                                  dialogSetState(() {
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
                      children: imageFiles
                          .map((file) => Image.file(file, width: 100, height: 100))
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                ElevatedButton(
                  onPressed: isLoading ? null : updateProduct,
                  child: isLoading
                      ? LoadingWidget(color: myColor, size: 20)
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
          title: Text("Delete Product"),
          content: Text("Are you sure you want to delete product ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() { isLoading = true; });
                await productService.delete(product.id);
                Navigator.pop(context);
                fetchProducts();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
              child: isLoading
                  ? LoadingWidget(size: 5, color: baseColor)
                  : Text("Delete", style: TextStyle(color: baseColor)),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: myColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 20))
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                print("Product ${product.id} images: ${product.imageUrls}");
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${product.id}", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Added By: ${product.addedBy}"),
                        SizedBox(height: 4),
                        Text("Name: ${product.name}"),
                        SizedBox(height: 4),
                        Text("Price: \$${product.price}"),
                        SizedBox(height: 8),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.imageUrls.length,
                            itemBuilder: (context, imgIndex) {
                              return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product.imageUrls[imgIndex].replaceFirst(RegExp(r'^/'), ''),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                    if (wasSynchronouslyLoaded || frame != null) {
                                      return child; // Ảnh đã load xong
                                    } else {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: LoadingWidget(size: 30, color: Colors.blue), // hoặc tùy chọn size/color
                                      );
                                    }
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
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => showEditProductDialog(product),
                              icon: Icon(IconlyLight.edit, color: myColor),
                            ),
                            IconButton(
                              onPressed: () => showDeleteDialog(product), 
                              icon: Icon(IconlyLight.delete, color: Colors.red)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
