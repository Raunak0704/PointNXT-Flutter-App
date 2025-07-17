import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StockAdjustmentModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(int) onStockUpdated;

  const StockAdjustmentModal({
    super.key,
    required this.product,
    required this.onStockUpdated,
  });

  @override
  State<StockAdjustmentModal> createState() => _StockAdjustmentModalState();
}

class _StockAdjustmentModalState extends State<StockAdjustmentModal> {
  late int currentStock;
  late int newStock;
  String selectedReason = 'Manual Adjustment';
  final TextEditingController _notesController = TextEditingController();

  final List<String> adjustmentReasons = [
    'Manual Adjustment',
    'Damaged Items',
    'Lost Items',
    'Found Items',
    'Return to Supplier',
    'Customer Return',
    'Inventory Count',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    currentStock = widget.product["currentStock"] as int;
    newStock = currentStock;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateStock(int change) {
    setState(() {
      newStock = (newStock + change).clamp(0, 9999);
    });
  }

  void _saveAdjustment() {
    if (newStock != currentStock) {
      widget.onStockUpdated(newStock);
      Navigator.pop(context);

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock updated successfully',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.product["name"] as String;
    final sku = widget.product["sku"] as String;
    final imageUrl = widget.product["image"] as String;
    final stockDifference = newStock - currentStock;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 2.w),
                width: 12.w,
                height: 1.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Text(
                      'Adjust Stock',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Info
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl: imageUrl,
                                width: 15.w,
                                height: 15.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: TextStyle(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 1.w),
                                  Text(
                                    'SKU: $sku',
                                    style: TextStyle(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.w),

                      // Current Stock
                      Text(
                        'Current Stock',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$currentStock units',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.w),

                      // Stock Adjustment
                      Text(
                        'New Stock Level',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.w),

                      // Stock Counter
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Decrease buttons
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _updateStock(-10),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme
                                          .errorContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '-10',
                                      style: TextStyle(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onErrorContainer,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                  onTap: () => _updateStock(-1),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme
                                          .errorContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'remove',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onErrorContainer,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Current value
                            Column(
                              children: [
                                Text(
                                  '$newStock',
                                  style: TextStyle(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (stockDifference != 0)
                                  Text(
                                    stockDifference > 0
                                        ? '+$stockDifference'
                                        : '$stockDifference',
                                    style: TextStyle(
                                      color: stockDifference > 0
                                          ? AppTheme.successLight
                                          : AppTheme.errorLight,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),

                            // Increase buttons
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _updateStock(1),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'add',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onPrimaryContainer,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                  onTap: () => _updateStock(10),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+10',
                                      style: TextStyle(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onPrimaryContainer,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.w),

                      // Reason Selection
                      Text(
                        'Adjustment Reason',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedReason,
                            isExpanded: true,
                            items: adjustmentReasons.map((reason) {
                              return DropdownMenuItem<String>(
                                value: reason,
                                child: Text(
                                  reason,
                                  style: TextStyle(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedReason = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 6.w),

                      // Notes
                      Text(
                        'Notes (Optional)',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add any additional notes...',
                          hintStyle: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(4.w),
                        ),
                      ),

                      SizedBox(height: 8.w),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveAdjustment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
