import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/search_bar_widget.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<String> selectedCategories = [];
  String searchQuery = '';
  bool isLoading = false;
  bool isRefreshing = false;
  List<int> selectedProducts = [];
  bool isBulkSelectionMode = false;

  // Mock product data
  final List<Map<String, dynamic>> allProducts = [
    {
      "id": 1,
      "name": "Wireless Bluetooth Headphones",
      "sku": "WBH-001",
      "price": "\$89.99",
      "originalPrice": "\$129.99",
      "stockStatus": "In Stock",
      "stockCount": 45,
      "category": "Electronics",
      "image":
          "https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.5,
      "isOnSale": true,
      "description": "Premium wireless headphones with noise cancellation"
    },
    {
      "id": 2,
      "name": "Organic Cotton T-Shirt",
      "sku": "OCT-002",
      "price": "\$24.99",
      "originalPrice": null,
      "stockStatus": "Low Stock",
      "stockCount": 8,
      "category": "Clothing",
      "image":
          "https://images.pexels.com/photos/1020585/pexels-photo-1020585.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.2,
      "isOnSale": false,
      "description": "Comfortable organic cotton t-shirt in multiple colors"
    },
    {
      "id": 3,
      "name": "Stainless Steel Water Bottle",
      "sku": "SSWB-003",
      "price": "\$19.99",
      "originalPrice": "\$29.99",
      "stockStatus": "In Stock",
      "stockCount": 120,
      "category": "Home & Garden",
      "image":
          "https://images.pexels.com/photos/1000084/pexels-photo-1000084.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.8,
      "isOnSale": true,
      "description":
          "Insulated stainless steel water bottle keeps drinks cold for 24 hours"
    },
    {
      "id": 4,
      "name": "Leather Wallet",
      "sku": "LW-004",
      "price": "\$49.99",
      "originalPrice": null,
      "stockStatus": "Out of Stock",
      "stockCount": 0,
      "category": "Accessories",
      "image":
          "https://images.pexels.com/photos/1152077/pexels-photo-1152077.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.3,
      "isOnSale": false,
      "description": "Genuine leather wallet with RFID protection"
    },
    {
      "id": 5,
      "name": "Smartphone Case",
      "sku": "SC-005",
      "price": "\$14.99",
      "originalPrice": "\$19.99",
      "stockStatus": "In Stock",
      "stockCount": 67,
      "category": "Electronics",
      "image":
          "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.1,
      "isOnSale": true,
      "description": "Protective smartphone case with shock absorption"
    },
    {
      "id": 6,
      "name": "Running Shoes",
      "sku": "RS-006",
      "price": "\$79.99",
      "originalPrice": null,
      "stockStatus": "In Stock",
      "stockCount": 32,
      "category": "Sports",
      "image":
          "https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.6,
      "isOnSale": false,
      "description": "Lightweight running shoes with advanced cushioning"
    },
    {
      "id": 7,
      "name": "Coffee Mug Set",
      "sku": "CMS-007",
      "price": "\$29.99",
      "originalPrice": "\$39.99",
      "stockStatus": "In Stock",
      "stockCount": 25,
      "category": "Home & Garden",
      "image":
          "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.4,
      "isOnSale": true,
      "description": "Set of 4 ceramic coffee mugs with elegant design"
    },
    {
      "id": 8,
      "name": "Desk Lamp",
      "sku": "DL-008",
      "price": "\$34.99",
      "originalPrice": null,
      "stockStatus": "Low Stock",
      "stockCount": 5,
      "category": "Home & Garden",
      "image":
          "https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=500",
      "rating": 4.0,
      "isOnSale": false,
      "description": "Adjustable LED desk lamp with USB charging port"
    }
  ];

  List<String> get categories {
    return allProducts
        .map((product) => product['category'] as String)
        .toSet()
        .toList();
  }

  List<Map<String, dynamic>> get filteredProducts {
    return allProducts.where((product) {
      final matchesSearch = searchQuery.isEmpty ||
          (product['name'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          (product['sku'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          (product['description'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesCategory = selectedCategories.isEmpty ||
          selectedCategories.contains(product['category'] as String);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  void _onCategorySelected(List<String> categories) {
    setState(() {
      selectedCategories = categories;
    });
  }

  void _toggleBulkSelection() {
    setState(() {
      isBulkSelectionMode = !isBulkSelectionMode;
      if (!isBulkSelectionMode) {
        selectedProducts.clear();
      }
    });
  }

  void _toggleProductSelection(int productId) {
    setState(() {
      selectedProducts.contains(productId)
          ? selectedProducts.remove(productId)
          : selectedProducts.add(productId);
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    if (isBulkSelectionMode) {
      _toggleProductSelection(product['id'] as int);
    } else {
      Navigator.pushNamed(context, '/order-details');
    }
  }

  void _onProductLongPress(Map<String, dynamic> product) {
    if (!isBulkSelectionMode) {
      _toggleBulkSelection();
      _toggleProductSelection(product['id'] as int);
    }
  }

  void _addNewProduct() {
    // Navigate to add product screen or show modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Product functionality')),
    );
  }

  void _performBulkAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('$action performed on ${selectedProducts.length} products')),
    );
    _toggleBulkSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Product Catalog',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (isBulkSelectionMode) ...[
            IconButton(
              onPressed: () => _performBulkAction('Price Update'),
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => _performBulkAction('Category Change'),
              icon: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _toggleBulkSelection,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/barcode-scanner'),
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onScanPressed: () =>
                  Navigator.pushNamed(context, '/barcode-scanner'),
            ),

            // Category Filters
            CategoryFilterWidget(
              categories: categories,
              selectedCategories: selectedCategories,
              onCategorySelected: _onCategorySelected,
              productCount: filteredProducts.length,
            ),

            // Bulk Selection Info
            if (isBulkSelectionMode)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${selectedProducts.length} products selected',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Products Grid
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : OrientationBuilder(
                      builder: (context, orientation) {
                        final crossAxisCount =
                            orientation == Orientation.portrait ? 2 : 3;
                        return GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 3.w,
                            mainAxisSpacing: 3.w,
                          ),
                          itemCount:
                              filteredProducts.length + (isLoading ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= filteredProducts.length) {
                              return _buildLoadingCard();
                            }

                            final product = filteredProducts[index];
                            final isSelected =
                                selectedProducts.contains(product['id'] as int);

                            return ProductCardWidget(
                              product: product,
                              isSelected: isSelected,
                              isBulkSelectionMode: isBulkSelectionMode,
                              onTap: () => _onProductTap(product),
                              onLongPress: () => _onProductLongPress(product),
                              onAddToOrder: () => _addToOrder(product),
                              onEditProduct: () => _editProduct(product),
                              onViewAnalytics: () => _viewAnalytics(product),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isBulkSelectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _addNewProduct,
              backgroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
              foregroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Add Product',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inventory_2',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            searchQuery.isNotEmpty || selectedCategories.isNotEmpty
                ? 'No products found'
                : 'No products available',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            searchQuery.isNotEmpty || selectedCategories.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Start by adding your first product',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          if (searchQuery.isEmpty && selectedCategories.isEmpty)
            ElevatedButton.icon(
              onPressed: _addNewProduct,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Add Product'),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              height: 2.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              height: 1.5.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: AppTheme.lightTheme.bottomNavigationBarTheme.type!,
      backgroundColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: 2, // Product Catalog index
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/order-dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/inventory-management');
            break;
          case 2:
            // Current screen
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/barcode-scanner');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'inventory',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'inventory',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'shopping_bag',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'shopping_bag',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'qr_code_scanner',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'qr_code_scanner',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'settings',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  void _addToOrder(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to order')),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${product['name']}')),
    );
  }

  void _viewAnalytics(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Analytics for ${product['name']}')),
    );
  }
}
