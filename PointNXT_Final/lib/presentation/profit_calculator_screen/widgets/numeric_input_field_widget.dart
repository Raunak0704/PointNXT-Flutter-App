import '../../../core/app_export.dart';

/// Reusable numeric input field widget for profit calculator form
/// Features proper numeric keyboard, validation, and consistent styling
class NumericInputFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final VoidCallback? onFieldSubmitted;
  final bool isRequired;
  final bool allowDecimals;
  final String? suffix;

  const NumericInputFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    required this.controller,
    this.focusNode,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.isRequired = false,
    this.allowDecimals = true,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.errorRed,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.numberWithOptions(
            decimal: allowDecimals,
            signed: false,
          ),
          inputFormatters: [
            if (allowDecimals)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted:
              onFieldSubmitted != null ? (_) => onFieldSubmitted!() : null,
          decoration: InputDecoration(
            hintText: placeholder ?? label,
            suffixText: suffix,
            suffixStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppTheme.inputBorder,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppTheme.inputBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppTheme.inputFocus,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppTheme.errorRed,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppTheme.errorRed,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
