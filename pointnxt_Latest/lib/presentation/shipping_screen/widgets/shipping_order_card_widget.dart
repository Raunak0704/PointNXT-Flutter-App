import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShippingOrderCardWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final String? selectedCarrier;
  final bool isGeneratingLabel;
  final bool isBulkMode;
  final bool isSelected;
  final VoidCallback onGenerateLabel;
  final VoidCallback onMarkAsShipped;
  final VoidCallback onToggleSelection;

  const ShippingOrderCardWidget({
    super.key,
    required this.order,
    this.selectedCarrier,
    required this.isGeneratingLabel,
    required this.isBulkMode,
    required this.isSelected,
    required this.onGenerateLabel,
    required this.onMarkAsShipped,
    required this.onToggleSelection,
  });

  @override
  State<ShippingOrderCardWidget> createState() =>
      _ShippingOrderCardWidgetState();
}

class _ShippingOrderCardWidgetState extends State<ShippingOrderCardWidget> {
  bool _isExpanded = false;

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildUrgencyIndicator() {
    final urgency = widget.order["urgency"] as String;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getUrgencyColor(urgency).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getUrgencyColor(urgency).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: urgency == 'high'
                ? 'priority_high'
                : urgency == 'medium'
                    ? 'schedule'
                    : 'low_priority',
            color: _getUrgencyColor(urgency),
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            urgency.toUpperCase(),
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: _getUrgencyColor(urgency),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAvatar() {
    final initials = widget.order["customerInitials"] as String;
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    final items = widget.order["items"] as List<dynamic>;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Package Details',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    Text(
                      widget.order["packageWeight"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dimensions',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    Text(
                      widget.order["packageDimensions"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Items (${items.length})',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'circle',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 8,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '${item["name"]} x${item["quantity"]}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
          if (widget.order["specialInstructions"] != null) ...[
            SizedBox(height: 2.h),
            Text(
              'Special Instructions',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                widget.order["specialInstructions"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.order["id"] as String),
      background: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'local_shipping',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Mark Shipped',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'cancel',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Skip',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onMarkAsShipped();
          return false;
        } else {
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Skip Order'),
                  content: Text('Are you sure you want to skip this order?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Skip'),
                    ),
                  ],
                ),
              ) ??
              false;
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.isBulkMode) {
            widget.onToggleSelection();
          } else {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        onLongPress: widget.isBulkMode
            ? null
            : () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          title: Text('Edit Package'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle edit package
                          },
                        ),
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'note',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 24,
                          ),
                          title: Text('Customer Notes'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle customer notes
                          },
                        ),
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'skip_next',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 24,
                          ),
                          title: Text('Skip Order'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle skip order
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.isBulkMode) ...[
                          Checkbox(
                            value: widget.isSelected,
                            onChanged: (_) => widget.onToggleSelection(),
                          ),
                          SizedBox(width: 2.w),
                        ],
                        _buildCustomerAvatar(),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.order["id"] as String,
                                      style: AppTheme.getMonospaceStyle(
                                        isLight: true,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _buildUrgencyIndicator(),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                widget.order["customerName"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      widget.order["destination"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Delivery',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium,
                              ),
                              Text(
                                widget.order["estimatedDelivery"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Value',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium,
                              ),
                              Text(
                                widget.order["orderValue"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!widget.isBulkMode)
                          CustomIconWidget(
                            iconName:
                                _isExpanded ? 'expand_less' : 'expand_more',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                      ],
                    ),
                    if (!widget.isBulkMode) ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.selectedCarrier != null &&
                                      !widget.isGeneratingLabel
                                  ? widget.onGenerateLabel
                                  : null,
                              child: widget.isGeneratingLabel
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme
                                              .lightTheme.colorScheme.primary,
                                        ),
                                      ),
                                    )
                                  : Text('Generate Label'),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onMarkAsShipped,
                              child: Text('Mark Shipped'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (_isExpanded && !widget.isBulkMode) ...[
                Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: _buildExpandedContent(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
