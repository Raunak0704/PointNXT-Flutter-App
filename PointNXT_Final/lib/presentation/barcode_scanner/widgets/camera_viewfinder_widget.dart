import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CameraViewfinderWidget extends StatefulWidget {
  final Function(String) onBarcodeScanned;
  final bool isFlashlightOn;
  final Animation<double> scanAnimation;

  const CameraViewfinderWidget({
    super.key,
    required this.onBarcodeScanned,
    required this.isFlashlightOn,
    required this.scanAnimation,
  });

  @override
  State<CameraViewfinderWidget> createState() => _CameraViewfinderWidgetState();
}

class _CameraViewfinderWidgetState extends State<CameraViewfinderWidget> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.6),
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Mock camera feed background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                  Colors.black,
                ],
              ),
            ),
          ),

          // Simulated camera noise/grain effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=800&h=600&fit=crop'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.7),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Flashlight effect overlay
          if (widget.isFlashlightOn)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

          // Tap to scan gesture detector
          GestureDetector(
            onTap: _simulateScan,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // Scanning indicator
          if (_isScanning)
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Scanning...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Tap instruction (only when not scanning)
          if (!_isScanning)
            Positioned(
              bottom: 200,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'touch_app',
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tap anywhere to simulate scan',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
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

  void _simulateScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    // Simulate scanning delay
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isScanning = false;
    });

    // Generate a mock barcode
    final mockBarcodes = [
      '1234567890123',
      '9876543210987',
      '5555666677778888',
      '1111222233334444',
      '9999888877776666',
    ];

    final randomBarcode =
        mockBarcodes[DateTime.now().millisecond % mockBarcodes.length];

    widget.onBarcodeScanned(randomBarcode);
  }
}
