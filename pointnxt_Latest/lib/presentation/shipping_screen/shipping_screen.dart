import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/carrier_selection_widget.dart';
import './widgets/shipping_cost_estimator_widget.dart';
import './widgets/shipping_order_card_widget.dart';

// lib/presentation/shipping_screen/shipping_screen.dart

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with TickerProviderStateMixin {
  String? _selectedCarrier;
  bool _isGeneratingLabel = false;
  bool _isBulkMode = false;
  final List<String> _selectedOrders = [];

  // Mock data for pending shipments
  final List<Map<String, dynamic>> _pendingShipments = [
    {
      "id": "ORD-2024-001",
      "customerName": "Sarah Johnson",
      "customerInitials": "SJ",
      "destination": "New York, NY 10001",
      "packageWeight": "2.5 kg",
      "packageDimensions": "30x20x15 cm",
      "estimatedDelivery": "Dec 28, 2024",
      "urgency": "high",
      "specialInstructions": "Handle with care - fragile items",
      "orderValue": "\$125.99",
      "items": [
        {"name": "Ceramic Vase", "quantity": 1},
        {"name": "Glass Ornaments", "quantity": 3}
      ]
    },
    {
      "id": "ORD-2024-002",
      "customerName": "Michael Chen",
      "customerInitials": "MC",
      "destination": "Los Angeles, CA 90210",
      "packageWeight": "1.8 kg",
      "packageDimensions": "25x15x10 cm",
      "estimatedDelivery": "Dec 29, 2024",
      "urgency": "medium",
      "specialInstructions": "Leave at front door if no answer",
      "orderValue": "\$89.50",
      "items": [
        {"name": "Bluetooth Speaker", "quantity": 1},
        {"name": "Phone Case", "quantity": 2}
      ]
    },
    {
      "id": "ORD-2024-003",
      "customerName": "Emma Rodriguez",
      "customerInitials": "ER",
      "destination": "Chicago, IL 60601",
      "packageWeight": "3.2 kg",
      "packageDimensions": "35x25x20 cm",
      "estimatedDelivery": "Dec 30, 2024",
      "urgency": "low",
      "specialInstructions": "Signature required",
      "orderValue": "\$199.99",
      "items": [
        {"name": "Laptop Stand", "quantity": 1},
        {"name": "Wireless Mouse", "quantity": 1},
        {"name": "USB Hub", "quantity": 1}
      ]
    },
    {
      "id": "ORD-2024-004",
      "customerName": "David Wilson",
      "customerInitials": "DW",
      "destination": "Miami, FL 33101",
      "packageWeight": "0.8 kg",
      "packageDimensions": "20x15x5 cm",
      "estimatedDelivery": "Dec 27, 2024",
      "urgency": "high",
      "specialInstructions": "Express delivery requested",
      "orderValue": "\$45.00",
      "items": [
        {"name": "T-Shirt", "quantity": 2},
        {"name": "Stickers Pack", "quantity": 1}
      ]
    }
  ];

  final List<Map<String, dynamic>> _carriers = [
    {
      "name": "FedEx",
      "services": ["Standard", "Express", "Overnight"],
      "baseCost": 12.99
    },
    {
      "name": "India Post",
      "services": ["Regular", "Speed Post", "Express"],
      "baseCost": 8.50
    },
    {
      "name": "UPS",
      "services": ["Ground", "2-Day Air", "Next Day Air"],
      "baseCost": 15.75
    },
    {
      "name": "DHL",
      "services": ["Standard", "Express", "Same Day"],
      "baseCost": 18.25
    }
  ];

  void _onCarrierSelected(String carrier) {
    setState(() {
      _selectedCarrier = carrier;
    });
  }

  Future<void> _generateLabel(String orderId) async {
    setState(() {
      _isGeneratingLabel = true;
    });

    // Simulate label generation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGeneratingLabel = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Shipping label generated for $orderId'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  Future<void> _markAsShipped(String orderId) async {
    // Simulate marking as shipped
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId marked as shipped'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _toggleBulkMode() {
    setState(() {
      _isBulkMode = !_isBulkMode;
      if (!_isBulkMode) {
        _selectedOrders.clear();
      }
    });
  }

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrders.contains(orderId)) {
        _selectedOrders.remove(orderId);
      } else {
        _selectedOrders.add(orderId);
      }
    });
  }

  Future<void> _processBulkShipping() async {
    if (_selectedOrders.isEmpty || _selectedCarrier == null) return;

    setState(() {
      _isGeneratingLabel = true;
    });

    // Simulate bulk processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isGeneratingLabel = false;
      _selectedOrders.clear();
      _isBulkMode = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${_selectedOrders.length} orders processed successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: const NavigationDrawerWidget(
        currentRoute: '/shipping-screen',
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Shipping',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_pendingShipments.length}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _toggleBulkMode,
            icon: CustomIconWidget(
              iconName: _isBulkMode ? 'close' : 'checklist',
              color: _isBulkMode
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Carrier Selection
          CarrierSelectionWidget(
            carriers: _carriers,
            selectedCarrier: _selectedCarrier,
            onCarrierSelected: _onCarrierSelected,
          ),

          // Shipping Cost Estimator
          if (_selectedCarrier != null)
            ShippingCostEstimatorWidget(
              selectedCarrier: _selectedCarrier!,
              carriers: _carriers,
            ),

          // Bulk Actions Bar
          if (_isBulkMode && _selectedOrders.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_selectedOrders.length} orders selected',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectedCarrier != null && !_isGeneratingLabel
                        ? _processBulkShipping
                        : null,
                    child: _isGeneratingLabel
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text('Process All'),
                  ),
                ],
              ),
            ),

          // Orders List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: _pendingShipments.length,
                itemBuilder: (context, index) {
                  final order = _pendingShipments[index];
                  final orderId = order["id"] as String;
                  final isSelected = _selectedOrders.contains(orderId);

                  return ShippingOrderCardWidget(
                    order: order,
                    selectedCarrier: _selectedCarrier,
                    isGeneratingLabel: _isGeneratingLabel,
                    isBulkMode: _isBulkMode,
                    isSelected: isSelected,
                    onGenerateLabel: () => _generateLabel(orderId),
                    onMarkAsShipped: () => _markAsShipped(orderId),
                    onToggleSelection: () => _toggleOrderSelection(orderId),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
