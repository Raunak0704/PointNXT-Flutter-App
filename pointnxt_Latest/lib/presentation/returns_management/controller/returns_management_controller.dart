import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReturnsManagementController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  // Observable properties
  final searchQuery = ''.obs;
  final isRefreshing = false.obs;
  final selectedTabIndex = 0.obs;

  // Tab names
  final List<String> tabNames = [
    'Initiated',
    'Picked Up',
    'Received',
    'Accepted',
    'Rejected',
    'All'
  ];

  // Mock returns data
  final RxList<Map<String, dynamic>> returnsData = <Map<String, dynamic>>[
    {
      "id": 1,
      "channel": "Amazon",
      "orderNo": "AMZ001234",
      "orderDate": "2024-01-15",
      "city": "New York",
      "customerName": "John Smith",
      "orderValue": "\$129.99",
      "status": "Initiated",
      "channelStatus": "Return Requested",
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
      "status": "Picked Up",
      "channelStatus": "In Transit",
      "statusColor": "info"
    },
    {
      "id": 3,
      "channel": "Website",
      "orderNo": "WEB456789",
      "orderDate": "2024-01-13",
      "city": "Los Angeles",
      "customerName": "Michael Johnson",
      "orderValue": "\$245.75",
      "status": "Received",
      "channelStatus": "Quality Check",
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
      "status": "Accepted",
      "channelStatus": "Refund Processed",
      "statusColor": "success"
    },
    {
      "id": 5,
      "channel": "Shopify",
      "orderNo": "SHO123456",
      "orderDate": "2024-01-11",
      "city": "Houston",
      "customerName": "David Brown",
      "orderValue": "\$156.80",
      "status": "Rejected",
      "channelStatus": "Return Declined",
      "statusColor": "error"
    },
    {
      "id": 6,
      "channel": "Flipkart",
      "orderNo": "FLP234567",
      "orderDate": "2024-01-10",
      "city": "Delhi",
      "customerName": "Ankita Patel",
      "orderValue": "\$95.40",
      "status": "Accepted",
      "channelStatus": "Refunded",
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
      "status": "Initiated",
      "channelStatus": "Return Requested",
      "statusColor": "warning"
    },
    {
      "id": 8,
      "channel": "Website",
      "orderNo": "WEB345678",
      "orderDate": "2024-01-08",
      "city": "Philadelphia",
      "customerName": "Jennifer Garcia",
      "orderValue": "\$198.30",
      "status": "Picked Up",
      "channelStatus": "In Transit",
      "statusColor": "info"
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
  List<Map<String, dynamic>> get filteredReturns {
    List<Map<String, dynamic>> filtered = returnsData;

    // Filter by tab selection
    if (selectedTabIndex.value < tabNames.length - 1) {
      // Not "All" tab
      String selectedStatus = tabNames[selectedTabIndex.value];
      filtered = filtered
          .where((returnItem) => returnItem['status'] == selectedStatus)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filtered = filtered.where((returnItem) {
        return (returnItem['orderNo'] as String)
                .toLowerCase()
                .contains(query) ||
            (returnItem['customerName'] as String)
                .toLowerCase()
                .contains(query) ||
            (returnItem['channel'] as String).toLowerCase().contains(query) ||
            (returnItem['city'] as String).toLowerCase().contains(query) ||
            (returnItem['status'] as String).toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  // Search functionality
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Refresh functionality
  Future<void> refreshReturns() async {
    isRefreshing.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real app, fetch fresh data from API
    // For now, just updating the refresh state

    isRefreshing.value = false;
  }

  // Action button handlers
  void exportReturns() {
    Get.snackbar(
      'Export',
      'Returns export functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void markPickedUp() {
    Get.snackbar(
      'Mark Picked Up',
      'Mark returns picked up functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void trackReturns() {
    Get.snackbar(
      'Track',
      'Track returns functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  // Return operations
  void viewReturnDetails(Map<String, dynamic> returnItem) {
    Get.snackbar(
      'Return Details',
      'Return ${returnItem['orderNo']} details will be shown here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateReturnStatus(Map<String, dynamic> returnItem, String newStatus) {
    int index = returnsData.indexWhere((r) => r['id'] == returnItem['id']);
    if (index != -1) {
      returnsData[index]['status'] = newStatus;

      // Update status color based on new status
      String statusColor = 'info';
      switch (newStatus) {
        case 'Accepted':
          statusColor = 'success';
          break;
        case 'Rejected':
          statusColor = 'error';
          break;
        case 'Initiated':
          statusColor = 'warning';
          break;
        default:
          statusColor = 'info';
      }
      returnsData[index]['statusColor'] = statusColor;

      returnsData.refresh();
      Get.snackbar(
        'Status Updated',
        'Return ${returnItem['orderNo']} status updated to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
