import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../controller/returns_management_controller.dart';

class ReturnsActionButtonsWidget extends StatelessWidget {
  const ReturnsActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnsManagementController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  'Export',
                  Icons.file_download_outlined,
                  AppTheme.primaryLight,
                  Colors.white,
                  controller.exportReturns,
                ),
                SizedBox(width: 2.w),
                _buildActionButton(
                  'Mark Picked Up',
                  Icons.local_shipping_outlined,
                  AppTheme.secondaryLight,
                  Colors.white,
                  controller.markPickedUp,
                ),
                SizedBox(width: 2.w),
                _buildActionButton(
                  'Track',
                  Icons.track_changes_outlined,
                  AppTheme.primaryLight,
                  Colors.white,
                  controller.trackReturns,
                ),
                SizedBox(width: 2.w),
                Obx(() => _buildActionButton(
                      'Refresh',
                      controller.isRefreshing.value
                          ? Icons.hourglass_empty
                          : Icons.refresh_outlined,
                      AppTheme.textSecondaryLight,
                      Colors.white,
                      controller.refreshReturns,
                      isLoading: controller.isRefreshing.value,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed, {
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Icon(icon, size: 16),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
