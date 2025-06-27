import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class ShippingDataTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> shippingEntries;
  final bool isLoading;

  const ShippingDataTableWidget({
    super.key,
    required this.shippingEntries,
    this.isLoading = false,
  });

  @override
  State<ShippingDataTableWidget> createState() =>
      _ShippingDataTableWidgetState();
}

class _ShippingDataTableWidgetState extends State<ShippingDataTableWidget> {
  Set<int> selectedRows = <int>{};
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          Expanded(
            child: _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
            strokeWidth: 3.0,
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading shipping data...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping Data',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${widget.shippingEntries.length} entries',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (selectedRows.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                '${selectedRows.length} selected',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Scrollbar(
      controller: _horizontalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100.w,
          ),
          child: DataTable(
            showCheckboxColumn: true,
            headingRowHeight: 7.h,
            dataRowMinHeight: 6.h,
            dataRowMaxHeight: 8.h,
            horizontalMargin: 4.w,
            columnSpacing: 6.w,
            headingRowColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.surface,
            ),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.08);
              }
              return null;
            }),
            border: TableBorder(
              horizontalInside: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            columns: _buildDataColumns(),
            rows: _buildDataRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label: Expanded(
          child: Text(
            'Courier Name',
            style:
                AppTheme.lightTheme.dataTableTheme.headingTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Status',
            style:
                AppTheme.lightTheme.dataTableTheme.headingTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Operation',
            style:
                AppTheme.lightTheme.dataTableTheme.headingTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }

  List<DataRow> _buildDataRows() {
    return widget.shippingEntries.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> shipping = entry.value;
      final bool isSelected = selectedRows.contains(index);

      return DataRow(
        selected: isSelected,
        onSelectChanged: (bool? selected) {
          setState(() {
            if (selected == true) {
              selectedRows.add(index);
            } else {
              selectedRows.remove(index);
            }
          });
        },
        cells: [
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 35.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shipping["courierName"] as String? ?? "",
                    style: AppTheme.lightTheme.dataTableTheme.dataTextStyle
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (shipping["trackingNumber"] != null)
                    Text(
                      'Track: ${shipping["trackingNumber"]}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 25.w),
              child: _buildStatusChip(shipping["status"] as String? ?? ""),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 30.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: 'visibility',
                    onPressed: () => _handleViewAction(shipping),
                    tooltip: 'View Details',
                  ),
                  SizedBox(width: 2.w),
                  _buildActionButton(
                    icon: 'edit',
                    onPressed: () => _handleEditAction(shipping),
                    tooltip: 'Edit Entry',
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        chipColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
        break;
      case 'in transit':
        chipColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'out for delivery':
        chipColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'processing':
        chipColor =
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      default:
        chipColor =
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 4.w,
        ),
        iconSize: 4.w,
        padding: EdgeInsets.all(1.w),
        constraints: BoxConstraints(
          minWidth: 8.w,
          minHeight: 8.w,
        ),
        tooltip: tooltip,
      ),
    );
  }

  void _handleViewAction(Map<String, dynamic> shipping) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Shipping Details',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Courier:', shipping["courierName"] ?? ""),
            _buildDetailRow('Status:', shipping["status"] ?? ""),
            _buildDetailRow('Tracking:', shipping["trackingNumber"] ?? ""),
            _buildDetailRow('Destination:', shipping["destination"] ?? ""),
            _buildDetailRow('Delivery:', shipping["estimatedDelivery"] ?? ""),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditAction(Map<String, dynamic> shipping) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit shipping entry: ${shipping["courierName"]}',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
