import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/shipping_data_table_widget.dart';
import './widgets/shipping_empty_state_widget.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingManagementState();
}

class _ShippingManagementState extends State<ShippingScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock shipping data
  final List<Map<String, dynamic>> _shippingEntries = [
    {
      "id": 1,
      "courierName": "FedEx Express",
      "status": "In Transit",
      "trackingNumber": "FX123456789",
      "destination": "New York, NY",
      "estimatedDelivery": "2024-01-15"
    },
    {
      "id": 2,
      "courierName": "UPS Ground",
      "status": "Delivered",
      "trackingNumber": "UPS987654321",
      "destination": "Los Angeles, CA",
      "estimatedDelivery": "2024-01-12"
    },
    {
      "id": 3,
      "courierName": "DHL Express",
      "status": "Processing",
      "trackingNumber": "DHL555666777",
      "destination": "Chicago, IL",
      "estimatedDelivery": "2024-01-18"
    },
    {
      "id": 4,
      "courierName": "USPS Priority",
      "status": "In Transit",
      "trackingNumber": "USPS123789456",
      "destination": "Miami, FL",
      "estimatedDelivery": "2024-01-16"
    },
    {
      "id": 5,
      "courierName": "Amazon Logistics",
      "status": "Out for Delivery",
      "trackingNumber": "AMZ789123456",
      "destination": "Seattle, WA",
      "estimatedDelivery": "2024-01-14"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,

      drawer: NavigationDrawerWidget(
          currentRoute: '/shipping-screen'), // Add your Drawer widget here

      appBar: _buildAppBar(context), // Pass context

      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 2.0,
      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
      leading: Builder(
        builder: (innerContext) => IconButton(
          icon: CustomIconWidget(
            iconName: 'menu',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => Scaffold.of(innerContext).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Shipping',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRefreshButton(),
              SizedBox(width: 2.w),
              _buildCreateButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        onPressed: _handleRefresh,
        icon: AnimatedRotation(
          turns: _isRefreshing ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        tooltip: 'Refresh Data',
      ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: _handleCreate,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 5.w,
        ),
        label: Text(
          'Create',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefreshIndicator,
      color: AppTheme.lightTheme.colorScheme.primary,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: _shippingEntries.isEmpty
          ? ShippingEmptyStateWidget(onCreatePressed: _handleCreate)
          : ShippingDataTableWidget(
              shippingEntries: _shippingEntries,
              isLoading: _isLoading,
            ),
    );
  }

  void _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Shipping data refreshed successfully',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleRefreshIndicator() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCreate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => _buildCreateBottomSheet(),
    );
  }

  Widget _buildCreateBottomSheet() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Create Shipping Entry',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose how you want to create a new shipping entry.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectCreateOption('manual'),
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Manual Entry'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectCreateOption('scan'),
                  icon: CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Scan Code'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _selectCreateOption('import'),
              icon: CustomIconWidget(
                iconName: 'upload_file',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Import from File'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _selectCreateOption(String option) {
    Navigator.pop(context);

    // Simulate create option selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Create option selected: $option',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppTheme.lightTheme.colorScheme.tertiary,
          onPressed: () {},
        ),
      ),
    );
  }
}
