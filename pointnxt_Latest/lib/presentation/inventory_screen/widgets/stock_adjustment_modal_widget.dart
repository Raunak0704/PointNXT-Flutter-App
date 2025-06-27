import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StockAdjustmentModalWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isAdd;
  final Function(String, int, bool) onAdjustStock;

  const StockAdjustmentModalWidget({
    super.key,
    required this.product,
    required this.isAdd,
    required this.onAdjustStock,
  });

  @override
  State<StockAdjustmentModalWidget> createState() =>
      _StockAdjustmentModalWidgetState();
}

class _StockAdjustmentModalWidgetState
    extends State<StockAdjustmentModalWidget> {
  final TextEditingController _quantityController =
      TextEditingController(text: '1');
  final TextEditingController _reasonController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = widget.product['stock'] as int? ?? 0;
    final productName = widget.product['name'] as String? ?? 'Unknown Product';

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: widget.isAdd
                            ? AppTheme.successLight.withValues(alpha: 0.1)
                            : AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: widget.isAdd ? 'add' : 'remove',
                        color: widget.isAdd
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isAdd ? 'Add Stock' : 'Remove Stock',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            productName,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Current stock info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'inventory_2',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Current Stock: $currentStock units',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quantity input
                  Text(
                    'Quantity',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Quantity picker
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Decrease button
                        GestureDetector(
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                                _quantityController.text = _quantity.toString();
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: _quantity > 1
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'remove',
                              color: _quantity > 1
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),

                        // Quantity input
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                            ),
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            onChanged: (value) {
                              final newQuantity = int.tryParse(value) ?? 1;
                              setState(() {
                                _quantity = newQuantity.clamp(1, 9999);
                              });
                            },
                          ),
                        ),

                        // Increase button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _quantity++;
                              _quantityController.text = _quantity.toString();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Quick quantity buttons
                  Text(
                    'Quick Select',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Row(
                    children: [5, 10, 25, 50].map((qty) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: qty != 50 ? 2.w : 0),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _quantity = qty;
                                _quantityController.text = qty.toString();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _quantity == qty
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : null,
                              side: BorderSide(
                                color: _quantity == qty
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: _quantity == qty ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              qty.toString(),
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: _quantity == qty
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: _quantity == qty
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Reason input
                  Text(
                    'Reason (Optional)',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: widget.isAdd
                          ? 'e.g., New shipment received, Restocking...'
                          : 'e.g., Damaged items, Customer return...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Preview
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: widget.isAdd
                          ? AppTheme.successLight.withValues(alpha: 0.1)
                          : AppTheme.errorLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.isAdd
                            ? AppTheme.successLight.withValues(alpha: 0.3)
                            : AppTheme.errorLight.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Stock:',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '$currentStock units',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.isAdd ? 'Adding:' : 'Removing:',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.isAdd ? '+' : '-'}$_quantity units',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: widget.isAdd
                                    ? AppTheme.successLight
                                    : AppTheme.errorLight,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Stock:',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.isAdd ? currentStock + _quantity : (currentStock - _quantity).clamp(0, 9999)} units',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: widget.isAdd
                                    ? AppTheme.successLight
                                    : AppTheme.errorLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmAdjustment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAdd
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                    ),
                    child: Text(
                      widget.isAdd ? 'Add Stock' : 'Remove Stock',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAdjustment() {
    if (!widget.isAdd && _quantity > (widget.product['stock'] as int)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot remove more stock than available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onAdjustStock(
      widget.product['id'] as String,
      _quantity,
      widget.isAdd,
    );
  }
}
