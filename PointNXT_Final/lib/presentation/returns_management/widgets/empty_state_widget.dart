import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onClearFilters;

  const EmptyStateWidget({
    Key? key,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'inbox',
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.6),
                size: 20.w,
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No returns found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'We couldn\'t find any returns matching your current filters. Try adjusting your search criteria or clearing filters to see all returns.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Clear filters button
            ElevatedButton.icon(
              onPressed: onClearFilters,
              icon: CustomIconWidget(
                iconName: 'clear_all',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 18,
              ),
              label: Text(
                'Clear Filters',
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
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary action
            TextButton.icon(
              onPressed: () {
                // Handle create new return action
              },
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              label: Text(
                'Create New Return',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
