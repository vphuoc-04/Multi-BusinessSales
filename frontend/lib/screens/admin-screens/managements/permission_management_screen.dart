// lib/modules/permissions/screens/permission_management_screen.dart
import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/admin-components/permission-components/permission_data_list.dart';
import 'package:frontend/components/admin-components/permission-components/permission_form.dart';
import 'package:frontend/constants/colors.dart';

class PermissionManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PermissionDataList()),
                )
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: myColor,
                ),
                child: Align(
                  child: Text(
                    "Danh sách quyền",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PermissionForm())
                )
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: myColor,
                ),
                child: Align(
                  child: Text(
                    "Thêm quyền",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}