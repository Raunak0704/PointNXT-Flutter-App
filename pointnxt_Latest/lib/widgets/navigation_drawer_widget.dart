import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
 
// lib/widgets/navigation_drawer_widget.dart

class NavigationDrawerWidget extends StatelessWidget {
  final String currentRoute;

  const NavigationDrawerWidget({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withOpacity(0.9), // Darker by opacity
                    AppTheme.lightTheme.colorScheme.primaryContainer
                        .withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    backgroundImage: AssetImage('assets/images/logo.webp'),
                  ),
                  SizedBox(height: 2.h),
                  RichText(
                    text: TextSpan(
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'point',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'NXT',
                          style: TextStyle(
                            color:
                                Colors.orange, // Or your theme's orange color
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'E-Commerce Management',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildNavigationItem(
                    context,
                    'Dashboard',
                    'dashboard',
                    AppRoutes.dashboardScreen,
                  ),
                  _buildNavigationItem(
                    context,
                    'Inventory',
                    'inventory',
                    AppRoutes.inventoryScreen,
                  ),
                  _buildNavigationItem(
                    context,
                    'Order',
                    'receipt_long',
                    '/order-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Returns',
                    'keyboard_return',
                    '/returns-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Customers',
                    'people',
                    '/customers-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Shipping',
                    'local_shipping',
                    AppRoutes.shippingScreen,
                  ),
                  _buildNavigationItem(
                    context,
                    'Channel',
                    'hub',
                    '/channel-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Integrations',
                    'extension',
                    '/integrations-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Calculators',
                    'calculate',
                    '/calculators-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Whatsapp',
                    'chat',
                    '/whatsapp-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Reports',
                    'assessment',
                    '/reports-screen',
                  ),
                  _buildNavigationItem(
                    context,
                    'Settings',
                    'settings',
                    '/settings-screen',
                  ),
                ],
              ),
            ),

            // Footer Section
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Version 1.0.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildNavigationItem(
    BuildContext context,
    String title,
    String iconName,
    String route,
  ) {
    final isSelected = currentRoute == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          if (route != currentRoute) {
            _navigateToRoute(context, route, title);
          }
        },
      ),
    );
  }

  void _navigateToRoute(BuildContext context, String route, String title) {
    switch (route) {
      case '/dashboard-screen':
      case '/inventory-screen':
      case '/shipping-screen':
        Navigator.pushReplacementNamed(context, route);
        break;
      default:
        // For screens that don't exist yet, show a toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature coming soon'),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
    }
  }
}
