import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onAdjustStock;
  final VoidCallback onReorder;
  final VoidCallback onViewHistory;
  final VoidCallback onContactSupplier;

  const InventoryProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onAdjustStock,
    required this.onReorder,
    required this.onViewHistory,
    required this.onContactSupplier,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low Stock':
        return AppTheme.warningLight;
      case 'Out of Stock':
        return AppTheme.errorLight;
      case 'Overstocked':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.successLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = product["currentStock"] as int;
    final minStock = product["minStock"] as int;
    final status = product["status"] as String;
    final name = product["name"] as String;
    final sku = product["sku"] as String;
    final price = product["price"] as String;
    final imageUrl = product["image"] as String;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Selection Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 25.w,
                    fit: BoxFit.cover,
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Selection Indicator
                if (isSelectionMode)
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
              ],
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      name,
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.w),

                    // SKU
                    Text(
                      'SKU: $sku',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.w),

                    // Stock Level
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'inventory_2',
                          color: _getStatusColor(status),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '$currentStock',
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' / $minStock min',
                          style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and Quick Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isSelectionMode)
                          GestureDetector(
                            onTap: onAdjustStock,
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
