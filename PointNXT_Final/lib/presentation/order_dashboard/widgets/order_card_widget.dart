import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onLongPress;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final String status = order['status'] as String;
    final bool isPriority = order['priority'] as bool? ?? false;

    return Dismissible(
      key: Key(order['id'] as String),
      background: _buildSwipeBackground(isLeft: false),
      secondaryBackground: _buildSwipeBackground(isLeft: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onSwipeRight != null) {
          onSwipeRight!();
        } else if (direction == DismissDirection.endToStart &&
            onSwipeLeft != null) {
          onSwipeLeft!();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isPriority
                ? Border.all(
                    color: AppTheme.getStatusColor('warning'),
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order['id'] as String,
                                style: AppTheme.getDataTextStyle(
                                  isLight: true,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isPriority) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'priority_high',
                                  color: AppTheme.getStatusColor('warning'),
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            order['customerName'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor(status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getStatusColor(status),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'shopping_cart',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${order['items']} items',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order['totalAmount'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      order['timestamp'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.getStatusColor('warning').withValues(alpha: 0.1)
            : AppTheme.getStatusColor('success').withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'flag' : 'local_shipping',
                color: isLeft
                    ? AppTheme.getStatusColor('warning')
                    : AppTheme.getStatusColor('success'),
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Priority' : 'Ship',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.getStatusColor('warning')
                      : AppTheme.getStatusColor('success'),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
