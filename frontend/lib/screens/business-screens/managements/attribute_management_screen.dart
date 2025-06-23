import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/business-components/attribute-components/attribute_data.dart';
import 'package:frontend/components/business-components/attribute-components/add_attribute_value_form.dart';
import 'package:frontend/components/business-components/attribute-components/attribute_value_belong_attribute_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/attributes/models/attribute.dart';

// Services
import 'package:frontend/modules/attributes/services/attribute_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class AttributeManagementScreen extends StatefulWidget {
  @override
  _AttributeManagementScreenState createState() => _AttributeManagementScreenState();
}

class _AttributeManagementScreenState extends State<AttributeManagementScreen> {
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
      final response = await attributeService.fetchAttributes();
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
      appBar: AppBar(
        title: Text("Thuộc tính sản phẩm"),
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
                SizedBox(height: 50),
                //Text("Attributes"),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nhập tên thuộc tính sản phẩm..."),
                ),
                SizedBox(height: 20),
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
                      addAttribute()
                    },
                    child: isLoading
                      ? LoadingWidget(size: 15, color: baseColor)
                      : Text("Thêm nhóm thuộc tính sản phẩm", style: TextStyle(color: Colors.white),)
                    , 
                  ),
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
                                builder: (context) => AddAttributeValueForm(attributeId: attribute.id)
                              )
                            );
                          },
                        )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
