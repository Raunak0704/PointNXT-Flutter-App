import '../../../core/app_export.dart';

class ChannelsDataTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> channels;
  final bool isLoading;
  final Function(int channelId, bool value) onToggleStock;
  final Function(int channelId, bool value) onToggleOrderSync;
  final Function(int channelId) onEditChannel;
  final Function(int channelId) onDeleteChannel;
  final Function(int channelId) onSettingsChannel;

  const ChannelsDataTableWidget({
    super.key,
    required this.channels,
    this.isLoading = false,
    required this.onToggleStock,
    required this.onToggleOrderSync,
    required this.onEditChannel,
    required this.onDeleteChannel,
    required this.onSettingsChannel,
  });

  @override
  State<ChannelsDataTableWidget> createState() =>
      _ChannelsDataTableWidgetState();
}

class _ChannelsDataTableWidgetState extends State<ChannelsDataTableWidget> {
  Set<int> selectedRows = <int>{};
  final ScrollController _horizontalScrollController = ScrollController();
  final int _currentPage = 1;

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
          _buildPagination(),
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
            'Loading channels data...',
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
                'Channel Integrations',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${widget.channels.length} channels configured',
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
            showCheckboxColumn: false,
            headingRowHeight: 7.h,
            dataRowMinHeight: 6.h,
            dataRowMaxHeight: 8.h,
            horizontalMargin: 4.w,
            columnSpacing: 4.w,
            headingRowColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.surface,
            ),
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
            'Your Channels',
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
            'Channel Name',
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
            'Manage Stock',
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
            'Order Status Sync',
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
    return widget.channels.asMap().entries.map((entry) {
      final Map<String, dynamic> channel = entry.value;

      return DataRow(
        cells: [
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 25.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChannelIcon(channel["channelIcon"] as String? ?? ""),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      channel["platform"] as String? ?? "",
                      style: AppTheme.lightTheme.dataTableTheme.dataTextStyle
                          ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 25.w),
              child: Text(
                channel["channelName"] as String? ?? "",
                style: AppTheme.lightTheme.dataTableTheme.dataTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 20.w),
              child: _buildStatusBadge(channel["status"] as String? ?? ""),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 20.w),
              child: Switch(
                value: channel["manageStock"] as bool? ?? false,
                onChanged: (value) =>
                    widget.onToggleStock(channel["id"] as int, value),
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 20.w),
              child: Switch(
                value: channel["orderStatusSync"] as bool? ?? false,
                onChanged: (value) =>
                    widget.onToggleOrderSync(channel["id"] as int, value),
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(maxWidth: 25.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => widget.onEditChannel(channel["id"] as int),
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    tooltip: 'Edit',
                    padding: EdgeInsets.all(1.w),
                    constraints: BoxConstraints(minWidth: 6.w, minHeight: 6.w),
                  ),
                  IconButton(
                    onPressed: () =>
                        widget.onDeleteChannel(channel["id"] as int),
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                    tooltip: 'Delete',
                    padding: EdgeInsets.all(1.w),
                    constraints: BoxConstraints(minWidth: 6.w, minHeight: 6.w),
                  ),
                  IconButton(
                    onPressed: () =>
                        widget.onSettingsChannel(channel["id"] as int),
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    tooltip: 'Settings',
                    padding: EdgeInsets.all(1.w),
                    constraints: BoxConstraints(minWidth: 6.w, minHeight: 6.w),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildChannelIcon(String channelIcon) {
    IconData iconData;
    Color iconColor;

    switch (channelIcon.toLowerCase()) {
      case 'shopify':
        iconData = Icons.storefront;
        iconColor = Color(0xFF96BF47);
        break;
      case 'woocommerce':
        iconData = Icons.shopping_cart;
        iconColor = Color(0xFF7F54B3);
        break;
      case 'amazon':
        iconData = Icons.store;
        iconColor = Color(0xFFFF9900);
        break;
      default:
        iconData = Icons.store;
        iconColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 5.w,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
        break;
      case 'inactive':
        badgeColor =
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        break;
      default:
        badgeColor =
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor,
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

  Widget _buildPagination() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              '$_currentPage',
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
}
