import '../../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onImportPressed;

  const EmptyStateWidget({
    super.key,
    required this.onImportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(),
            SizedBox(height: 4.h),
            _buildEmptyTitle(),
            SizedBox(height: 2.h),
            _buildEmptyDescription(),
            SizedBox(height: 6.h),
            _buildImportButton(),
            SizedBox(height: 3.h),
            _buildHelpText(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'folder_open',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildEmptyTitle() {
    return Text(
      'No Customer Data',
      style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmptyDescription() {
    return Text(
      'Get started by importing your customer data from a CSV or Excel file.',
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildImportButton() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 80.w),
      child: ElevatedButton.icon(
        onPressed: onImportPressed,
        icon: CustomIconWidget(
          iconName: 'upload_file',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        label: Text(
          'Import Customers',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
          shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info_outline',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supported Formats',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'CSV files (.csv) and Excel files (.xlsx) with columns: Channel, Email, First Name, Last Name, Phone',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
