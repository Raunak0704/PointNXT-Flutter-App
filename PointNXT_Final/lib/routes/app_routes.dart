import 'package:flutter/material.dart';
import '../presentation/password_reset_screen/password_reset_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/inventory_screen/inventory_screen.dart';
import '../presentation/customers_screen/customers_screen.dart';
import '../presentation/channels_screen/channels_screen.dart';
import '../presentation/integrations_screen/integrations_screen.dart';
import '../presentation/shipping_screen/shipping_screen.dart';
import '../presentation/order_dashboard/order_dashboard.dart';
import '../presentation/returns_management/returns_management.dart';
import '../presentation/profit_calculator_screen/profit_calculator_screen.dart';
import '../presentation/shipping_calculator_screen/shipping_calculator_screen.dart';
import '../presentation/order_details/order_details.dart';
import '../presentation/settings/settings.dart';
import '../presentation/product_catalog/product_catalog.dart';
import '../presentation/inventory_management/inventory_management.dart';
import '../presentation/barcode_scanner/barcode_scanner.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String inventoryScreen = '/inventory-screen';
  static const String shippingScreen = '/shipping-screen';
  static const String passwordResetScreen = '/password-reset-screen';
  static const String integrationsScreen = '/integrations-screen';
  static const String channelsScreen = '/channels-screen';
  static const String customersScreen = '/customers-screen';
  static const String returnsManagementScreen = '/returns-management-screen';
  static const String profitCalculatorScreen = '/profit-calculator-screen';
  static const String shippingCalculatorScreen = '/shipping-calculator-screen';
  static const String orderDashboard = '/order-dashboard';
  static const String orderDetails = '/order-details';
  static const String inventoryManagement = '/inventory-management';
  static const String productCatalog = '/product-catalog';
  static const String barcodeScanner = '/barcode-scanner';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    passwordResetScreen: (context) => const PasswordResetScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    inventoryScreen: (context) => const InventoryScreen(),
    shippingScreen: (context) => const ShippingScreen(),
    integrationsScreen: (context) => const IntegrationsScreen(),
    channelsScreen: (context) => const ChannelsScreen(),
    customersScreen: (context) => const CustomersScreen(),
    returnsManagementScreen: (context) => const ReturnsManagement(),
    profitCalculatorScreen: (context) => const ProfitCalculatorScreen(),
    shippingCalculatorScreen: (context) => const ShippingCalculatorScreen(),
    orderDashboard: (context) => const OrderDashboard(),
    orderDetails: (context) => const OrderDetails(),
    inventoryManagement: (context) => const InventoryManagement(),
    productCatalog: (context) => const ProductCatalog(),
    barcodeScanner: (context) => const BarcodeScanner(),
    settings: (context) => const Settings(),
  };
}
