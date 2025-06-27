import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../controller/orders_management_controller.dart';

class OrdersTableWidget extends StatelessWidget {
  const OrdersTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersManagementController>(builder: (controller) {
      return Obx(() {
        final filteredData = controller.filteredOrders;

        if (controller.isRefreshing.value) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryLight)),
                SizedBox(height: 2.h),
                Text('Refreshing orders...',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppTheme.textSecondaryLight)),
              ]));
        }

        if (filteredData.isEmpty) {
          return _buildEmptyState();
        }

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ]),
            child: SingleChildScrollView(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowHeight: 56,
                        dataRowMinHeight: 60,
                        dataRowMaxHeight: 80,
                        columnSpacing: 4.w,
                        horizontalMargin: 4.w,
                        headingRowColor:
                            WidgetStateProperty.all(AppTheme.secondaryLight),
                        dividerThickness: 1,
                        columns: [
                          DataColumn(
                              label: Text('Channel',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Order No',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Order Date',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('City',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Customer Name',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Order Value',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Delivery Date',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Channel Status',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                          DataColumn(
                              label: Text('Operation',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryLight))),
                        ],
                        rows: filteredData.map((order) {
                          return DataRow(cells: [
                            DataCell(Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: _getChannelColor(order['channel'])
                                        .withAlpha(26),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(order['channel'],
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: _getChannelColor(
                                            order['channel']))))),
                            DataCell(Text(order['orderNo'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryLight))),
                            DataCell(Text(order['orderDate'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppTheme.textPrimaryLight))),
                            DataCell(Text(order['city'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppTheme.textPrimaryLight))),
                            DataCell(Text(order['customerName'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimaryLight))),
                            DataCell(Text(order['orderValue'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.successLight))),
                            DataCell(Text(order['deliveryDate'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppTheme.textPrimaryLight))),
                            DataCell(Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: _getStatusColor(order['statusColor'])
                                        .withAlpha(26),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(order['status'],
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: _getStatusColor(
                                            order['statusColor']))))),
                            DataCell(Text(order['channelStatus'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppTheme.textSecondaryLight))),
                            DataCell(
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: () =>
                                      controller.viewOrderDetails(order),
                                  icon: CustomIconWidget(
                                      iconName: 'visibility',
                                      color: AppTheme.primaryLight,
                                      size: 18),
                                  padding: EdgeInsets.all(1.w),
                                  constraints: BoxConstraints(
                                      minWidth: 8.w, minHeight: 4.h)),
                              PopupMenuButton<String>(
                                  onSelected: (value) => controller
                                      .updateOrderStatus(order, value),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 'Pending',
                                            child: Text('Mark as Pending')),
                                        PopupMenuItem(
                                            value: 'Accepted',
                                            child: Text('Mark as Accepted')),
                                        PopupMenuItem(
                                            value: 'Shipped',
                                            child: Text('Mark as Shipped')),
                                        PopupMenuItem(
                                            value: 'Completed',
                                            child: Text('Mark as Completed')),
                                        PopupMenuItem(
                                            value: 'Cancelled',
                                            child: Text('Mark as Cancelled')),
                                      ],
                                  child: CustomIconWidget(
                                      iconName: 'more_vert',
                                      color: AppTheme.textSecondaryLight,
                                      size: 18)),
                            ])),
                          ]);
                        }).toList()))));
      });
    });
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomImageWidget(imageUrl: '', height: 15.h, width: 15.h),
      SizedBox(height: 2.h),
      Text('No orders found',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight)),
      SizedBox(height: 1.h),
      Text('Try adjusting your search or filter criteria',
          style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondaryLight),
          textAlign: TextAlign.center),
    ]));
  }

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'success':
        return AppTheme.successLight;
      case 'warning':
        return AppTheme.secondaryVariantDark;
      case 'error':
        return AppTheme.errorLight;
      case 'info':
        return AppTheme.primaryLight;
      case 'primary':
        return AppTheme.primaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  Color _getChannelColor(String channel) {
    switch (channel.toLowerCase()) {
      case 'amazon':
        return Color(0xFFFF9500);
      case 'flipkart':
        return Color(0xFF047BD2);
      case 'website':
        return AppTheme.primaryLight;
      case 'shopify':
        return Color(0xFF7AB55C);
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
