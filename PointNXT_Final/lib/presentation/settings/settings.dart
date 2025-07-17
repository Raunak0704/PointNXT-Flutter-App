import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "John Smith",
    "email": "john.smith@orderflow.com",
    "businessName": "Smith Electronics",
    "avatar":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
    "subscriptionPlan": "Pro Plan",
    "subscriptionStatus": "Active"
  };

  // Settings state
  bool orderNotifications = true;
  bool inventoryAlerts = true;
  bool customerMessages = false;
  bool marketingCommunications = true;
  bool biometricAuth = false;
  bool twoFactorAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              UserProfileWidget(
                userData: userData,
                onEditProfile: () => _showEditProfileDialog(),
              ),

              SizedBox(height: 3.h),

              // Account Section
              SettingsSectionWidget(
                title: 'Account',
                children: [
                  SettingsItemWidget(
                    iconName: 'business',
                    title: 'Business Information',
                    subtitle: userData["businessName"] as String,
                    onTap: () => _navigateToBusinessInfo(),
                  ),
                  SettingsItemWidget(
                    iconName: 'card_membership',
                    title: 'Subscription',
                    subtitle:
                        '${userData["subscriptionPlan"]} - ${userData["subscriptionStatus"]}',
                    onTap: () => _navigateToSubscription(),
                  ),
                  SettingsItemWidget(
                    iconName: 'payment',
                    title: 'Payment Methods',
                    subtitle: 'Manage payment options',
                    onTap: () => _navigateToPaymentMethods(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Notifications Section
              SettingsSectionWidget(
                title: 'Notifications',
                children: [
                  SettingsItemWidget(
                    iconName: 'notifications',
                    title: 'Order Updates',
                    subtitle: 'Get notified about order status changes',
                    isSwitch: true,
                    switchValue: orderNotifications,
                    onSwitchChanged: (value) {
                      setState(() {
                        orderNotifications = value;
                      });
                      _showFeedback(
                          'Order notifications ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'inventory',
                    title: 'Inventory Alerts',
                    subtitle: 'Low stock and reorder notifications',
                    isSwitch: true,
                    switchValue: inventoryAlerts,
                    onSwitchChanged: (value) {
                      setState(() {
                        inventoryAlerts = value;
                      });
                      _showFeedback(
                          'Inventory alerts ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'message',
                    title: 'Customer Messages',
                    subtitle: 'New customer inquiries and messages',
                    isSwitch: true,
                    switchValue: customerMessages,
                    onSwitchChanged: (value) {
                      setState(() {
                        customerMessages = value;
                      });
                      _showFeedback(
                          'Customer messages ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'campaign',
                    title: 'Marketing Communications',
                    subtitle: 'Promotional offers and updates',
                    isSwitch: true,
                    switchValue: marketingCommunications,
                    onSwitchChanged: (value) {
                      setState(() {
                        marketingCommunications = value;
                      });
                      _showFeedback(
                          'Marketing communications ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Business Configuration Section
              SettingsSectionWidget(
                title: 'Business',
                children: [
                  SettingsItemWidget(
                    iconName: 'calculate',
                    title: 'Tax Settings',
                    subtitle: 'Configure tax rates and rules',
                    onTap: () => _navigateToTaxSettings(),
                  ),
                  SettingsItemWidget(
                    iconName: 'attach_money',
                    title: 'Currency',
                    subtitle: 'USD - United States Dollar',
                    onTap: () => _navigateToCurrencySettings(),
                  ),
                  SettingsItemWidget(
                    iconName: 'local_shipping',
                    title: 'Shipping Options',
                    subtitle: 'Delivery methods and rates',
                    onTap: () => _navigateToShippingSettings(),
                  ),
                  SettingsItemWidget(
                    iconName: 'integration_instructions',
                    title: 'Integrations',
                    subtitle: 'Connect with external services',
                    onTap: () => _navigateToIntegrations(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Security Section
              SettingsSectionWidget(
                title: 'Security',
                children: [
                  SettingsItemWidget(
                    iconName: 'fingerprint',
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face recognition',
                    isSwitch: true,
                    switchValue: biometricAuth,
                    onSwitchChanged: (value) {
                      setState(() {
                        biometricAuth = value;
                      });
                      _showFeedback(
                          'Biometric authentication ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'security',
                    title: 'Two-Factor Authentication',
                    subtitle: 'Extra security for your account',
                    isSwitch: true,
                    switchValue: twoFactorAuth,
                    onSwitchChanged: (value) {
                      setState(() {
                        twoFactorAuth = value;
                      });
                      _showFeedback(
                          'Two-factor authentication ${value ? 'enabled' : 'disabled'}');
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'timer',
                    title: 'Session Timeout',
                    subtitle: 'Auto-logout after 30 minutes',
                    onTap: () => _navigateToSessionSettings(),
                  ),
                  SettingsItemWidget(
                    iconName: 'vpn_key',
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () => _navigateToChangePassword(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Support Section
              SettingsSectionWidget(
                title: 'Support',
                children: [
                  SettingsItemWidget(
                    iconName: 'help',
                    title: 'Help & Documentation',
                    subtitle: 'User guides and tutorials',
                    onTap: () => _navigateToHelp(),
                  ),
                  SettingsItemWidget(
                    iconName: 'contact_support',
                    title: 'Contact Support',
                    subtitle: 'Get help from our team',
                    onTap: () => _navigateToContactSupport(),
                  ),
                  SettingsItemWidget(
                    iconName: 'feedback',
                    title: 'Send Feedback',
                    subtitle: 'Share your thoughts and suggestions',
                    onTap: () => _navigateToFeedback(),
                  ),
                  SettingsItemWidget(
                    iconName: 'info',
                    title: 'App Version',
                    subtitle: 'OrderFlow v2.1.0 (Build 2024.1)',
                    onTap: () => _showVersionInfo(),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Logout Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorLight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content:
            Text('Profile editing functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? Make sure all your data is synced before logging out.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/order-dashboard',
                (route) => false,
              );
              _showFeedback('Logged out successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('App Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OrderFlow'),
            Text('Version: 2.1.0'),
            Text('Build: 2024.1'),
            SizedBox(height: 1.h),
            Text('© 2024 OrderFlow Technologies'),
            Text('All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Navigation methods
  void _navigateToBusinessInfo() {
    _showFeedback('Navigating to Business Information');
  }

  void _navigateToSubscription() {
    _showFeedback('Navigating to Subscription Management');
  }

  void _navigateToPaymentMethods() {
    _showFeedback('Navigating to Payment Methods');
  }

  void _navigateToTaxSettings() {
    _showFeedback('Navigating to Tax Settings');
  }

  void _navigateToCurrencySettings() {
    _showFeedback('Navigating to Currency Settings');
  }

  void _navigateToShippingSettings() {
    _showFeedback('Navigating to Shipping Settings');
  }

  void _navigateToIntegrations() {
    _showFeedback('Navigating to Integrations');
  }

  void _navigateToSessionSettings() {
    _showFeedback('Navigating to Session Settings');
  }

  void _navigateToChangePassword() {
    _showFeedback('Navigating to Change Password');
  }

  void _navigateToHelp() {
    _showFeedback('Navigating to Help & Documentation');
  }

  void _navigateToContactSupport() {
    _showFeedback('Navigating to Contact Support');
  }

  void _navigateToFeedback() {
    _showFeedback('Navigating to Send Feedback');
  }
}
