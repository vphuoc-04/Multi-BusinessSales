import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Services
import 'package:frontend/modules/users/services/user_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class UserAdded extends StatefulWidget {
  final int catalogueId;

  UserAdded({required this.catalogueId});

  @override
  _UserAddedState createState() => _UserAddedState();
}

class _UserAddedState extends State<UserAdded> {
  final UserService userService = UserService();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> addUser() async {
    setState(() { isLoading = true; });

    final response = await userService.add(
      widget.catalogueId,
      firstNameController.text,
      middleNameController.text,
      lastNameController.text,
      emailController.text,
      phoneController.text,
      passwordController.text,
    );

    setState(() { isLoading = false; });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User added successfully!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message'] ?? "Failed to add user"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User to Catalogue")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: middleNameController, decoration: InputDecoration(labelText: "Middle Name")),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addUser,
              child: isLoading 
                ? LoadingWidget(
                    size: 10, 
                    color: myColor
                  ) 
                : Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }
}
