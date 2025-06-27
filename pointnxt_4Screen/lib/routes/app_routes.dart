import 'package:flutter/material.dart';
import 'package:pointnxt/presentation/password_reset_screen/password_reset_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/inventory_screen/inventory_screen.dart';
import '../presentation/customers_screen/customers_screen.dart';
import '../presentation/channels_screen/channels_screen.dart';
import '../presentation/integrations_screen/integrations_screen.dart';
import '../presentation/shipping_screen/shipping_screen.dart';

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
  };
}
