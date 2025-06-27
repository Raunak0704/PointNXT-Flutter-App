import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../controller/orders_management_controller.dart';

class OrdersHeaderWidget extends StatelessWidget {
  const OrdersHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersManagementController>(
      builder: (controller) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              // Title
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: CustomIconWidget(
                          iconName: 'menu',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Orders Management',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  indicatorColor: AppTheme.primaryLight,
                  indicatorWeight: 3.0,
                  labelColor: AppTheme.primaryLight,
                  unselectedLabelColor: AppTheme.textSecondaryLight,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: controller.tabNames.map((name) {
                    return Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Text(name),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Divider
              Container(
                height: 1,
                color: AppTheme.borderLight,
              ),
            ],
          ),
        );
      },
    );
  }
}
