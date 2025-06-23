import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/business-components/category-components/product_category_data.dart';
import 'package:frontend/components/business-components/category-components/add_product_form.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_category.dart';

// Services
import 'package:frontend/modules/products/services/product_category_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class ProductCategoryManagementScreen extends StatefulWidget {
  @override
  _ProductCategoryManagementScreennState createState() => _ProductCategoryManagementScreennState();
}

class _ProductCategoryManagementScreennState extends State<ProductCategoryManagementScreen> {
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
      appBar: AppBar(
        title: Text("Nhóm sản phẩm"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: myColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                SizedBox(height: 30),
                //Text("Product category"),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Nhập tên nhóm sản phẩm..." 
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
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: myColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: GestureDetector(
                    onTap: () => {
                      addProductCategory()
                    },
                    child: isLoading
                      ? LoadingWidget(size: 15, color: baseColor)
                      : Text("Thêm nhóm sản phẩm", style: TextStyle(color: Colors.white),)
                    , 
                  ),
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
                              builder: (context) => AddProductForm(productCategoryId: category.id),
                            )
                          );
                        },
                      ), 
              ),
              ],
            ),
          )
        ),
      ),
    );
  }
}