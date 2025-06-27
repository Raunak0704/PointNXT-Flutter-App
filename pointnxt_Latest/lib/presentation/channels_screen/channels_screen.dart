import '../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/channels_data_table_widget.dart';
import './widgets/channels_empty_state_widget.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreen();
}

class _ChannelsScreen extends State<ChannelsScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock channels data
  final List<Map<String, dynamic>> _channels = [
    {
      "id": 1,
      "channelIcon": "shopify",
      "channelName": "Shop1",
      "status": "Active",
      "manageStock": false,
      "orderStatusSync": false,
      "platform": "Shopify"
    },
    {
      "id": 2,
      "channelIcon": "woocommerce",
      "channelName": "WooCommerce Store",
      "status": "Active",
      "manageStock": true,
      "orderStatusSync": true,
      "platform": "WooCommerce"
    },
    {
      "id": 3,
      "channelIcon": "amazon",
      "channelName": "Amazon Seller",
      "status": "Inactive",
      "manageStock": false,
      "orderStatusSync": false,
      "platform": "Amazon"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: NavigationDrawerWidget(
          currentRoute: '/channels-screen'), // Add your Drawer widget here
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
            'Channels',
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
      child: _channels.isEmpty
          ? ChannelsEmptyStateWidget(onCreatePressed: _handleCreate)
          : ChannelsDataTableWidget(
              channels: _channels,
              isLoading: _isLoading,
              onToggleStock: _handleToggleStock,
              onToggleOrderSync: _handleToggleOrderSync,
              onEditChannel: _handleEditChannel,
              onDeleteChannel: _handleDeleteChannel,
              onSettingsChannel: _handleSettingsChannel,
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
            'Channels data refreshed successfully',
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
            'Create Channel Integration',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Connect a new e-commerce platform to manage your channels.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectChannelType('shopify'),
                  icon: CustomIconWidget(
                    iconName: 'store',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Shopify'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectChannelType('woocommerce'),
                  icon: CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('WooCommerce'),
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
              onPressed: () => _selectChannelType('custom'),
              icon: CustomIconWidget(
                iconName: 'integration_instructions',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Custom Integration'),
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

  void _selectChannelType(String channelType) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Channel type selected: $channelType',
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

  void _handleToggleStock(int channelId, bool value) {
    setState(() {
      final channelIndex = _channels.indexWhere((c) => c['id'] == channelId);
      if (channelIndex != -1) {
        _channels[channelIndex]['manageStock'] = value;
      }
    });
  }

  void _handleToggleOrderSync(int channelId, bool value) {
    setState(() {
      final channelIndex = _channels.indexWhere((c) => c['id'] == channelId);
      if (channelIndex != -1) {
        _channels[channelIndex]['orderStatusSync'] = value;
      }
    });
  }

  void _handleEditChannel(int channelId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit channel: $channelId',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _handleDeleteChannel(int channelId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Channel'),
        content: Text(
            'Are you sure you want to delete this channel? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _channels.removeWhere((c) => c['id'] == channelId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Channel deleted successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleSettingsChannel(int channelId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings for channel: $channelId',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
