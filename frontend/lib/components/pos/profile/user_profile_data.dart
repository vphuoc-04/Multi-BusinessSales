import 'package:flutter/material.dart';

// Models
import 'package:frontend/modules/users/models/user.dart';

class UserProfileData extends StatelessWidget{
  final User data;

  const UserProfileData({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            children: [
              Text("${data.lastName} ${data.firstName}")
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              Text("${data.email}"),
              Text("${data.phone}"),
            ],
          ),
        )
      ],
    );
  }
}