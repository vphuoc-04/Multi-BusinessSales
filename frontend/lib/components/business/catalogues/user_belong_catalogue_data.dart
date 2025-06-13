import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user.dart';
import 'package:frontend/modules/users/models/user_catalogue.dart';

// Services
import 'package:frontend/modules/users/services/user_service.dart';
import 'package:frontend/modules/users/services/user_catalogue_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class UserBelongCatalogueData extends StatefulWidget {
  final UserCatalogue catalogue;

  const UserBelongCatalogueData({Key? key, required this.catalogue}) : super(key: key);

  @override
  _UserBelongCatalogueDataState createState() => _UserBelongCatalogueDataState();
}


class _UserBelongCatalogueDataState extends State<UserBelongCatalogueData> {
  final UserService userService = UserService();
  final UserCatalogueService userCatalogueService = UserCatalogueService();

  List<User> userList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserBelongCatalogue();
  }

  // Fetch user belong catalogue
  Future<void> fetchUserBelongCatalogue() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await userService.fetchUsersByCatalogue(widget.catalogue.id);
      setState(() {
        userList = response;
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Update user info
  void showUpdateUserDialog(User user) async {
    List<UserCatalogue> catalogueList = [];
    try {
      catalogueList = await userCatalogueService.fetchUserCatalogue();
    } catch (error) {
      print("Error loading user catalogues: $error");
    }

    TextEditingController firstNameController = TextEditingController(text: user.firstName);
    TextEditingController middleNameController = TextEditingController(text: user.middleName);
    TextEditingController lastNameController = TextEditingController(text: user.lastName);
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController phoneController = TextEditingController(text: user.phone);
    TextEditingController passwordController = TextEditingController(text: user.password);

    int selectedCatalogueId = user.catalogueId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit User"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: "First Name"),
                  ),
                  TextField(
                    controller: middleNameController,
                    decoration: InputDecoration(labelText: "Middle Name"),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: "Last Name"),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: catalogueList.any((catalogue) => catalogue.id == selectedCatalogueId) 
                      ? selectedCatalogueId 
                      : null,
                    decoration: InputDecoration(labelText: "User cataloge"),
                    items: catalogueList.map((cataloge) {
                      return DropdownMenuItem(
                        value: cataloge.id,
                        child: Text(cataloge.name)
                      );
                    }).toList(), 
                    onChanged: (int? newValue) {
                      setStateDialog(() {
                        selectedCatalogueId = newValue!;
                      });
                    }
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await userService.edit(
                        user.id,
                        selectedCatalogueId,
                        firstNameController.text,
                        middleNameController.text,
                        lastNameController.text,
                        emailController.text,
                        phoneController.text,
                        passwordController.text
                      );
                      Navigator.pop(context);
                      fetchUserBelongCatalogue();
                    } catch (e) {
                      print("Error updating user: $e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
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

  // Delete user
  void showDeleteUserDialog(User user) async {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Delete User"),
              content: Text("Are you sure you want to delete user: ${user.email}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() { isLoading = true; }); 

                    await userService.delete(user.id);

                    Navigator.pop(context);
                    fetchUserBelongCatalogue();
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
        title: Text(
          "${widget.catalogue.name}",
          style: TextStyle(color: baseColor),
        ),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: baseColor),
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 20))
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${user.id}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Name: ${user.firstName} ${user.middleName ?? ''} ${user.lastName}",
                        ),
                        SizedBox(height: 4),
                        Text("Email: ${user.email}"),
                        SizedBox(height: 4),
                        Text("Phone: ${user.phone}"),
                        SizedBox(height: 4),
                        Text("Catalogue ID: ${user.catalogueId}"),
                        SizedBox(height: 4),
                        Text("Added By: ${user.addedBy}"),
                        SizedBox(height: 4),
                        Text("Edited By: ${user.editedBy ?? 'N/A'}"),
                        SizedBox(height: 4),
                        Text("Password: ${user.password}"),
                        SizedBox(height: 4),
                        Text("Image: ${user.img}"),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => showUpdateUserDialog(user),
                              icon: Icon(IconlyLight.setting, color: myColor),
                            ),
                            IconButton(
                              onPressed: () => showDeleteUserDialog(user), 
                              icon: Icon(IconlyLight.delete, color: Colors.red,)
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
    );
  }
}
