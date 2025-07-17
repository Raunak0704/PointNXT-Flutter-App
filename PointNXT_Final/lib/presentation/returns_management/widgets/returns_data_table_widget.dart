import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ReturnsDataTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> returns;
  final int sortColumnIndex;
  final bool sortAscending;
  final Set<int> selectedRows;
  final bool isMultiSelectMode;
  final Function(int, bool) onSort;
  final Function(int) onRowTap;
  final Function(int) onRowLongPress;
  final bool isLoading;

  const ReturnsDataTableWidget({
    Key? key,
    required this.returns,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.selectedRows,
    required this.isMultiSelectMode,
    required this.onSort,
    required this.onRowTap,
    required this.onRowLongPress,
    required this.isLoading,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.lightTheme.colorScheme.error;
      case 'accepted':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'awb created':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'ready to ship':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: DataTable(
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              showCheckboxColumn: isMultiSelectMode,
              headingRowHeight: 7.h,
              dataRowMinHeight: 6.h,
              dataRowMaxHeight: 8.h,
              columnSpacing: 4.w,
              horizontalMargin: 4.w,
              headingRowColor: WidgetStateProperty.all(
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Channel',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Order No',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Order Date',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'City',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Customer Name',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Order Value',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Delivery Date',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Channel Status',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: Text(
                    'Operation',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSort: (columnIndex, ascending) =>
                      onSort(columnIndex, ascending),
                ),
              ],
              rows: returns.asMap().entries.map((entry) {
                final index = entry.key;
                final returnData = entry.value;
                final isSelected = selectedRows.contains(index);

                return DataRow(
                  selected: isSelected,
                  onSelectChanged:
                      isMultiSelectMode ? (selected) => onRowTap(index) : null,
                  onLongPress: () => onRowLongPress(index),
                  color: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1);
                    }
                    return index.isEven
                        ? AppTheme.lightTheme.colorScheme.surface
                        : AppTheme.lightTheme.scaffoldBackgroundColor;
                  }),
                  cells: [
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          returnData['channel'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['orderNo'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['orderDate'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['city'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['customerName'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['orderValue'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        returnData['deliveryDate'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      _buildStatusChip(returnData['status'] as String),
                    ),
                    DataCell(
                      Text(
                        returnData['channelStatus'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          // Handle operation action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.secondary,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onSecondary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          minimumSize: Size(0, 4.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          returnData['operation'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
