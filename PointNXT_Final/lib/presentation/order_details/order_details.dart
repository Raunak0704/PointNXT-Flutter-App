import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/customer_info_card_widget.dart';
import './widgets/notes_section_widget.dart';
import './widgets/order_status_timeline_widget.dart';
import './widgets/payment_status_card_widget.dart';
import './widgets/photo_attachment_widget.dart';
import './widgets/product_list_widget.dart';
import './widgets/shipping_info_card_widget.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock order data
  final Map<String, dynamic> orderData = {
    "orderId": "ORD-2024-001234",
    "orderNumber": "#001234",
    "status": "processing",
    "createdAt": "2024-01-15T10:30:00Z",
    "customer": {
      "name": "Sarah Johnson",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face"
    },
    "products": [
      {
        "id": "1",
        "name": "Wireless Bluetooth Headphones",
        "image":
            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop",
        "quantity": 2,
        "price": 89.99,
        "sku": "WBH-001"
      },
      {
        "id": "2",
        "name": "Smartphone Case - Clear",
        "image":
            "https://images.unsplash.com/photo-1601593346740-925612772716?w=300&h=300&fit=crop",
        "quantity": 1,
        "price": 24.99,
        "sku": "SPC-002"
      }
    ],
    "payment": {
      "status": "paid",
      "method": "Credit Card",
      "amount": 204.97,
      "transactionId": "TXN-789456123",
      "paidAt": "2024-01-15T10:32:00Z"
    },
    "shipping": {
      "address": {
        "street": "123 Main Street",
        "city": "New York",
        "state": "NY",
        "zipCode": "10001",
        "country": "USA"
      },
      "trackingNumber": "1Z999AA1234567890",
      "carrier": "UPS",
      "estimatedDelivery": "2024-01-18"
    },
    "notes":
        "Customer requested expedited shipping. Handle with care - fragile items.",
    "photos": [
      "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=300&fit=crop"
    ],
    "timeline": [
      {
        "status": "placed",
        "timestamp": "2024-01-15T10:30:00Z",
        "completed": true
      },
      {
        "status": "confirmed",
        "timestamp": "2024-01-15T10:35:00Z",
        "completed": true
      },
      {
        "status": "processing",
        "timestamp": "2024-01-15T11:00:00Z",
        "completed": true
      },
      {"status": "shipped", "timestamp": null, "completed": false},
      {"status": "delivered", "timestamp": null, "completed": false}
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showOverflowMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Edit Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _editOrder();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Duplicate Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _duplicateOrder();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Share Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareOrder();
                },
              ),
              const Divider(),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'cancel',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Cancel Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _cancelOrder();
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _editOrder() {
    // Navigate to edit screen or show edit modal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit order functionality'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateOrder() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order duplicated successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareOrder() {
    // Implement native sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing order details...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text(
            'Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  void _onPrimaryAction() {
    final String currentStatus = orderData["status"] as String;
    String actionText = '';

    switch (currentStatus) {
      case 'processing':
        actionText = 'Order shipped successfully';
        break;
      case 'shipped':
        actionText = 'Order marked as delivered';
        break;
      default:
        actionText = 'Order updated successfully';
    }

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(actionText),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getPrimaryActionText() {
    final String currentStatus = orderData["status"] as String;

    switch (currentStatus) {
      case 'processing':
        return 'Ship Order';
      case 'shipped':
        return 'Mark Delivered';
      case 'delivered':
        return 'Complete Order';
      default:
        return 'Update Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderData["orderNumber"] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            Text(
              orderData["orderId"] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showOverflowMenu,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),

                        // Status Timeline
                        OrderStatusTimelineWidget(
                          timeline: (orderData["timeline"] as List)
                              .map((item) => item as Map<String, dynamic>)
                              .toList(),
                          currentStatus: orderData["status"] as String,
                        ),

                        SizedBox(height: 3.h),

                        // Customer Information
                        CustomerInfoCardWidget(
                          customer:
                              orderData["customer"] as Map<String, dynamic>,
                        ),

                        SizedBox(height: 2.h),

                        // Product List
                        ProductListWidget(
                          products: (orderData["products"] as List)
                              .map((item) => item as Map<String, dynamic>)
                              .toList(),
                          onProductEdit: (productId) {
                            setState(() {
                              _hasUnsavedChanges = true;
                            });
                          },
                        ),

                        SizedBox(height: 2.h),

                        // Payment Status
                        PaymentStatusCardWidget(
                          payment: orderData["payment"] as Map<String, dynamic>,
                        ),

                        SizedBox(height: 2.h),

                        // Shipping Information
                        ShippingInfoCardWidget(
                          shipping:
                              orderData["shipping"] as Map<String, dynamic>,
                        ),

                        SizedBox(height: 2.h),

                        // Notes Section
                        NotesSectionWidget(
                          notes: orderData["notes"] as String,
                          onNotesChanged: (newNotes) {
                            setState(() {
                              _hasUnsavedChanges = true;
                            });
                          },
                        ),

                        SizedBox(height: 2.h),

                        // Photo Attachments
                        PhotoAttachmentWidget(
                          photos: (orderData["photos"] as List)
                              .map((item) => item as String)
                              .toList(),
                          onPhotosChanged: () {
                            setState(() {
                              _hasUnsavedChanges = true;
                            });
                          },
                        ),

                        SizedBox(height: 10.h), // Space for bottom action
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Action
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onPrimaryAction,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _getPrimaryActionText(),
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        OutlinedButton(
                          onPressed: () {
                            // Show secondary actions
                            _showSecondaryActions();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(3.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'more_horiz',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showSecondaryActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'print',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Print Order'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Printing order...')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Email Customer'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening email...')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('View History'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Loading order history...')),
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
