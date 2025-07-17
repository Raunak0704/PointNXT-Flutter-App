import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ScanHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scanHistory;
  final VoidCallback onClearHistory;
  final Function(Map<String, dynamic>) onItemTap;

  const ScanHistoryWidget({
    super.key,
    required this.scanHistory,
    required this.onClearHistory,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scan History',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                Row(
                  children: [
                    Text(
                      '${scanHistory.length} items',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 16),
                    if (scanHistory.isNotEmpty)
                      TextButton.icon(
                        onPressed: onClearHistory,
                        icon: CustomIconWidget(
                          iconName: 'clear_all',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 18,
                        ),
                        label: Text(
                          'Clear',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // History List
          Expanded(
            child: scanHistory.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: scanHistory.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final item = scanHistory[index];
                      return _buildHistoryItem(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'qr_code_scanner',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No scans yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start scanning barcodes to see them here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> item) {
    final DateTime timestamp = item['timestamp'] as DateTime;
    final String timeAgo = _getTimeAgo(timestamp);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: _getFormatIcon(item['format'] as String),
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
      ),
      title: Text(
        item['productName'] as String,
        style: AppTheme.lightTheme.textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            item['barcode'] as String,
            style: AppTheme.getDataTextStyle(
              isLight: true,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['format'] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                timeAgo,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item['price'] as String,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Stock: ${item['stock']}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: _getStockColor(item['stock'] as int),
            ),
          ),
        ],
      ),
      onTap: () => onItemTap(item),
    );
  }

  String _getFormatIcon(String format) {
    switch (format.toLowerCase()) {
      case 'upc':
        return 'qr_code';
      case 'ean':
        return 'qr_code_2';
      case 'code 128':
        return 'view_stream';
      case 'qr':
        return 'qr_code_scanner';
      default:
        return 'qr_code';
    }
  }

  Color _getStockColor(int stock) {
    if (stock == 0) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (stock < 10) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
