import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShippingInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> shipping;

  const ShippingInfoCardWidget({
    super.key,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> address =
        shipping["address"] as Map<String, dynamic>;
    final String? trackingNumber = shipping["trackingNumber"] as String?;
    final String? carrier = shipping["carrier"] as String?;
    final String? estimatedDelivery = shipping["estimatedDelivery"] as String?;

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
              'Shipping Information',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.w),

            // Shipping Address
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Delivery Address',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    _formatAddress(address),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.w),
                  OutlinedButton.icon(
                    onPressed: () => _openMap(context, address),
                    icon: CustomIconWidget(
                      iconName: 'map',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    label: Text('View on Map'),
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    ),
                  ),
                ],
              ),
            ),

            if (trackingNumber != null) ...[
              SizedBox(height: 3.w),

              // Tracking Information
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_shipping',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Tracking Information',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Carrier',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          carrier ?? 'N/A',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tracking Number',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _copyTrackingNumber(context, trackingNumber),
                          child: Row(
                            children: [
                              Text(
                                trackingNumber,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
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
                    if (estimatedDelivery != null) ...[
                      SizedBox(height: 1.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Delivery',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            _formatDate(estimatedDelivery),
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 2.w),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _trackPackage(context, trackingNumber),
                        icon: CustomIconWidget(
                          iconName: 'track_changes',
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text('Track Package'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 3.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatAddress(Map<String, dynamic> address) {
    final List<String> addressParts = [];

    if (address["street"] != null) {
      addressParts.add(address["street"] as String);
    }
    if (address["city"] != null) {
      addressParts.add(address["city"] as String);
    }
    if (address["state"] != null) {
      addressParts.add(address["state"] as String);
    }
    if (address["zipCode"] != null) {
      addressParts.add(address["zipCode"] as String);
    }
    if (address["country"] != null) {
      addressParts.add(address["country"] as String);
    }

    return addressParts.join(', ');
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _copyTrackingNumber(BuildContext context, String trackingNumber) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: trackingNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking number copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openMap(BuildContext context, Map<String, dynamic> address) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
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
                'Delivery Location',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 4.w),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'map',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 48,
                        ),
                        SizedBox(height: 2.w),
                        Text(
                          'Map integration would be displayed here',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.w),
                        Text(
                          _formatAddress(address),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.w),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackPackage(BuildContext context, String trackingNumber) {
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
                'Package Tracking',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 4.w),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'local_shipping',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        'Real-time tracking information would be displayed here',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        'Tracking: $trackingNumber',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
