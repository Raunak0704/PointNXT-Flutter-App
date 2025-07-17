import '../../../core/app_export.dart';

/// Expandable Amazon Fees section widget
/// Shows detailed breakdown of Amazon marketplace fees
class AmazonFeesSectionWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Map<String, double> fees;

  const AmazonFeesSectionWidget({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.fees,
  });

  @override
  Widget build(BuildContext context) {
    final totalFees = fees.values.fold(0.0, (sum, fee) => sum + fee);

    return Column(
      children: [
        // Expandable header
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppTheme.inputBorder,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Amazon Fees',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '₹ ${totalFees.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expandable content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? null : 0,
          child: isExpanded
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppTheme.inputBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Fee breakdown
                      ...fees.entries
                          .map((entry) => _buildFeeRow(entry.key, entry.value)),

                      const Divider(
                        color: AppTheme.inputBorder,
                        thickness: 1,
                      ),

                      // Total row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amazon Fees',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '₹ ${totalFees.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String feeType, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            feeType,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            '₹ ${amount.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
