import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './controller/orders_management_controller.dart';
import './widgets/orders_action_buttons_widget.dart';
import './widgets/orders_header_widget.dart';
import './widgets/orders_search_bar_widget.dart';
import './widgets/orders_table_widget.dart';

class OrdersManagement extends StatelessWidget {
  const OrdersManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersManagementController());
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      //Added these 3 lines for changes to make the hamburger menu work
      drawer: NavigationDrawerWidget(
        currentRoute: AppRoutes.ordersManagementScreen,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            OrdersHeaderWidget(),

            // Main content
            Expanded(
              child: Obx(() => RefreshIndicator(
                    onRefresh: controller.refreshOrders,
                    child: Column(
                      children: [
                        // Action buttons
                        OrdersActionButtonsWidget(),

                        SizedBox(height: 2.h),

                        // Search bar
                        OrdersSearchBarWidget(),

                        SizedBox(height: 2.h),

                        // Orders table
                        Expanded(
                          child: OrdersTableWidget(),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.find<OrdersManagementController>().createOrder(),
        backgroundColor: AppTheme.secondaryLight,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
