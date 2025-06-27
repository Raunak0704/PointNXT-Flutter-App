import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_feed_widget.dart';
import './widgets/chart_section_widget.dart';
import './widgets/summary_card_widget.dart';

// lib/presentation/dashboard_screen/dashboard_screen.dart

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSyncing = false;
  String _selectedPeriod = '7';
  late TabController _tabController;

  // Mock data for dashboard
  final List<Map<String, dynamic>> summaryData = [
    {
      "title": "Total Orders",
      "value": "1,247",
      "change": "+12.5%",
      "isPositive": true,
      "color": AppTheme.primaryLight,
      "icon": "shopping_cart"
    },
    {
      "title": "Pending Orders",
      "value": "89",
      "change": "-5.2%",
      "isPositive": false,
      "color": AppTheme.warningLight,
      "icon": "pending"
    },
    {
      "title": "Shipped Orders",
      "value": "1,158",
      "change": "+18.3%",
      "isPositive": true,
      "color": AppTheme.successLight,
      "icon": "local_shipping"
    },
    {
      "title": "Returns",
      "value": "23",
      "change": "+2.1%",
      "isPositive": false,
      "color": AppTheme.errorLight,
      "icon": "keyboard_return"
    }
  ];

  final List<Map<String, dynamic>> recentActivity = [
    {
      "id": "ORD-2024-001",
      "customerName": "John Smith",
      "customerInitials": "JS",
      "amount": "\$125.99",
      "status": "shipped",
      "date": "2 hours ago",
      "items": 3
    },
    {
      "id": "ORD-2024-002",
      "customerName": "Sarah Johnson",
      "customerInitials": "SJ",
      "amount": "\$89.50",
      "status": "pending",
      "date": "4 hours ago",
      "items": 2
    },
    {
      "id": "ORD-2024-003",
      "customerName": "Mike Davis",
      "customerInitials": "MD",
      "amount": "\$234.75",
      "status": "delivered",
      "date": "6 hours ago",
      "items": 5
    },
    {
      "id": "ORD-2024-004",
      "customerName": "Emily Wilson",
      "customerInitials": "EW",
      "amount": "\$67.25",
      "status": "cancelled",
      "date": "8 hours ago",
      "items": 1
    },
    {
      "id": "ORD-2024-005",
      "customerName": "David Brown",
      "customerInitials": "DB",
      "amount": "\$156.80",
      "status": "processing",
      "date": "1 day ago",
      "items": 4
    }
  ];

  final List<FlSpot> chartData7Days = [
    FlSpot(0, 45),
    FlSpot(1, 52),
    FlSpot(2, 38),
    FlSpot(3, 67),
    FlSpot(4, 59),
    FlSpot(5, 73),
    FlSpot(6, 81),
  ];

  final List<FlSpot> chartData30Days = [
    FlSpot(0, 120),
    FlSpot(5, 145),
    FlSpot(10, 132),
    FlSpot(15, 178),
    FlSpot(20, 165),
    FlSpot(25, 189),
    FlSpot(29, 201),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {});

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {});
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
    });

    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSyncing = false;
    });

    Fluttertoast.showToast(
      msg: "Data synced successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _onRefresh() async {
    await _loadDashboardData();
  }

  void _createOrder() {
    Fluttertoast.showToast(
      msg: "Create Order feature coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showQuickActions(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
              'Quick Actions for ${order["id"]}',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "View Details");
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.successLight,
                size: 24,
              ),
              title: const Text('Mark as Shipped'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Marked as Shipped");
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'print',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('Print Label'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Printing Label");
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: const NavigationDrawerWidget(
        currentRoute: '/dashboard-screen',
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Sticky Header
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                elevation: 0,
                toolbarHeight: 8.h,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: CustomIconWidget(
                      iconName: 'menu',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                flexibleSpace: Container(
                  alignment:
                      Alignment.center, // Entire content vertically centered
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Children vertically centered
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: Text(
                            'Dashboard',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_isSyncing)
                            SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _syncData,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'sync',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.successLight.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'wifi',
                              color: AppTheme.successLight,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Summary Cards Section
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 20.h,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: summaryData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: SummaryCardWidget(
                              data: summaryData[index],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Page Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        summaryData.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          width: _currentPage == index ? 6.w : 2.w,
                          height: 1.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Charts Section
              SliverToBoxAdapter(
                child: ChartSectionWidget(
                  selectedPeriod: _selectedPeriod,
                  chartData7Days: chartData7Days,
                  chartData30Days: chartData30Days,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                ),
              ),

              // Recent Activity Section
              SliverToBoxAdapter(
                child: ActivityFeedWidget(
                  activities: recentActivity,
                  onActivityLongPress: _showQuickActions,
                ),
              ),

              // Bottom spacing for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _syncData,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            elevation: 4,
            icon: _isSyncing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'sync',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
            label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
          ),
          SizedBox(height: 2.h),
          FloatingActionButton.extended(
            onPressed: _createOrder,
            backgroundColor: AppTheme.secondaryLight,
            foregroundColor: Colors.white,
            elevation: 6,
            icon: CustomIconWidget(
              iconName: 'add_shopping_cart',
              color: Colors.white,
              size: 24,
            ),
            label: const Text('Create Order'),
          ),
        ],
      ),
    );
  }
}
