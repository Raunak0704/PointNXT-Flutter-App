import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class ManualEntryWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onSubmit;

  const ManualEntryWidget({
    super.key,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidgetState();
}

class _ManualEntryWidgetState extends State<ManualEntryWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  String _selectedFormat = 'UPC';

  final List<String> _barcodeFormats = [
    'UPC',
    'EAN',
    'Code 128',
    'QR Code',
    'Code 39',
    'ITF',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      widget.onSubmit(barcode);
    }
  }

  void _handleClose() async {
    await _animationController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, _slideAnimation.value * MediaQuery.of(context).size.height),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.8),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manual Entry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: _handleClose,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Input Form
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Barcode Manually',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Type or paste the barcode number below',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Barcode Format Selector
                        Text(
                          'Barcode Format',
                          style: AppTheme.lightTheme.textTheme.labelLarge,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedFormat,
                              isExpanded: true,
                              items: _barcodeFormats.map((format) {
                                return DropdownMenuItem<String>(
                                  value: format,
                                  child: Text(format),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedFormat = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Barcode Input Field
                        Text(
                          'Barcode Number',
                          style: AppTheme.lightTheme.textTheme.labelLarge,
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _barcodeController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter barcode number',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: CustomIconWidget(
                                iconName: 'qr_code',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            suffixIcon: _barcodeController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _barcodeController.clear();
                                      setState(() {});
                                    },
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                        SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _handleClose,
                                child: Text('Cancel'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _barcodeController.text.trim().isNotEmpty
                                        ? _handleSubmit
                                        : null,
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Quick Entry Suggestions
                        Text(
                          'Quick Entry',
                          style: AppTheme.lightTheme.textTheme.labelLarge,
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildQuickEntryChip('1234567890123'),
                            _buildQuickEntryChip('9876543210987'),
                            _buildQuickEntryChip('5555666677778888'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickEntryChip(String barcode) {
    return GestureDetector(
      onTap: () {
        _barcodeController.text = barcode;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          barcode,
          style: AppTheme.getDataTextStyle(
            isLight: true,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
