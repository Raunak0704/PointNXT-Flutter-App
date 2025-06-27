import '../../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChannelsEmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const ChannelsEmptyStateWidget({
    super.key,
    required this.onCreatePressed,
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
            _buildCreateButton(),
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
          iconName: 'integration_instructions',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildEmptyTitle() {
    return Text(
      'No Channels Configured',
      style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmptyDescription() {
    return Text(
      'Connect your e-commerce platforms to start managing channels and synchronizing your inventory and orders.',
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCreateButton() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 80.w),
      child: ElevatedButton.icon(
        onPressed: onCreatePressed,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        label: Text(
          'Create Channel',
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
                  'Supported Platforms',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Connect with Shopify, WooCommerce, Amazon, and other popular e-commerce platforms to centralize your channel management.',
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
