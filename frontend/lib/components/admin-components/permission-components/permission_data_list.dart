// lib/modules/permissions/screens/permission_list_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/modules/permissions/models/permission.dart';
import 'package:frontend/modules/permissions/services/permission_service.dart';

class PermissionDataList extends StatefulWidget {
  @override
  _PermissionDataListState createState() => _PermissionDataListState();
}

class _PermissionDataListState extends State<PermissionDataList> {
  final PermissionService _permissionService = PermissionService();
  List<Permission> _permissions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissions();
  }

  Future<void> _fetchPermissions() async {
    setState(() => _isLoading = true);
    try {
      final permissions = await _permissionService.fetchPermissions();
      setState(() {
        _permissions = permissions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching permissions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Quyền'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _permissions.length,
              itemBuilder: (context, index) {
                final permission = _permissions[index];
                return ListTile(
                  title: Text(permission.name),
                  subtitle: Text(permission.description),
                );
              },
            ),
    );
  }
}