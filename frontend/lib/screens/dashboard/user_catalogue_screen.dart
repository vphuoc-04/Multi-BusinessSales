import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Services
import 'package:frontend/modules/users/services/user_catalogue_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class UserCatalogueScreen extends StatefulWidget {
  @override
  _UserCatalogueScreenState createState() => _UserCatalogueScreenState();
}

class _UserCatalogueScreenState extends State<UserCatalogueScreen> {
  final UserCatalogueService userCatalogueService = UserCatalogueService();

  final TextEditingController nameController = TextEditingController();

  int publishStatus = 0;

  bool isLoading = false;

  // Add user catalogue
  Future<void> addUserCatalogue() async {
    final name = nameController.text;

    if (name.isEmpty) {
      print("Name user catalogue cannot be empty");
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      final response = await userCatalogueService.add(name, publishStatus);

      if (response['success'] == true) {
        print("New user catalogue added successfully");
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
              Text("User catalogue"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "User catalogue name" 
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
                  addUserCatalogue();
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
              )
            ],
          )
        ),
      ),
    );
  }
}