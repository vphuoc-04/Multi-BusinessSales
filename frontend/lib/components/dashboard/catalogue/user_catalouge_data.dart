import 'package:flutter/material.dart';

// Models
import 'package:frontend/modules/users/models/user_catalogue.dart';

class UserCatalougeData extends StatelessWidget {
  final List<UserCatalogue> userCataloguesList;

  const UserCatalougeData({super.key, required this.userCataloguesList});

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
        );
      },
    );
  }
}
