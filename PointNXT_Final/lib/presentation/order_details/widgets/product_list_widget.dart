import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(String) onProductEdit;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.onProductEdit,
  });

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final Set<String> _expandedProducts = {};

  @override
  Widget build(BuildContext context) {
    final double totalAmount = widget.products.fold(
      0.0,
      (sum, product) =>
          sum + ((product["price"] as double) * (product["quantity"] as int)),
    );

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products (${widget.products.length})',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.products.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.w),
              itemBuilder: (context, index) {
                final product = widget.products[index];
                final productId = product["id"] as String;
                final isExpanded = _expandedProducts.contains(productId);

                return _buildProductCard(product, isExpanded);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isExpanded) {
    final String productId = product["id"] as String;
    final String name = product["name"] as String;
    final String image = product["image"] as String;
    final int quantity = product["quantity"] as int;
    final double price = product["price"] as double;
    final String sku = product["sku"] as String;
    final double totalPrice = price * quantity;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded
              ? _expandedProducts.remove(productId)
              : _expandedProducts.add(productId);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  // Product Image
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CustomImageWidget(
                        imageUrl: image,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          'SKU: $sku',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.w),
                        Row(
                          children: [
                            Text(
                              'Qty: $quantity',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '\$${price.toStringAsFixed(2)} each',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Price and Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      CustomIconWidget(
                        iconName: isExpanded ? 'expand_less' : 'expand_more',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expanded Content
            if (isExpanded) ...[
              Container(
                width: double.infinity,
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _editProduct(productId),
                            icon: CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            label: Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.w),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _removeProduct(productId),
                            icon: CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 16,
                            ),
                            label: Text(
                              'Remove',
                              style: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.w),
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _editProduct(String productId) {
    HapticFeedback.lightImpact();
    widget.onProductEdit(productId);

    // Show edit modal or navigate to edit screen
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                'Edit Product',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 4.w),
              Expanded(
                child: Center(
                  child: Text(
                    'Product editing interface would go here',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeProduct(String productId) {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Product'),
        content: Text(
            'Are you sure you want to remove this product from the order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onProductEdit(productId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product removed from order'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
