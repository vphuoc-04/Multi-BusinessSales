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

  // Fetch attribute values
  Future<void> fetchAttributeValueBelongAttribute() async {
    setState(() { isLoading = true; });
    try {
      final response = await attributeValueService.fetchAttributeValues(widget.attribute.id);
      print("API Response: $response");
      setState(() { attributeValueList = response; });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  // Edit attribute value
  void editAttributeValue(AttributeValue attributeValue) {
    TextEditingController valueController = TextEditingController(text: attributeValue.value);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chỉnh sửa giá trị thuộc tính"),
          content: TextField(
            controller: valueController,
            decoration: InputDecoration(labelText: "Giá trị"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                String newValue = valueController.text.trim();
                if (newValue.isEmpty || newValue == attributeValue.value) {
                  Navigator.pop(context);
                  return;
                }

                setState(() { isLoading = true; });
                try {
                  final response = await attributeValueService.update(
                    attributeValue.id,
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
                              )
                            : item;
                      }).toList();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message']))
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi cập nhật: $error"))
                  );
                } finally {
                  setState(() { isLoading = false; });
                  Navigator.pop(context);
                }
              },
              child: Text("Cập nhật"),
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
        title: Text(
          "${widget.attribute.name}",
          style: TextStyle(color: baseColor),
        ),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: baseColor),
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 20))
          : ListView.builder(
              itemCount: attributeValueList.length,
              itemBuilder: (context, index) {
                final attributeValue = attributeValueList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${attributeValue.id}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text("Value: ${attributeValue.value}"),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => editAttributeValue(attributeValue),
                              icon: Icon(IconlyLight.setting, color: myColor),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(IconlyLight.delete, color: Colors.red),
                            )
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
