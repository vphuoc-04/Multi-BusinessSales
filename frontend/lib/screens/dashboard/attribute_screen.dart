import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/dashboard/attribute/attribute_data.dart';
import 'package:frontend/components/dashboard/attribute/attribute_value_added.dart';
import 'package:frontend/components/dashboard/attribute/attribute_value_belong_attribute_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/attributes/models/attribute.dart';

// Services
import 'package:frontend/modules/attributes/services/attribute_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class AttributeScreen extends StatefulWidget {
  @override
  _AttributeScreenState createState() => _AttributeScreenState();
}

class _AttributeScreenState extends State<AttributeScreen> {
  final AttributeService attributeService = AttributeService();
  final TextEditingController nameController = TextEditingController();
  List<Attribute> attributeList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAttributes();
  }

  Future<void> addAttribute() async {
    final name = nameController.text;
    if (name.isEmpty) {
      print("Attribute name cannot be empty");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await attributeService.add(name);
      if (response['success'] == true) {
        print("Attribute added successfully");
        await fetchAttributes();
      } else {
        print(response['message'] ?? "Failed to add attribute");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAttributes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Attribute> response = await attributeService.fetchAttributes();
      setState(() {
        attributeList = response;
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showUpdateDialog(Attribute attribute) {
    TextEditingController nameController =
        TextEditingController(text: attribute.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Attribute"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Attribute Name"),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await attributeService.update(attribute.id, nameController.text);
                Navigator.pop(context);
                fetchAttributes();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
              child: isLoading
                  ? LoadingWidget(size: 5, color: baseColor)
                  : Text("Update", style: TextStyle(color: baseColor)),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(Attribute attribute) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Attribute"),
          content:
              Text("Are you sure you want to delete the attribute ${attribute.name}?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await attributeService.delete(attribute.id);
                Navigator.pop(context);
                fetchAttributes();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text("Attributes"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Attribute Name"),
              ),
              ElevatedButton(
                onPressed: addAttribute,
                style: ElevatedButton.styleFrom(backgroundColor: myColor),
                child: isLoading
                    ? LoadingWidget(size: 10, color: baseColor)
                    : Text("Add", style: TextStyle(color: baseColor)),
              ),
              SizedBox(height: 50),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingWidget(size: 20, color: myColor
                      ))
                    : AttributeData(
                        attributeList: attributeList, 
                        showUpdateDialog: showUpdateDialog, 
                        showDeleteDialog: showDeleteDialog, 
                        onTapAttribute: (Attribute attribute) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttributeValueBelongAttributeData(attribute: attribute)
                            )
                          );
                        },
                        onTapAddAttributeValue: (Attribute attribute) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttributeValueAdded(attributeId: attribute.id)
                            )
                          );
                        },
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
