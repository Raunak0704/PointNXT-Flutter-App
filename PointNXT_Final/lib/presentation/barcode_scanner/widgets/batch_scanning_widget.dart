import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BatchScanningWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scanHistory;
  final VoidCallback onClearHistory;

  const BatchScanningWidget({
    super.key,
    required this.scanHistory,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final batchItems = scanHistory.take(5).toList();
    final totalItems = scanHistory.length;
    final totalValue = scanHistory.fold<double>(
      0.0,
      (sum, item) => sum + _parsePrice(item['price'] as String),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Batch Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'playlist_add_check',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Batch Scanning Mode',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalItems items',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (totalItems > 0) ...[
            SizedBox(height: 12),

            // Batch Summary
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Items',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '$totalItems',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Value',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '\$${totalValue.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Recent Batch Items
            Text(
              'Recent Scans',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 8),

            ...batchItems.map((item) => _buildBatchItem(item)),

            if (totalItems > 5) ...[
              SizedBox(height: 8),
              Text(
                '+ ${totalItems - 5} more items',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            SizedBox(height: 12),

            // Batch Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onClearHistory,
                    icon: CustomIconWidget(
                      iconName: 'clear_all',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                    label: Text(
                      'Clear Batch',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle export batch
                      _showExportDialog(context);
                    },
                    icon: CustomIconWidget(
                      iconName: 'file_download',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text('Export'),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Start scanning to add items to your batch',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBatchItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                size: 16,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['barcode'] as String,
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item['price'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _parsePrice(String priceString) {
    // Remove currency symbol and parse
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text('Export Batch'),
            ],
          ),
          content: Text(
            'Export ${scanHistory.length} scanned items to CSV or PDF format?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle CSV export
              },
              child: Text('CSV'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle PDF export
              },
              child: Text('PDF'),
            ),
          ],
        );
      },
    );
  }
}
