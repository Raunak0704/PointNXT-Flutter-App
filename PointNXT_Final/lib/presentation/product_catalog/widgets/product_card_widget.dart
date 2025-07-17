import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final bool isBulkSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onAddToOrder;
  final VoidCallback onEditProduct;
  final VoidCallback onViewAnalytics;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.isSelected,
    required this.isBulkSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onAddToOrder,
    required this.onEditProduct,
    required this.onViewAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    final stockStatus = product['stockStatus'] as String;
    final stockCount = product['stockCount'] as int;
    final isOnSale = product['isOnSale'] as bool? ?? false;
    final originalPrice = product['originalPrice'] as String?;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primaryContainer
            : AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: AppTheme.lightTheme.colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: product['image'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),

                          // Sale Badge
                          if (isOnSale)
                            Positioned(
                              top: 2.w,
                              left: 2.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'SALE',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Stock Status Badge
                          Positioned(
                            top: 2.w,
                            right: 2.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 1.w,
                              ),
                              decoration: BoxDecoration(
                                color: _getStockStatusColor(stockStatus),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                stockStatus,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Product Details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 1.w),

                        // SKU
                        Text(
                          'SKU: ${product['sku']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const Spacer(),

                        // Price Row
                        Row(
                          children: [
                            Text(
                              product['price'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (originalPrice != null) ...[
                              SizedBox(width: 2.w),
                              Text(
                                originalPrice,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 1.w),

                        // Stock Count and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Stock: $stockCount',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${product['rating']}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Selection Checkbox
            if (isBulkSelectionMode)
              Positioned(
                top: 2.w,
                left: 2.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

            // Quick Actions (Swipe Gestures Alternative)
            if (!isBulkSelectionMode)
              Positioned(
                bottom: 2.w,
                right: 2.w,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'add_to_order':
                        onAddToOrder();
                        break;
                      case 'edit':
                        onEditProduct();
                        break;
                      case 'analytics':
                        onViewAnalytics();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'add_to_order',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'add_shopping_cart',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          const Text('Add to Order'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          const Text('Edit Product'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'analytics',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'analytics',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          const Text('View Analytics'),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_horiz',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStockStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
        return AppTheme.successLight;
      case 'low stock':
        return AppTheme.warningLight;
      case 'out of stock':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
