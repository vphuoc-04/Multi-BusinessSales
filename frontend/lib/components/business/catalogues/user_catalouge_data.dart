import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user_catalogue.dart';

class UserCatalougeData extends StatelessWidget {
  final List<UserCatalogue> userCataloguesList;
  final Function(UserCatalogue) showUpdateDialog;
  final Function(UserCatalogue) showDeleteDialog;
  final Function(UserCatalogue) onTapCatalogue;
    final Function(UserCatalogue) ontTapAddUserToCatalogue;

  const UserCatalougeData({
    super.key, 
    required this.userCataloguesList,
    required this.showUpdateDialog,
    required this.showDeleteDialog,
    required this.onTapCatalogue,
    required this.ontTapAddUserToCatalogue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCataloguesList.length,
      itemBuilder: (context, index) {
        final group = userCataloguesList[index];
        return ListTile(
          title: Text(group.name),
          subtitle: Text("Status: ${group.publish == 1
              ? "Active"
              : group.publish == 0
                  ? "Inactive"
                  : "Archived"}"),
          onTap: () => onTapCatalogue(group),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => ontTapAddUserToCatalogue(group),
                icon: Icon(IconlyLight.add_user, color: myColor),
              ),
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
