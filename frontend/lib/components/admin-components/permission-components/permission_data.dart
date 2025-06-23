// lib/modules/permissions/data/permission_data.dart

class PermissionData {
  static const Map<String, String> permissionTypes = {
    'users': 'users',
    'user_catalogues': 'user_catalogues',
    'products': 'products',
    'product_brands': 'product_brands',
    'product_categories': 'product_categories',
    'attributes': 'attributes',
    'attribute_values': 'attribute_values',
    'permissions': 'permissions',
  };

  static const List<String> actions = [
    'store',
    'update',
    'delete',
    'show',
    'index',
  ];

  static const Map<int, String> publishStatus = {
    0: 'Inactive',
    1: 'Active',
    2: 'Archived',
  };
}