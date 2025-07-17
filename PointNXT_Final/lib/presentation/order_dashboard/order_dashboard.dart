import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/order_card_widget.dart';
import './widgets/status_filter_chip_widget.dart';

class OrderDashboard extends StatefulWidget {
  const OrderDashboard({super.key});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'All';
  bool _isRefreshing = false;

  // Mock data for orders
  final List<Map<String, dynamic>> _orders = [
    {
      "id": "ORD-2024-001",
      "customerName": "Sarah Johnson",
      "status": "pending",
      "totalAmount": "\$125.99",
      "timestamp": "2 hours ago",
      "items": 3,
      "priority": false,
    },
    {
      "id": "ORD-2024-002",
      "customerName": "Michael Chen",
      "status": "completed",
      "totalAmount": "\$89.50",
      "timestamp": "4 hours ago",
      "items": 2,
      "priority": true,
    },
    {
      "id": "ORD-2024-003",
      "customerName": "Emma Rodriguez",
      "status": "processing",
      "totalAmount": "\$234.75",
      "timestamp": "6 hours ago",
      "items": 5,
      "priority": false,
    },
    {
      "id": "ORD-2024-004",
      "customerName": "David Wilson",
      "status": "shipped",
      "totalAmount": "\$67.25",
      "timestamp": "1 day ago",
      "items": 1,
      "priority": false,
    },
    {
      "id": "ORD-2024-005",
      "customerName": "Lisa Thompson",
      "status": "cancelled",
      "totalAmount": "\$156.80",
      "timestamp": "2 days ago",
      "items": 4,
      "priority": true,
    },
  ];

  // Mock metrics data
  final Map<String, dynamic> _metricsData = {
    "todayOrders": 24,
    "pendingFulfillment": 8,
    "todayRevenue": "\$3,247.50",
    "lastSyncTime": "2 minutes ago",
  };

  final List<String> _statusFilters = [
    'All',
    'Pending',
    'Processing',
    'Shipped',
    'Completed',
    'Cancelled'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filtered = _orders;

    if (_selectedStatusFilter != 'All') {
      filtered = filtered
          .where((order) => (order['status'] as String)
              .toLowerCase()
              .contains(_selectedStatusFilter.toLowerCase()))
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((order) =>
              (order['customerName'] as String)
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              (order['id'] as String)
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/inventory-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/product-catalog');
        break;
      case 3:
        // Analytics tab - placeholder
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: NavigationDrawerWidget(currentRoute: '/order-dashboard'),
      appBar: _buildAppBar(),
      body: _buildBody(),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false, // <== prevents duplicate drawer icon

      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          // Builder for opening the drawer
          Builder(
            builder: (innerContext) => IconButton(
              icon: CustomIconWidget(
                iconName: 'menu',
                color: AppTheme.darkTheme.colorScheme.onPrimary,
                size: 24,
              ),
              onPressed: () => Scaffold.of(innerContext).openDrawer(),
            ),
          ),
          SizedBox(width: 2.w), // Space between icon and title
          Text(
            'Orders',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withAlpha(25), // Fix invalid withValues
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  'Online',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Column(
        children: [
          _buildSearchAndFilter(),
          _buildMetricsCards(),
          _buildStatusFilters(),
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search orders or customers...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/barcode-scanner'),
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Filter functionality
              },
              icon: CustomIconWidget(
                iconName: 'tune',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: MetricsCardWidget(
              title: 'Today\'s Orders',
              value: _metricsData['todayOrders'].toString(),
              icon: 'shopping_bag',
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: MetricsCardWidget(
              title: 'Pending',
              value: _metricsData['pendingFulfillment'].toString(),
              icon: 'pending',
              color: AppTheme.getStatusColor('warning'),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: MetricsCardWidget(
              title: 'Revenue',
              value: _metricsData['todayRevenue'] as String,
              icon: 'attach_money',
              color: AppTheme.getStatusColor('success'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _statusFilters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = _statusFilters[index];
          final isSelected = _selectedStatusFilter == filter;
          final count = filter == 'All'
              ? _orders.length
              : _orders
                  .where((order) => (order['status'] as String)
                      .toLowerCase()
                      .contains(filter.toLowerCase()))
                  .length;

          return StatusFilterChipWidget(
            label: filter,
            count: count,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedStatusFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: _filteredOrders.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return OrderCardWidget(
          order: order,
          onTap: () => Navigator.pushNamed(context, '/order-details'),
          onSwipeRight: () => _showQuickActions(order),
          onSwipeLeft: () => _togglePriority(order),
          onLongPress: () => _showContextMenu(order),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inbox',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No orders found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first order to get started',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () {
              // Create new order
            },
            icon: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 20,
            ),
            label: const Text('Create Order'),
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     currentIndex: _selectedTabIndex,
  //     onTap: _onTabTapped,
  //     type: BottomNavigationBarType.fixed,
  //     backgroundColor:
  //         AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
  //     selectedItemColor:
  //         AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
  //     unselectedItemColor:
  //         AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
  //     items: [
  //       BottomNavigationBarItem(
  //         icon: CustomIconWidget(
  //           iconName: 'receipt_long',
  //           color: _selectedTabIndex == 0
  //               ? AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.selectedItemColor!
  //               : AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
  //           size: 24,
  //         ),
  //         label: 'Orders',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: CustomIconWidget(
  //           iconName: 'inventory_2',
  //           color: _selectedTabIndex == 1
  //               ? AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.selectedItemColor!
  //               : AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
  //           size: 24,
  //         ),
  //         label: 'Inventory',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: CustomIconWidget(
  //           iconName: 'people',
  //           color: _selectedTabIndex == 2
  //               ? AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.selectedItemColor!
  //               : AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
  //           size: 24,
  //         ),
  //         label: 'Customers',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: CustomIconWidget(
  //           iconName: 'analytics',
  //           color: _selectedTabIndex == 3
  //               ? AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.selectedItemColor!
  //               : AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
  //           size: 24,
  //         ),
  //         label: 'Analytics',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: CustomIconWidget(
  //           iconName: 'more_horiz',
  //           color: _selectedTabIndex == 4
  //               ? AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.selectedItemColor!
  //               : AppTheme
  //                   .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
  //           size: 24,
  //         ),
  //         label: 'More',
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Create new order
      },
      backgroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
      foregroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 20,
      ),
      label: const Text('New Order'),
    );
  }

  void _showQuickActions(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.getStatusColor('success'),
                size: 24,
              ),
              title: const Text('Mark as Shipped'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Contact Customer'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/order-details');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _togglePriority(Map<String, dynamic> order) {
    setState(() {
      order['priority'] = !(order['priority'] as bool);
    });
  }

  void _showContextMenu(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Actions'),
        content: const Text('Select an action for this order'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Bulk selection logic
            },
            child: const Text('Select Multiple'),
          ),
        ],
      ),
    );
  }
}
