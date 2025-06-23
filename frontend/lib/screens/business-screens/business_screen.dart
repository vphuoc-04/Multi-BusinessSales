import 'package:flutter/material.dart';
import 'package:frontend/components/business-components/commons/logout_button.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Screens
import 'package:frontend/screens/business-screens/managements/attribute_management_screen.dart';
import 'package:frontend/screens/business-screens/managements/product_brand_management_screen.dart';
import 'package:frontend/screens/business-screens/managements/product_category_management_screen.dart';
import 'package:frontend/screens/business-screens/managements/product_management_screen.dart';
import 'package:frontend/screens/business-screens/managements/supplier_management_screen.dart';
import 'package:frontend/screens/business-screens/managements/user_catalogue_management_screen.dart';

class BusinessScreen extends StatefulWidget {
  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final List<Map<String, dynamic>> menuItems = [
    { 'icon': Icons.shopping_bag, 'label': 'Sản phẩm', 'screen': ProductManagementScreen() },
    { 'icon': Icons.category, 'label': 'Nhóm sản phẩm', 'screen': ProductCategoryManagementScreen() },
    { 'icon': Icons.details, 'label': 'Thuộc tính sản phẩm', 'screen': AttributeManagementScreen() },
    { 'icon': Icons.branding_watermark_outlined, 'label': 'Thương hiệu sản phẩm', 'screen': ProductBrandManagementScreen() },
    { 'icon': Icons.support, 'label': 'Nhà cung cấp', 'screen': SupplierManagementScreen() },
    { 'icon': Icons.people, 'label': 'Nhóm thành viên', 'screen': UserCatalogueManagementScreen() },
  ];

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.start,
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () => _navigateToScreen(item['screen']),
                    child: SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: backgroundColorIcon,
                            child: Icon(
                              item['icon'],
                              color: myColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            Container(
              child: LogoutButton(),
            )            
          ],
        ),
      ),
    );
  }
}
