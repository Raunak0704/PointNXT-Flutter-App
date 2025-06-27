import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShippingCostEstimatorWidget extends StatefulWidget {
  final String selectedCarrier;
  final List<Map<String, dynamic>> carriers;

  const ShippingCostEstimatorWidget({
    super.key,
    required this.selectedCarrier,
    required this.carriers,
  });

  @override
  State<ShippingCostEstimatorWidget> createState() =>
      _ShippingCostEstimatorWidgetState();
}

class _ShippingCostEstimatorWidgetState
    extends State<ShippingCostEstimatorWidget> {
  bool _isCalculating = false;
  double? _estimatedCost;
  String _selectedService = 'Standard';

  @override
  void initState() {
    super.initState();
    _calculateShippingCost();
  }

  @override
  void didUpdateWidget(ShippingCostEstimatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCarrier != widget.selectedCarrier) {
      _calculateShippingCost();
    }
  }

  Future<void> _calculateShippingCost() async {
    setState(() {
      _isCalculating = true;
      _estimatedCost = null;
    });

    // Simulate API call for cost calculation
    await Future.delayed(const Duration(seconds: 1));

    final carrier = widget.carriers.firstWhere(
      (c) => c["name"] == widget.selectedCarrier,
    );
    final baseCost = carrier["baseCost"] as double;

    // Add service multiplier
    double serviceMultiplier = 1.0;
    switch (_selectedService) {
      case 'Express':
        serviceMultiplier = 1.5;
        break;
      case 'Overnight':
      case 'Same Day':
        serviceMultiplier = 2.0;
        break;
      case 'Next Day Air':
        serviceMultiplier = 1.8;
        break;
      case '2-Day Air':
        serviceMultiplier = 1.3;
        break;
    }

    setState(() {
      _isCalculating = false;
      _estimatedCost = baseCost * serviceMultiplier;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrier = widget.carriers.firstWhere(
      (c) => c["name"] == widget.selectedCarrier,
    );
    final services = carrier["services"] as List<dynamic>;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Shipping Cost Estimator',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Service Level',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: services.map((service) {
              final serviceName = service as String;
              final isSelected = serviceName == _selectedService;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedService = serviceName;
                  });
                  _calculateShippingCost();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    serviceName,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Cost',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_isCalculating)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      )
                    else if (_estimatedCost != null)
                      Text(
                        '\$${_estimatedCost!.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                if (!_isCalculating && _estimatedCost != null) ...[
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          'Cost may vary based on actual package dimensions and destination',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
