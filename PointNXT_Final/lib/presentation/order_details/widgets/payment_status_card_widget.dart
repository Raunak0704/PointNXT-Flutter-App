import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentStatusCardWidget extends StatelessWidget {
  final Map<String, dynamic> payment;

  const PaymentStatusCardWidget({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final String status = payment["status"] as String;
    final String method = payment["method"] as String;
    final double amount = payment["amount"] as double;
    final String transactionId = payment["transactionId"] as String;
    final String? paidAt = payment["paidAt"] as String?;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Information',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            SizedBox(height: 3.w),

            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.w),

            // Payment Method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getPaymentMethodIcon(method),
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      method,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.w),

            // Transaction ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction ID',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyTransactionId(context, transactionId),
                  child: Row(
                    children: [
                      Text(
                        transactionId,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'content_copy',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (paidAt != null) ...[
              SizedBox(height: 2.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paid At',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatDateTime(paidAt),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],

            SizedBox(height: 3.w),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _viewReceipt(context),
                icon: CustomIconWidget(
                  iconName: 'receipt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                label: Text('View Receipt'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String chipText;

    switch (status.toLowerCase()) {
      case 'paid':
        chipColor = AppTheme.lightTheme.colorScheme.tertiary;
        chipText = 'Paid';
        break;
      case 'pending':
        chipColor = AppTheme.warningLight;
        chipText = 'Pending';
        break;
      case 'failed':
        chipColor = AppTheme.lightTheme.colorScheme.error;
        chipText = 'Failed';
        break;
      default:
        chipColor = AppTheme.lightTheme.colorScheme.secondary;
        chipText = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        chipText,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return 'credit_card';
      case 'debit card':
        return 'credit_card';
      case 'paypal':
        return 'account_balance_wallet';
      case 'bank transfer':
        return 'account_balance';
      case 'cash':
        return 'money';
      default:
        return 'payment';
    }
  }

  void _copyTransactionId(BuildContext context, String transactionId) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: transactionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction ID copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewReceipt(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                'Payment Receipt',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 4.w),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'receipt_long',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        'Receipt details would be displayed here',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Receipt downloaded'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text('Download'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}
