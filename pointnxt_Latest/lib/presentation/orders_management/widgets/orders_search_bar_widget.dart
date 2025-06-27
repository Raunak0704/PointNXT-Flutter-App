import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../controller/orders_management_controller.dart';

class OrdersSearchBarWidget extends StatelessWidget {
  const OrdersSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersManagementController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search orders, customers, order numbers...',
              prefixIcon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.updateSearchQuery('');
                        },
                      )
                    : CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.textSecondaryLight,
                        size: 20,
                      ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryLight, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textPrimaryLight,
            ),
          ),
        );
      },
    );
  }
}
