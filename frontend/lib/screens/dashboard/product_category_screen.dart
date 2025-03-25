import 'package:flutter/material.dart';
import 'package:frontend/components/dashboard/category/product_added.dart';

// Components
import 'package:frontend/components/dashboard/category/product_category_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

// Services
import 'package:frontend/modules/products/services/product_category_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class ProductCategoryScreen extends StatefulWidget {
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final ProductCategoryService productCategoryService = ProductCategoryService();

  final TextEditingController nameController = TextEditingController();

  List<ProductCategory> productCatagoriesList = [];

  int publishStatus = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProductCategoryData();
  }

  // Add product category
  Future<void> addProductCategory() async {
    final name = nameController.text;

    if (name.isEmpty) {
      print("Name product category cannot be empty");
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      final response = await productCategoryService.add(name, publishStatus);

      if (response['success'] == true) {
        print("New product category added successfully");
        await fetchProductCategoryData();
      } else {
        print(response['message'] ?? "Failed to add group");
      }

    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch product category data
  Future<void> fetchProductCategoryData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await productCategoryService.fetchProductCategory();

      setState(() {
        productCatagoriesList = response;
      });

    } catch (error) {
      print("Error: $error");

      setState(() {
        isLoading = false;
      });

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  // Update product category
  void showUpdateDialog(ProductCategory group) {
    TextEditingController nameController = TextEditingController(text: group.name);
    int publishStatus = group.publish;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( 
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit Group"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Group Name"),
                  ),
                  DropdownButton<int>(
                    value: publishStatus,
                    onChanged: (int? newValue) {
                      setState(() {
                        publishStatus = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 0, child: Text("Inactive")),
                      DropdownMenuItem(value: 1, child: Text("Active")),
                      DropdownMenuItem(value: 2, child: Text("Archived")),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() { isLoading = true; }); 

                    await productCategoryService.update(group.id, nameController.text, publishStatus);

                    Navigator.pop(context);
                    fetchProductCategoryData();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myColor),
                  child: isLoading
                      ? LoadingWidget(size: 5, color: baseColor)
                      : Text(
                          "Update",
                          style: TextStyle(color: baseColor),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Delete product category
  void showDeleteDialog(ProductCategory category) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Delete Category"),
              content: Text("Are you sure you want to delete the category ${category.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() { isLoading = true; }); 

                    await productCategoryService.delete(category.id);

                    Navigator.pop(context);
                    fetchProductCategoryData();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myColor),
                  child: isLoading
                      ? LoadingWidget(size: 5, color: baseColor)
                      : Text(
                          "Delete",
                          style: TextStyle(color: baseColor),
                        ),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              SizedBox(height: 50),
              Text("Product category"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Product category name" 
                      ),
                    ),
                  ),
                  DropdownButton<int>(
                    value: publishStatus,
                    onChanged: (int? newValue) {
                      setState(() {
                        publishStatus = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 0, child: Text("Inactive")),
                      DropdownMenuItem(value: 1, child: Text("Active")),
                      DropdownMenuItem(value: 2, child: Text("Archived")),
                    ], 
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  addProductCategory();
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor
                ),
                child: isLoading 
                    ? LoadingWidget(size: 10, color: baseColor)
                    : Text(
                        "Add",
                        style: TextStyle(
                          color: baseColor
                        ),
                      )
              ),
              SizedBox(height: 50),
              Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingWidget(size: 20, color: myColor),
                    )
                  : ProductCategoryData(
                      productCatagoriesList: productCatagoriesList,
                      showUpdateDialog: showUpdateDialog,
                      showDeleteDialog: showDeleteDialog,
                      onTapAddProductToCategory: (ProductCategory category) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ProductAdded(productCategoryId: category.id),
                          )
                        );
                      },
                    ), 
            ),
            ],
          )
        ),
      ),
    );
  }
}