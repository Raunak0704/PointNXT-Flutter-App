import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './controller/returns_management_controller.dart';
import './widgets/returns_action_buttons_widget.dart';
import './widgets/returns_header_widget.dart';
import './widgets/returns_search_bar_widget.dart';
import './widgets/returns_table_widget.dart';

class ReturnsManagement extends StatelessWidget {
  const ReturnsManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnsManagementController>(
      init: ReturnsManagementController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          drawer: NavigationDrawerWidget(
            currentRoute: AppRoutes.returnsManagementScreen,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Header with tabs
                ReturnsHeaderWidget(),

                // Main content
                Expanded(
                  child: Obx(() => RefreshIndicator(
                        onRefresh: controller.refreshReturns,
                        child: Column(
                          children: [
                            // Action buttons
                            ReturnsActionButtonsWidget(),

                            SizedBox(height: 2.h),

                            // Search bar
                            ReturnsSearchBarWidget(),

                            SizedBox(height: 2.h),

                            // Returns table
                            Expanded(
                              child: ReturnsTableWidget(),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
