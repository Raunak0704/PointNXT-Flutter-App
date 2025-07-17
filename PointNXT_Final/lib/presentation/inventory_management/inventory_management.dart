import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/inventory_filter_chip.dart';
import './widgets/inventory_product_card.dart';
import './widgets/stock_adjustment_modal.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<String> selectedFilters = [];
  List<String> selectedProducts = [];
  bool isSelectionMode = false;
  bool isLoading = false;

  // Mock inventory data
  final List<Map<String, dynamic>> inventoryData = [
    {
      "id": "INV001",
      "name": "Wireless Bluetooth Headphones",
      "sku": "WBH-001",
      "image":
          "https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg",
      "currentStock": 15,
      "minStock": 10,
      "maxStock": 100,
      "price": "\$89.99",
      "category": "Electronics",
      "supplier": "TechSupply Co.",
      "supplierPhone": "+1-555-0123",
      "lastUpdated": "2024-01-15 10:30 AM",
      "status": "In Stock",
      "location": "Warehouse A - Shelf 12"
    },
    {
      "id": "INV002",
      "name": "Organic Cotton T-Shirt",
      "sku": "OCT-002",
      "image":
          "https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg",
      "currentStock": 5,
      "minStock": 20,
      "maxStock": 200,
      "price": "\$24.99",
      "category": "Clothing",
      "supplier": "Fashion Forward Ltd.",
      "supplierPhone": "+1-555-0456",
      "lastUpdated": "2024-01-14 2:15 PM",
      "status": "Low Stock",
      "location": "Warehouse B - Section 3"
    },
    {
      "id": "INV003",
      "name": "Stainless Steel Water Bottle",
      "sku": "SSWB-003",
      "image":
          "https://images.pexels.com/photos/1000084/pexels-photo-1000084.jpeg",
      "currentStock": 0,
      "minStock": 15,
      "maxStock": 150,
      "price": "\$19.99",
      "category": "Home & Garden",
      "supplier": "EcoProducts Inc.",
      "supplierPhone": "+1-555-0789",
      "lastUpdated": "2024-01-13 9:45 AM",
      "status": "Out of Stock",
      "location": "Warehouse A - Shelf 8"
    },
    {
      "id": "INV004",
      "name": "Yoga Mat Premium",
      "sku": "YMP-004",
      "image":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg",
      "currentStock": 85,
      "minStock": 25,
      "maxStock": 50,
      "price": "\$39.99",
      "category": "Sports & Fitness",
      "supplier": "FitLife Supplies",
      "supplierPhone": "+1-555-0321",
      "lastUpdated": "2024-01-15 11:20 AM",
      "status": "Overstocked",
      "location": "Warehouse C - Zone 1"
    },
    {
      "id": "INV005",
      "name": "LED Desk Lamp",
      "sku": "LDL-005",
      "image":
          "https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg",
      "currentStock": 32,
      "minStock": 15,
      "maxStock": 75,
      "price": "\$45.99",
      "category": "Home & Office",
      "supplier": "Bright Solutions",
      "supplierPhone": "+1-555-0654",
      "lastUpdated": "2024-01-15 8:30 AM",
      "status": "In Stock",
      "location": "Warehouse A - Shelf 15"
    },
    {
      "id": "INV006",
      "name": "Ceramic Coffee Mug Set",
      "sku": "CCMS-006",
      "image":
          "https://images.pexels.com/photos/1251175/pexels-photo-1251175.jpeg",
      "currentStock": 8,
      "minStock": 12,
      "maxStock": 100,
      "price": "\$29.99",
      "category": "Kitchen",
      "supplier": "Kitchen Essentials",
      "supplierPhone": "+1-555-0987",
      "lastUpdated": "2024-01-14 4:45 PM",
      "status": "Low Stock",
      "location": "Warehouse B - Section 5"
    }
  ];

  List<Map<String, dynamic>> get filteredInventory {
    List<Map<String, dynamic>> filtered = List.from(inventoryData);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      String searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((item) {
        return (item["name"] as String).toLowerCase().contains(searchTerm) ||
            (item["sku"] as String).toLowerCase().contains(searchTerm) ||
            (item["id"] as String).toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Apply status filters
    if (selectedFilters.isNotEmpty) {
      filtered = filtered.where((item) {
        String status = item["status"] as String;
        return selectedFilters.any((filter) {
          switch (filter) {
            case "Low Stock":
              return status == "Low Stock";
            case "Out of Stock":
              return status == "Out of Stock";
            case "Overstocked":
              return status == "Overstocked";
            default:
              return false;
          }
        });
      }).toList();
    }

    return filtered;
  }

  int get lowStockCount =>
      inventoryData.where((item) => item["status"] == "Low Stock").length;
  int get outOfStockCount =>
      inventoryData.where((item) => item["status"] == "Out of Stock").length;
  int get overstockedCount =>
      inventoryData.where((item) => item["status"] == "Overstocked").length;

  @override
  void initState() {
    super.initState();
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
    setState(() {});
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      selectedFilters.contains(filter)
          ? selectedFilters.remove(filter)
          : selectedFilters.add(filter);
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      selectedProducts.contains(productId)
          ? selectedProducts.remove(productId)
          : selectedProducts.add(productId);

      if (selectedProducts.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void _startSelectionMode(String productId) {
    setState(() {
      isSelectionMode = true;
      selectedProducts.add(productId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedProducts.clear();
    });
  }

  void _showStockAdjustmentModal(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StockAdjustmentModal(
        product: product,
        onStockUpdated: (newStock) {
          setState(() {
            int index =
                inventoryData.indexWhere((item) => item["id"] == product["id"]);
            if (index != -1) {
              inventoryData[index]["currentStock"] = newStock;
              inventoryData[index]["lastUpdated"] =
                  DateTime.now().toString().substring(0, 16);

              // Update status based on new stock
              int currentStock = newStock;
              int minStock = inventoryData[index]["minStock"] as int;
              int maxStock = inventoryData[index]["maxStock"] as int;

              if (currentStock == 0) {
                inventoryData[index]["status"] = "Out of Stock";
              } else if (currentStock < minStock) {
                inventoryData[index]["status"] = "Low Stock";
              } else if (currentStock > maxStock) {
                inventoryData[index]["status"] = "Overstocked";
              } else {
                inventoryData[index]["status"] = "In Stock";
              }
            }
          });
        },
      ),
    );
  }

  void _openBarcodeScanner() {
    Navigator.pushNamed(context, '/barcode-scanner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Inventory Management',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          isSelectionMode
              ? TextButton(
                  onPressed: _exitSelectionMode,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
          SizedBox(width: 4.w),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.appBarTheme.backgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search products, SKU, or barcode...',
                          hintStyle: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                  },
                                  child: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : CustomIconWidget(
                                  iconName: 'mic',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 3.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Show filter options
                      },
                      icon: CustomIconWidget(
                        iconName: 'tune',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            Container(
              height: 12.w,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InventoryFilterChip(
                    label: 'Low Stock',
                    count: lowStockCount,
                    isSelected: selectedFilters.contains('Low Stock'),
                    onTap: () => _toggleFilter('Low Stock'),
                    color: AppTheme.warningLight,
                  ),
                  SizedBox(width: 2.w),
                  InventoryFilterChip(
                    label: 'Out of Stock',
                    count: outOfStockCount,
                    isSelected: selectedFilters.contains('Out of Stock'),
                    onTap: () => _toggleFilter('Out of Stock'),
                    color: AppTheme.errorLight,
                  ),
                  SizedBox(width: 2.w),
                  InventoryFilterChip(
                    label: 'Overstocked',
                    count: overstockedCount,
                    isSelected: selectedFilters.contains('Overstocked'),
                    onTap: () => _toggleFilter('Overstocked'),
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ],
              ),
            ),

            // Selection Mode Header
            isSelectionMode
                ? Container(
                    padding: EdgeInsets.all(4.w),
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    child: Row(
                      children: [
                        Text(
                          '${selectedProducts.length} selected',
                          style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Bulk stock adjustment
                          },
                          child: Text(
                            'Adjust Stock',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            // Product Grid
            Expanded(
              child: filteredInventory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'inventory_2',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 64,
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            'No products found',
                            style: TextStyle(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3.w,
                        mainAxisSpacing: 3.w,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredInventory.length,
                      itemBuilder: (context, index) {
                        final product = filteredInventory[index];
                        final productId = product["id"] as String;
                        final isSelected = selectedProducts.contains(productId);

                        return InventoryProductCard(
                          product: product,
                          isSelected: isSelected,
                          isSelectionMode: isSelectionMode,
                          onTap: () {
                            isSelectionMode
                                ? _toggleProductSelection(productId)
                                : _showStockAdjustmentModal(product);
                          },
                          onLongPress: () {
                            if (!isSelectionMode) {
                              _startSelectionMode(productId);
                            }
                          },
                          onAdjustStock: () =>
                              _showStockAdjustmentModal(product),
                          onReorder: () {
                            // Handle reorder
                          },
                          onViewHistory: () {
                            // Handle view history
                          },
                          onContactSupplier: () {
                            // Handle contact supplier
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openBarcodeScanner,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'qr_code_scanner',
          color: Colors.white,
          size: 24,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Inventory Management tab
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
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
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'inventory',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'inventory',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'category',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'category',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Catalog',
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
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/order-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/order-details');
              break;
            case 2:
              // Already on inventory management
              break;
            case 3:
              Navigator.pushNamed(context, '/product-catalog');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
