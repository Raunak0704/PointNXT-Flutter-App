import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/customer_data_table_widget.dart';
import './widgets/empty_state_widget.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomersScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock customer data
  final List<Map<String, dynamic>> _customers = [
    {
      "id": 1,
      "channel": "Online",
      "email": "john.doe@email.com",
      "firstName": "John",
      "lastName": "Doe",
      "phone": "+1 (555) 123-4567"
    },
    {
      "id": 2,
      "channel": "Store",
      "email": "jane.smith@email.com",
      "firstName": "Jane",
      "lastName": "Smith",
      "phone": "+1 (555) 987-6543"
    },
    {
      "id": 3,
      "channel": "Phone",
      "email": "mike.johnson@email.com",
      "firstName": "Mike",
      "lastName": "Johnson",
      "phone": "+1 (555) 456-7890"
    },
    {
      "id": 4,
      "channel": "Online",
      "email": "sarah.wilson@email.com",
      "firstName": "Sarah",
      "lastName": "Wilson",
      "phone": "+1 (555) 321-0987"
    },
    {
      "id": 5,
      "channel": "Store",
      "email": "david.brown@email.com",
      "firstName": "David",
      "lastName": "Brown",
      "phone": "+1 (555) 654-3210"
    },
    {
      "id": 6,
      "channel": "Online",
      "email": "emily.davis@email.com",
      "firstName": "Emily",
      "lastName": "Davis",
      "phone": "+1 (555) 789-0123"
    },
    {
      "id": 7,
      "channel": "Phone",
      "email": "robert.miller@email.com",
      "firstName": "Robert",
      "lastName": "Miller",
      "phone": "+1 (555) 234-5678"
    },
    {
      "id": 8,
      "channel": "Store",
      "email": "lisa.garcia@email.com",
      "firstName": "Lisa",
      "lastName": "Garcia",
      "phone": "+1 (555) 876-5432"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: NavigationDrawerWidget(
          currentRoute: '/customers-screen'), // Add your Drawer widget here
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
            'Customers',
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
              _buildImportButton(),
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

  Widget _buildImportButton() {
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
        onPressed: _handleImport,
        icon: CustomIconWidget(
          iconName: 'upload_file',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 5.w,
        ),
        label: Text(
          'Import',
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
      child: _customers.isEmpty
          ? EmptyStateWidget(onImportPressed: _handleImport)
          : CustomerDataTableWidget(
              customers: _customers,
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
            'Customer data refreshed successfully',
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

  void _handleImport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => _buildImportBottomSheet(),
    );
  }

  Widget _buildImportBottomSheet() {
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
            'Import Customers',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Select a file to import customer data. Supported formats: CSV, Excel (.xlsx)',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectFile('csv'),
                  icon: CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('CSV File'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectFile('excel'),
                  icon: CustomIconWidget(
                    iconName: 'table_chart',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Excel File'),
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
              onPressed: () => _selectFile('any'),
              icon: CustomIconWidget(
                iconName: 'folder_open',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Browse Files'),
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

  void _selectFile(String fileType) {
    Navigator.pop(context);

    // Simulate file selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'File picker opened for $fileType files',
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
