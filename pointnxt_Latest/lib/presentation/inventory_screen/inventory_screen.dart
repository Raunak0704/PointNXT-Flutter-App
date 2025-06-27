import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_product_modal_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/stock_adjustment_modal_widget.dart';

// lib/presentation/inventory_screen/inventory_screen.dart

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final bool _isSearching = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredProducts = [];

  // Mock inventory data
  final List<Map<String, dynamic>> _products = [
    {
      "id": "PRD001",
      "name": "Wireless Bluetooth Headphones",
      "sku": "WBH-001",
      "category": "Electronics",
      "stock": 45,
      "lowStockThreshold": 10,
      "price": "\$89.99",
      "supplier": "TechCorp",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-15",
      "isLowStock": false,
    },
    {
      "id": "PRD002",
      "name": "Organic Cotton T-Shirt",
      "sku": "OCT-002",
      "category": "Clothing",
      "stock": 8,
      "lowStockThreshold": 15,
      "price": "\$24.99",
      "supplier": "EcoFashion",
      "image":
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-14",
      "isLowStock": true,
    },
    {
      "id": "PRD003",
      "name": "Stainless Steel Water Bottle",
      "sku": "SSWB-003",
      "category": "Home & Garden",
      "stock": 32,
      "lowStockThreshold": 20,
      "price": "\$19.99",
      "supplier": "HydroLife",
      "image":
          "https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-13",
      "isLowStock": false,
    },
    {
      "id": "PRD004",
      "name": "Yoga Mat Premium",
      "sku": "YMP-004",
      "category": "Sports",
      "stock": 5,
      "lowStockThreshold": 12,
      "price": "\$39.99",
      "supplier": "FitnessPro",
      "image":
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-12",
      "isLowStock": true,
    },
    {
      "id": "PRD005",
      "name": "LED Desk Lamp",
      "sku": "LDL-005",
      "category": "Electronics",
      "stock": 18,
      "lowStockThreshold": 8,
      "price": "\$34.99",
      "supplier": "LightTech",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-11",
      "isLowStock": false,
    },
    {
      "id": "PRD006",
      "name": "Ceramic Coffee Mug Set",
      "sku": "CCMS-006",
      "category": "Home & Garden",
      "stock": 3,
      "lowStockThreshold": 10,
      "price": "\$29.99",
      "supplier": "KitchenCraft",
      "image":
          "https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=400&h=400&fit=crop",
      "lastUpdated": "2024-01-10",
      "isLowStock": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_products);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text != _searchQuery) {
      setState(() {
        _searchQuery = _searchController.text;
        _filterProducts();
      });
    }
  }

  void _filterProducts() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products.where((product) {
          final name = (product['name'] as String).toLowerCase();
          final sku = (product['sku'] as String).toLowerCase();
          final category = (product['category'] as String).toLowerCase();
          final query = _searchQuery.toLowerCase();

          return name.contains(query) ||
              sku.contains(query) ||
              category.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inventory synced successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        onApplyFilters: (filters) {
          // Apply filters logic here
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStockAdjustmentModal(Map<String, dynamic> product, bool isAdd) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StockAdjustmentModalWidget(
        product: product,
        isAdd: isAdd,
        onAdjustStock: (productId, quantity, isAdd) {
          _adjustStock(productId, quantity, isAdd);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _adjustStock(String productId, int quantity, bool isAdd) {
    setState(() {
      final productIndex = _products.indexWhere((p) => p['id'] == productId);
      if (productIndex != -1) {
        final currentStock = _products[productIndex]['stock'] as int;
        final newStock =
            isAdd ? currentStock + quantity : currentStock - quantity;
        _products[productIndex]['stock'] = newStock.clamp(0, 9999);
        _products[productIndex]['isLowStock'] =
            newStock < (_products[productIndex]['lowStockThreshold'] as int);
        _filterProducts();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isAdd ? 'Stock added successfully' : 'Stock removed successfully'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductModalWidget(
        onAddProduct: (product) {
          setState(() {
            _products.add(product);
            _filterProducts();
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: const NavigationDrawerWidget(
        currentRoute: '/inventory-screen',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with title and filter
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: CustomIconWidget(
                            iconName: 'menu',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Inventory',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterModal,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'filter_list',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products, SKU, category...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _filterProducts();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: _filteredProducts.isEmpty && _searchQuery.isNotEmpty
                  ? _buildEmptySearchState()
                  : _filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            itemCount:
                                _filteredProducts.length + (_isLoading ? 3 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _filteredProducts.length) {
                                return _buildSkeletonCard();
                              }

                              final product = _filteredProducts[index];
                              return Dismissible(
                                key: Key(product['id'] as String),
                                background: _buildSwipeBackground(true),
                                secondaryBackground:
                                    _buildSwipeBackground(false),
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _showStockAdjustmentModal(product, true);
                                  } else {
                                    _showStockAdjustmentModal(product, false);
                                  }
                                },
                                child: ProductCardWidget(
                                  product: product,
                                  onTap: () => _onProductTap(product),
                                  onLongPress: () => _showContextMenu(product),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductModal,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Add Product',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isAdd) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isAdd ? AppTheme.successLight : AppTheme.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isAdd ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isAdd ? 'add' : 'remove',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isAdd ? 'Add Stock' : 'Remove Stock',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 1.5.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'inventory_2',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Products Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Add your first product to start managing your inventory',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _showAddProductModal,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Add First Product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Results Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or filters',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    // Navigate to product detail screen with shared element transition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${product['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem('Edit Product', 'edit', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit functionality coming soon')),
              );
            }),
            _buildContextMenuItem('Duplicate', 'content_copy', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product duplicated')),
              );
            }),
            _buildContextMenuItem('View Sales', 'analytics', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sales analytics coming soon')),
              );
            }),
            _buildContextMenuItem('Archive', 'archive', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product archived')),
              );
            }),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }
}
