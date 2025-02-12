import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user.dart';

// Services
import 'package:frontend/modules/users/services/user_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class UserBelongCatalogueData extends StatefulWidget {
  final int catalogueId;

  const UserBelongCatalogueData({super.key, required this.catalogueId});

  @override
  _UserBelongCatalogueDataState createState() => _UserBelongCatalogueDataState();
}

class _UserBelongCatalogueDataState extends State<UserBelongCatalogueData> {
  final UserService userService = UserService();

  List<User> userList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserBelongCatalogue();
  }

  Future<void> fetchUserBelongCatalogue() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await userService.fetchUsersByCatalogue(widget.catalogueId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users in Catalogue",
          style: TextStyle(color: baseColor),
        ),
        backgroundColor: myColor,
      ),
      body: isLoading
          ? Center(child: LoadingWidget(color: myColor, size: 20))
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text("${user.firstName + " " + user.lastName}"),
                  subtitle: Text(user.email),
                );
              },
            ),
    );
  }
}
