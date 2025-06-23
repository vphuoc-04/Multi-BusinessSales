import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/attributes/models/attribute.dart';
import 'package:frontend/modules/attributes/models/attribute_value.dart';

// Services
import 'package:frontend/modules/attributes/services/attribute_service.dart';
import 'package:frontend/modules/attributes/services/attribute_value_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class AttributeValueBelongAttributeData extends StatefulWidget {
  final Attribute attribute;

  const AttributeValueBelongAttributeData({Key? key, required this.attribute}) : super(key: key);

  @override
  _AttributeValueBelongAttributeDataState createState() => _AttributeValueBelongAttributeDataState();
}

class _AttributeValueBelongAttributeDataState extends State<AttributeValueBelongAttributeData> {
  final AttributeService attributeService = AttributeService();
  final AttributeValueService attributeValueService = AttributeValueService();

  List<AttributeValue> attributeValueList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAttributeValueBelongAttribute();
  }

  Future<void> fetchAttributeValueBelongAttribute() async {
    setState(() => isLoading = true);
    try {
      final response = await attributeValueService.fetchAttributeValues(widget.attribute.id);
      print("API Response: $response");
      setState(() => attributeValueList = response);
    } catch (error) {
      print("Error fetching attribute values: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching attribute values: $error")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void editAttributeValue(AttributeValue attributeValue) {
    final formKey = GlobalKey<FormState>();
    TextEditingController valueController = TextEditingController(text: attributeValue.value);

    showDialog(
      context: context,
      builder: (context) {
        bool isDialogLoading = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Edit Attribute Value", style: Theme.of(context).textTheme.headlineSmall),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: "Value",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: myColor, width: 2),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Value is required" : null,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isDialogLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          String newValue = valueController.text.trim();
                          if (newValue == attributeValue.value) {
                            Navigator.pop(context);
                            return;
                          }

                          dialogSetState(() => isDialogLoading = true);
                          try {
                            final response = await attributeValueService.update(
                              attributeValue.id!,
                              newValue,
                              widget.attribute.id,
                            );

                            if (response['success']) {
                              setState(() {
                                attributeValueList = attributeValueList.map((item) {
                                  return item.id == attributeValue.id
                                      ? AttributeValue(
                                          id: item.id,
                                          value: newValue,
                                          attributeId: item.attributeId,
                                          addedBy: item.addedBy,
                                        )
                                      : item;
                                }).toList();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Attribute value updated successfully")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response['message'] ?? "Update failed")),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error updating: $error")),
                            );
                          } finally {
                            dialogSetState(() => isDialogLoading = false);
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isDialogLoading
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

  void deleteAttributeValue(AttributeValue attributeValue) {
    showDialog(
      context: context,
      builder: (context) {
        bool isDialogLoading = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Delete Attribute Value", style: Theme.of(context).textTheme.headlineSmall),
              content: Text("Are you sure you want to delete '${attributeValue.value}'?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isDialogLoading
                      ? null
                      : () async {
                          dialogSetState(() => isDialogLoading = true);
                          try {
                            final response = await attributeValueService.delete(attributeValue.id!);
                            if (response['success']) {
                              setState(() {
                                attributeValueList.removeWhere((item) => item.id == attributeValue.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Attribute value deleted successfully")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response['message'] ?? "Deletion failed")),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error deleting: $error")),
                            );
                          } finally {
                            dialogSetState(() => isDialogLoading = false);
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isDialogLoading
                      ? LoadingWidget(color: Colors.white, size: 20)
                      : Text("Delete"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.attribute.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: myColor),
        ),
        iconTheme: IconThemeData(color: myColor),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 40))
          : attributeValueList.isEmpty
              ? Center(
                  child: Text(
                    "No attribute values available",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: attributeValueList.length,
                  itemBuilder: (context, index) {
                    final attributeValue = attributeValueList[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: borderColor,
                          width: 3
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center( 
                              child: Text(
                                attributeValue.value,
                                style: TextStyle(fontSize: 20) ,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                
                              ),
                            ),
                                                  
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(
                            //       onPressed: () => editAttributeValue(attributeValue),
                            //       icon: Icon(IconlyLight.edit, color: myColor),
                            //       tooltip: "Edit",
                            //     ),
                            //     IconButton(
                            //       onPressed: () => deleteAttributeValue(attributeValue),
                            //       icon: Icon(IconlyLight.delete, color: Colors.red),
                            //       tooltip: "Delete",
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}