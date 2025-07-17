import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/batch_scanning_widget.dart';
import './widgets/camera_viewfinder_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/scan_history_widget.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with TickerProviderStateMixin {
  bool _isFlashlightOn = false;
  bool _isBatchMode = false;
  bool _showManualEntry = false;
  String? _lastScannedCode;
  List<Map<String, dynamic>> _scanHistory = [];
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  // Mock scan history data
  final List<Map<String, dynamic>> _mockScanHistory = [
    {
      "id": 1,
      "barcode": "1234567890123",
      "productName": "Wireless Bluetooth Headphones",
      "timestamp": DateTime.now().subtract(Duration(minutes: 2)),
      "format": "UPC",
      "stock": 45,
      "price": "\$89.99",
    },
    {
      "id": 2,
      "barcode": "9876543210987",
      "productName": "Smartphone Case - Clear",
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "format": "EAN",
      "stock": 23,
      "price": "\$19.99",
    },
    {
      "id": 3,
      "barcode": "5555666677778888",
      "productName": "USB-C Charging Cable",
      "timestamp": DateTime.now().subtract(Duration(minutes: 8)),
      "format": "Code 128",
      "stock": 67,
      "price": "\$12.99",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scanHistory = List.from(_mockScanHistory);
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));
    _scanAnimationController.repeat();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  void _toggleFlashlight() {
    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleBatchMode() {
    setState(() {
      _isBatchMode = !_isBatchMode;
    });
    HapticFeedback.mediumImpact();
  }

  void _showManualEntryDialog() {
    setState(() {
      _showManualEntry = true;
    });
  }

  void _onBarcodeScanned(String barcode) {
    HapticFeedback.heavyImpact();
    setState(() {
      _lastScannedCode = barcode;
      // Add to scan history
      _scanHistory.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch,
        "barcode": barcode,
        "productName": "Scanned Product - $barcode",
        "timestamp": DateTime.now(),
        "format": "UPC",
        "stock": 0,
        "price": "\$0.00",
      });
    });

    // Show scan result dialog
    _showScanResultDialog(barcode);
  }

  void _showScanResultDialog(String barcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Scan Successful',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Barcode: $barcode',
                style: AppTheme.getDataTextStyle(
                  isLight: true,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Product found in inventory',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Continue Scanning'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/inventory-management');
              },
              child: Text('View Product'),
            ),
          ],
        );
      },
    );
  }

  void _clearScanHistory() {
    setState(() {
      _scanHistory.clear();
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Viewfinder
            CameraViewfinderWidget(
              onBarcodeScanned: _onBarcodeScanned,
              isFlashlightOn: _isFlashlightOn,
              scanAnimation: _scanAnimation,
            ),

            // Header Controls
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Title
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Barcode Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Flashlight Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: _toggleFlashlight,
                      icon: CustomIconWidget(
                        iconName: _isFlashlightOn ? 'flash_on' : 'flash_off',
                        color: _isFlashlightOn ? Colors.yellow : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scanning Guide Overlay
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 40,
              right: 40,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Corner indicators
                    ...List.generate(4, (index) {
                      return Positioned(
                        top: index < 2 ? 0 : null,
                        bottom: index >= 2 ? 0 : null,
                        left: index % 2 == 0 ? 0 : null,
                        right: index % 2 == 1 ? 0 : null,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: index == 0
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              topRight: index == 1
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomLeft: index == 2
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomRight: index == 3
                                  ? Radius.circular(10)
                                  : Radius.zero,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Scanning line animation
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanAnimation.value * 180,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppTheme.lightTheme.colorScheme.primary,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Instructions
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Position barcode within the frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hold steady for automatic detection',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Control Buttons
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Manual Entry
                          _buildControlButton(
                            icon: 'keyboard',
                            label: 'Manual Entry',
                            onTap: _showManualEntryDialog,
                          ),

                          // Batch Mode
                          _buildControlButton(
                            icon: _isBatchMode
                                ? 'playlist_add_check'
                                : 'playlist_add',
                            label: _isBatchMode ? 'Batch: ON' : 'Batch Mode',
                            onTap: _toggleBatchMode,
                            isActive: _isBatchMode,
                          ),

                          // History
                          _buildControlButton(
                            icon: 'history',
                            label: 'History (${_scanHistory.length})',
                            onTap: () {
                              _showScanHistoryBottomSheet();
                            },
                          ),
                        ],
                      ),
                    ),

                    // Batch Scanning Widget
                    if (_isBatchMode)
                      BatchScanningWidget(
                        scanHistory: _scanHistory,
                        onClearHistory: _clearScanHistory,
                      ),
                  ],
                ),
              ),
            ),

            // Manual Entry Overlay
            if (_showManualEntry)
              ManualEntryWidget(
                onClose: () {
                  setState(() {
                    _showManualEntry = false;
                  });
                },
                onSubmit: (String barcode) {
                  setState(() {
                    _showManualEntry = false;
                  });
                  _onBarcodeScanned(barcode);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showScanHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanHistoryWidget(
        scanHistory: _scanHistory,
        onClearHistory: _clearScanHistory,
        onItemTap: (item) {
          Navigator.of(context).pop();
          _showScanResultDialog(item['barcode']);
        },
      ),
    );
  }
}
