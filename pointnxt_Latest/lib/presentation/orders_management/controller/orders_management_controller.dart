import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OrdersManagementController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  // Observable properties
  final searchQuery = ''.obs;
  final isRefreshing = false.obs;
  final selectedTabIndex = 0.obs;

  // Tab names
  final List<String> tabNames = [
    'Pending',
    'Accepted',
    'AWB Created',
    'Ready to Ship',
    'Shipped',
    'Completed',
    'Cancelled',
    'All'
  ];

  // Mock orders data
  final RxList<Map<String, dynamic>> ordersData = <Map<String, dynamic>>[
    {
      "id": 1,
      "channel": "Amazon",
      "orderNo": "AMZ001234",
      "orderDate": "2024-01-15",
      "city": "New York",
      "customerName": "John Smith",
      "orderValue": "\$129.99",
      "deliveryDate": "2024-01-20",
      "status": "Pending",
      "channelStatus": "Processing",
      "statusColor": "warning"
    },
    {
      "id": 2,
      "channel": "Flipkart",
      "orderNo": "FLP987654",
      "orderDate": "2024-01-14",
      "city": "Mumbai",
      "customerName": "Priya Sharma",
      "orderValue": "\$89.50",
      "deliveryDate": "2024-01-19",
      "status": "Accepted",
      "channelStatus": "Confirmed",
      "statusColor": "success"
    },
    {
      "id": 3,
      "channel": "Website",
      "orderNo": "WEB456789",
      "orderDate": "2024-01-13",
      "city": "Los Angeles",
      "customerName": "Michael Johnson",
      "orderValue": "\$245.75",
      "deliveryDate": "2024-01-18",
      "status": "AWB Created",
      "channelStatus": "Shipped",
      "statusColor": "info"
    },
    {
      "id": 4,
      "channel": "Amazon",
      "orderNo": "AMZ567890",
      "orderDate": "2024-01-12",
      "city": "Chicago",
      "customerName": "Sarah Wilson",
      "orderValue": "\$67.25",
      "deliveryDate": "2024-01-17",
      "status": "Ready to Ship",
      "channelStatus": "Ready",
      "statusColor": "primary"
    },
    {
      "id": 5,
      "channel": "Shopify",
      "orderNo": "SHO123456",
      "orderDate": "2024-01-11",
      "city": "Houston",
      "customerName": "David Brown",
      "orderValue": "\$156.80",
      "deliveryDate": "2024-01-16",
      "status": "Shipped",
      "channelStatus": "In Transit",
      "statusColor": "info"
    },
    {
      "id": 6,
      "channel": "Flipkart",
      "orderNo": "FLP234567",
      "orderDate": "2024-01-10",
      "city": "Delhi",
      "customerName": "Ankita Patel",
      "orderValue": "\$95.40",
      "deliveryDate": "2024-01-15",
      "status": "Completed",
      "channelStatus": "Delivered",
      "statusColor": "success"
    },
    {
      "id": 7,
      "channel": "Amazon",
      "orderNo": "AMZ789012",
      "orderDate": "2024-01-09",
      "city": "Phoenix",
      "customerName": "Robert Davis",
      "orderValue": "\$43.60",
      "deliveryDate": "2024-01-14",
      "status": "Cancelled",
      "channelStatus": "Refunded",
      "statusColor": "error"
    },
    {
      "id": 8,
      "channel": "Website",
      "orderNo": "WEB345678",
      "orderDate": "2024-01-08",
      "city": "Philadelphia",
      "customerName": "Jennifer Garcia",
      "orderValue": "\$198.30",
      "deliveryDate": "2024-01-13",
      "status": "Completed",
      "channelStatus": "Delivered",
      "statusColor": "success"
    }
  ].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabNames.length, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _onTabChanged() {
    selectedTabIndex.value = tabController.index;
  }

  // Filtered data based on search query and selected tab
  List<Map<String, dynamic>> get filteredOrders {
    List<Map<String, dynamic>> filtered = ordersData;

    // Filter by tab selection
    if (selectedTabIndex.value < tabNames.length - 1) {
      // Not "All" tab
      String selectedStatus = tabNames[selectedTabIndex.value];
      filtered =
          filtered.where((order) => order['status'] == selectedStatus).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filtered = filtered.where((order) {
        return (order['orderNo'] as String).toLowerCase().contains(query) ||
            (order['customerName'] as String).toLowerCase().contains(query) ||
            (order['channel'] as String).toLowerCase().contains(query) ||
            (order['city'] as String).toLowerCase().contains(query) ||
            (order['status'] as String).toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  // Search functionality
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Refresh functionality
  Future<void> refreshOrders() async {
    isRefreshing.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real app, fetch fresh data from API
    // For now, just updating the refresh state

    isRefreshing.value = false;
  }

  // Action button handlers
  void exportOrders() {
    Get.snackbar(
      'Export',
      'Orders export functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void acceptOrders() {
    Get.snackbar(
      'Accept',
      'Bulk accept orders functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void printOrders() {
    Get.snackbar(
      'Print',
      'Print orders functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void importOrders() {
    Get.snackbar(
      'Import',
      'Import orders functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void createOrder() {
    Get.snackbar(
      'Create Order',
      'Create new order functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.secondary,
      colorText: Colors.white,
    );
  }

  // Order operations
  void viewOrderDetails(Map<String, dynamic> order) {
    Get.snackbar(
      'Order Details',
      'Order ${order['orderNo']} details will be shown here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateOrderStatus(Map<String, dynamic> order, String newStatus) {
    int index = ordersData.indexWhere((o) => o['id'] == order['id']);
    if (index != -1) {
      ordersData[index]['status'] = newStatus;
      ordersData.refresh();
      Get.snackbar(
        'Status Updated',
        'Order ${order['orderNo']} status updated to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
