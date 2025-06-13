import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/products/models/product_brand.dart';

// Services
import 'package:frontend/modules/products/services/product_brand_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class ProductBrandScreen extends StatefulWidget {
  @override
  _ProductBrandScreenState createState() => _ProductBrandScreenState();
}

class _ProductBrandScreenState extends State<ProductBrandScreen> {
  final ProductBrandService productBrandService = ProductBrandService();
  final TextEditingController nameController = TextEditingController();
  List<ProductBrand> productBrandsList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProductBrandsData();
  }

  Future<void> addProductBrand() async {
    final name = nameController.text;
    if (name.isEmpty) {
      print("Brand name cannot be empty");
      return;
    }
    setState(() { isLoading = true; });
    try {
      final response = await productBrandService.add(name);
      if (response['success'] == true) {
        print("Brand added successfully");
        await fetchProductBrandsData();
      } else {
        print(response['message'] ?? "Failed to add brand");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  Future<void> fetchProductBrandsData() async {
    setState(() { isLoading = true; });
    try {
      final response = await productBrandService.fetchProductBrands();
      setState(() { productBrandsList = response; });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  void showUpdateDialog(ProductBrand brand) {
    TextEditingController nameController = TextEditingController(text: brand.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Brand"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Brand Name"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                setState(() { isLoading = true; });
                await productBrandService.update(brand.id, nameController.text);
                Navigator.pop(context);
                fetchProductBrandsData();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
              child: isLoading ? LoadingWidget(size: 5, color: baseColor) : Text("Update", style: TextStyle(color: baseColor)),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(ProductBrand brand) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Brand"),
          content: Text("Are you sure you want to delete the brand ${brand.name}?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                setState(() { isLoading = true; });
                await productBrandService.delete(brand.id);
                Navigator.pop(context);
                fetchProductBrandsData();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
              child: isLoading ? LoadingWidget(size: 5, color: baseColor) : Text("Delete", style: TextStyle(color: baseColor)),
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text("Product Brand"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Brand Name"),
              ),
              ElevatedButton(
                onPressed: addProductBrand,
                style: ElevatedButton.styleFrom(backgroundColor: myColor),
                child: isLoading ? LoadingWidget(size: 10, color: baseColor) : Text("Add", style: TextStyle(color: baseColor)),
              ),
              SizedBox(height: 50),
              Expanded(
                child: isLoading
                    ? Center(child: LoadingWidget(size: 20, color: myColor))
                    : ListView.builder(
                        itemCount: productBrandsList.length,
                        itemBuilder: (context, index) {
                          final brand = productBrandsList[index];
                          return ListTile(
                            title: Text(brand.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(IconlyLight.setting, color: myColor,),
                                  onPressed: () => showUpdateDialog(brand),
                                ),
                                IconButton(
                                  icon: Icon(IconlyLight.delete, color: Color.fromRGBO(255, 0, 0, 1),),
                                  onPressed: () => showDeleteDialog(brand),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}