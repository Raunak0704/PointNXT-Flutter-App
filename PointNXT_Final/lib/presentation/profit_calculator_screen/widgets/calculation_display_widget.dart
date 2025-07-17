import '../../../core/app_export.dart';

/// Widget to display calculated profit metrics
/// Features consistent styling and currency formatting
class CalculationDisplayWidget extends StatelessWidget {
  final String label;
  final double value;
  final String currency;
  final bool isPercentage;
  final Color? backgroundColor;

  const CalculationDisplayWidget({
    super.key,
    required this.label,
    required this.value,
    this.currency = '₹',
    this.isPercentage = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    String formattedValue;
    if (isPercentage) {
      formattedValue = '${value.toStringAsFixed(2)}%';
    } else {
      formattedValue = '$currency ${value.toStringAsFixed(2)}';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppTheme.inputBorder,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: backgroundColor != null
                  ? Colors.white.withAlpha(230)
                  : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedValue,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color:
                  backgroundColor != null ? Colors.white : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
