import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/dashboard/supplier/supplier_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/suppliers/models/supplier.dart';

// Services
import 'package:frontend/modules/suppliers/services/supplier_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class SupplierScreen extends StatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final SupplierService supplierService = SupplierService();
  final TextEditingController nameController = TextEditingController();
  
  List<Supplier> suppliersList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSupplierData();
  }

  // Add
  Future<void> addSupplier() async {
    final name = nameController.text;
    if (name.isEmpty) {
      print("Supplier name cannot be empty");
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await supplierService.add(name);
      if (response['success'] == true) {
        print("New supplier added successfully");
        await fetchSupplierData();
      } else {
        print(response['message'] ?? "Failed to add supplier");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  // Fetch
  Future<void> fetchSupplierData() async {
    setState(() { isLoading = true; });

    try {
      final response = await supplierService.fetchSuppliers();
      setState(() { suppliersList = response; });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  void showUpdateDialog(Supplier supplier) {
    TextEditingController nameController = TextEditingController(text: supplier.name);
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Supplier"),
          content: Text("Are you sure you want to update supplier ${supplier.name}?"),
          actions: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Supplier Name"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Cancel")
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() { isLoading = true; });
                await supplierService.update(supplier.id, nameController.text);
                Navigator.pop(context);
                fetchSupplierData();
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
              child: isLoading
                  ? LoadingWidget(size: 5, color: baseColor)
                  : Text("Update", style: TextStyle(color: baseColor)),
            )
          ],
        );
      }
    );
  }

  // Delete
  void showDeleteDialog(Supplier supplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Supplier"),
          content: Text("Are you sure you want to delete supplier ${supplier.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() { isLoading = true; });
                await supplierService.delete(supplier.id);
                Navigator.pop(context);
                fetchSupplierData();
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("Suppliers"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Supplier name"),
              ),
              ElevatedButton(
                onPressed: addSupplier,
                style: ElevatedButton.styleFrom(backgroundColor: myColor),
                child: isLoading
                    ? LoadingWidget(size: 10, color: baseColor)
                    : Text("Add", style: TextStyle(color: baseColor)),
              ),
              SizedBox(height: 50),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingWidget(size: 20, color: myColor),
                      )
                    : SupplierData(
                        suppliersList: suppliersList, 
                        showUpdateDialog: showUpdateDialog, 
                        showDeleteDialog: showDeleteDialog
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}