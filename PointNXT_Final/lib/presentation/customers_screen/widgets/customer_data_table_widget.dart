import '../../../core/app_export.dart';

class CustomerDataTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> customers;
  final bool isLoading;

  const CustomerDataTableWidget({
    super.key,
    required this.customers,
    this.isLoading = false,
  });

  @override
  State<CustomerDataTableWidget> createState() =>
      _CustomerDataTableWidgetState();
}

class _CustomerDataTableWidgetState extends State<CustomerDataTableWidget> {
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
            'Loading customer data...',
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
                'Customer Data',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${widget.customers.length} customers',
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
            'Name',
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
            'Channel',
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
            'Email',
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
            'Phone',
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
    return widget.customers.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> customer = entry.value;
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
              constraints: BoxConstraints(maxWidth: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${customer["firstName"] ?? ""} ${customer["lastName"] ?? ""}',
                    style: AppTheme.lightTheme.dataTableTheme.dataTextStyle
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (customer["firstName"] != null &&
                      customer["lastName"] != null)
                    Text(
                      'ID: ${customer["id"] ?? ""}',
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
              constraints: BoxConstraints(maxWidth: 20.w),
              child: _buildChannelChip(customer["channel"] as String? ?? ""),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 40.w),
              child: Text(
                customer["email"] as String? ?? "",
                style: AppTheme.lightTheme.dataTableTheme.dataTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 30.w),
              child: Text(
                customer["phone"] as String? ?? "",
                style: AppTheme.lightTheme.dataTableTheme.dataTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildChannelChip(String channel) {
    Color chipColor;
    Color textColor;

    switch (channel.toLowerCase()) {
      case 'online':
        chipColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'store':
        chipColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'phone':
        chipColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
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
        channel,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
