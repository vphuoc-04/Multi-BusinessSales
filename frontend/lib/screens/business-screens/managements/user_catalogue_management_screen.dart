import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/business-components/catalogue-components/user_catalouge_data.dart';
import 'package:frontend/components/business-components/catalogue-components/add_user_form.dart';
import 'package:frontend/components/business-components/catalogue-components/user_belong_catalogue_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user_catalogue.dart';

// Services
import 'package:frontend/modules/users/services/user_catalogue_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class UserCatalogueManagementScreen extends StatefulWidget {
  @override
  _UserCatalogueManagementScreenState createState() => _UserCatalogueManagementScreenState();
}

class _UserCatalogueManagementScreenState extends State<UserCatalogueManagementScreen> {
  final UserCatalogueService userCatalogueService = UserCatalogueService();

  final TextEditingController nameController = TextEditingController();

  List<UserCatalogue> userCataloguesList = [];

  int publishStatus = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserCatalogueData();
  }

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
        await fetchUserCatalogueData();
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

  // Fetch user catalogue data
  Future<void> fetchUserCatalogueData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await userCatalogueService.fetchUserCatalogue();

      setState(() {
        userCataloguesList = response;
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

  // Update user catalogue
  void showUpdateDialog(UserCatalogue group) {
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

                    await userCatalogueService.update(group.id, nameController.text, publishStatus);

                    Navigator.pop(context);
                    fetchUserCatalogueData();
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

  // Delete user catalogue
  void showDeleteDialog(UserCatalogue group) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Delete Group"),
              content: Text("Are you sure you want to delete the group ${group.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() { isLoading = true; }); 

                    await userCatalogueService.delete(group.id);

                    Navigator.pop(context);
                    fetchUserCatalogueData();
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
        title: Text("Nhóm thành viên"),
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
                //Text("User catalogue"),
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
                      addUserCatalogue()
                    },
                    child: isLoading
                      ? LoadingWidget(size: 15, color: baseColor)
                      : Text("Thêm nhóm thành viên", style: TextStyle(color: Colors.white),)
                    , 
                  ),
                ),
                SizedBox(height: 50),
                Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingWidget(size: 20, color: myColor),
                      )
                    : UserCatalougeData(
                        userCataloguesList: userCataloguesList,
                        showUpdateDialog: showUpdateDialog,
                        showDeleteDialog: showDeleteDialog,
                        onTapCatalogue: (UserCatalogue catalogue) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserBelongCatalogueData(catalogue: catalogue),
                            ),
                          );
                        },
                        ontTapAddUserToCatalogue: (UserCatalogue cataloge) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUserForm(catalogueId: cataloge.id)
                            ),
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