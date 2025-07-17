import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderStatusTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;
  final String currentStatus;

  const OrderStatusTimelineWidget({
    super.key,
    required this.timeline,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.w),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeline.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> step = entry.value;
                  final bool isCompleted = step["completed"] as bool;
                  final bool isLast = index == timeline.length - 1;

                  return Row(
                    children: [
                      _buildTimelineStep(
                        status: step["status"] as String,
                        isCompleted: isCompleted,
                        timestamp: step["timestamp"] as String?,
                      ),
                      if (!isLast)
                        Container(
                          width: 12.w,
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String status,
    required bool isCompleted,
    String? timestamp,
  }) {
    final Color stepColor = isCompleted
        ? AppTheme.lightTheme.colorScheme.tertiary
        : AppTheme.lightTheme.colorScheme.outline;

    final String statusLabel = _getStatusLabel(status);
    final String iconName = _getStatusIcon(status);

    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isCompleted ? stepColor : Colors.transparent,
            border: Border.all(
              color: stepColor,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: isCompleted ? Colors.white : stepColor,
              size: 20,
            ),
          ),
        ),
        SizedBox(height: 2.w),
        SizedBox(
          width: 20.w,
          child: Text(
            statusLabel,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isCompleted
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (timestamp != null && isCompleted) ...[
          SizedBox(height: 1.w),
          SizedBox(
            width: 20.w,
            child: Text(
              _formatTimestamp(timestamp),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return 'Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      default:
        return status.toUpperCase();
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return 'shopping_cart';
      case 'confirmed':
        return 'check_circle';
      case 'processing':
        return 'settings';
      case 'shipped':
        return 'local_shipping';
      case 'delivered':
        return 'home';
      default:
        return 'circle';
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}\n${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
