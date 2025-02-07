import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user_catalogue.dart';
import 'package:iconly/iconly.dart';

class UserCatalougeData extends StatelessWidget {
  final List<UserCatalogue> userCataloguesList;
  final Function(UserCatalogue) showUpdateDialog;
  final Function(UserCatalogue) showDeleteDialog;

  const UserCatalougeData({
    super.key, 
    required this.userCataloguesList,
    required this.showUpdateDialog,
    required this.showDeleteDialog
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCataloguesList.length,
      itemBuilder: (context, index) {
        final group = userCataloguesList[index];
        return ListTile(
          title: Text(group.name),
          subtitle: Text(group.publish == 1
              ? "Active"
              : group.publish == 0
                  ? "Inactive"
                  : "Archived"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => showUpdateDialog(group),
                icon: Icon(IconlyLight.setting, color: myColor),
              ),
              IconButton(
                onPressed: () => showDeleteDialog(group),
                icon: Icon(IconlyLight.delete, color: Colors.red),
              ),
            ],
          )
        );
      },
    );
  }
}
