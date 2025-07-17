import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionToolbarWidget extends StatelessWidget {
  final int selectedCount;
  final Function(String) onActionPressed;

  const ActionToolbarWidget({
    Key? key,
    required this.selectedCount,
    required this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': 'file_download', 'label': 'Export', 'action': 'Export'},
      {'icon': 'check_circle', 'label': 'Accept', 'action': 'Accept'},
      {'icon': 'print', 'label': 'Print', 'action': 'Print'},
      {'icon': 'file_upload', 'label': 'Import', 'action': 'Import'},
      {'icon': 'add', 'label': 'Create', 'action': 'Create'},
      {'icon': 'refresh', 'label': 'Refresh', 'action': 'Refresh'},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedCount > 0)
            Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: actions.map((action) {
              final isAcceptAction = action['action'] == 'Accept';
              final isEnabled = !isAcceptAction || selectedCount > 0;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () => onActionPressed(action['action'] as String)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAcceptAction && selectedCount > 0
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      disabledBackgroundColor: AppTheme
                          .lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                      disabledForegroundColor:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: isEnabled ? 2 : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: action['icon'] as String,
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          action['label'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isEnabled
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
