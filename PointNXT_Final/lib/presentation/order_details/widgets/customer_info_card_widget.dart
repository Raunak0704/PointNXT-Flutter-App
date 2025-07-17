import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class CustomerInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerInfoCardWidget({
    super.key,
    required this.customer,
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
              'Customer Information',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.w),
            Row(
              children: [
                // Customer Avatar
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: customer["avatar"] != null
                        ? CustomImageWidget(
                            imageUrl: customer["avatar"] as String,
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.w),
                      _buildContactRow(
                        icon: 'email',
                        text: customer["email"] as String,
                        onTap: () => _launchEmail(customer["email"] as String),
                      ),
                      SizedBox(height: 1.w),
                      _buildContactRow(
                        icon: 'phone',
                        text: customer["phone"] as String,
                        onTap: () => _launchPhone(customer["phone"] as String),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Order Inquiry',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      // Handle error - could show a snackbar or copy to clipboard
      Clipboard.setData(ClipboardData(text: email));
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      // Handle error - could show a snackbar or copy to clipboard
      Clipboard.setData(ClipboardData(text: phone));
    }
  }
}
