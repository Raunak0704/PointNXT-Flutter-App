import '../../core/app_export.dart';
import 'package:get/get.dart';
import 'package:pointnxt/presentation/profit_calculator_screen/widgets/amazon_fees_section_widget.dart';
import 'package:pointnxt/presentation/profit_calculator_screen/widgets/calculation_display_widget.dart';
import 'package:pointnxt/presentation/profit_calculator_screen/widgets/dropdown_field_widget.dart';
import 'package:pointnxt/presentation/profit_calculator_screen/widgets/numeric_input_field_widget.dart';

/// Profit Calculator Screen - Comprehensive e-commerce profitability analysis
/// Features mobile-optimized form interface with real-time calculations using GetX
class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  State<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends State<ProfitCalculatorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfitCalculatorController>(
      builder: (controller) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppTheme.surfaceWhite,
          drawer:
              NavigationDrawerWidget(currentRoute: '/profit-calculator-screen'),

          // ✅ App bar with hamburger menu
          appBar: AppBar(
            backgroundColor: AppTheme.surfaceWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 24,
                color: AppTheme.textPrimary,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              tooltip: 'Open menu',
            ),
            title: Text(
              'Profit Calculator',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const CustomIconWidget(
                  iconName: 'refresh',
                  size: 24,
                  color: AppTheme.textSecondary,
                ),
                onPressed: controller.resetForm,
                tooltip: 'Reset form',
              ),
            ],
          ),

          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormHeader(),
                    const SizedBox(height: 24),
                    _buildSelectionSection(controller),
                    const SizedBox(height: 20),
                    _buildCostInputsSection(controller),
                    const SizedBox(height: 20),
                    _buildSalesProjectionSection(controller),
                    const SizedBox(height: 20),
                    _buildTargetProfitSection(controller),
                    const SizedBox(height: 20),
                    Obx(() => AmazonFeesSectionWidget(
                          isExpanded: controller.isAmazonFeesExpanded,
                          onToggle: controller.toggleAmazonFeesExpansion,
                          fees: controller.amazonFees,
                        )),
                    const SizedBox(height: 24),
                    _buildCalculationResults(controller),
                    const SizedBox(height: 24),
                    _buildSubmitButton(controller),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calculate Profitability',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your product details to calculate profit margins and ROI',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/no-image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection(ProfitCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Channel & Product Selection',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownFieldWidget(
              label: 'Channel',
              hint: 'Please select channel',
              value: controller.selectedChannel,
              options: controller.channelOptions,
              onChanged: controller.onChannelChanged,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a channel'
                  : null,
            )),
        const SizedBox(height: 16),
        Obx(() => DropdownFieldWidget(
              label: 'Product',
              hint: 'Please Select Product',
              value: controller.selectedProduct,
              options: controller.productOptions,
              onChanged: controller.onProductChanged,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a product category'
                  : null,
            )),
      ],
    );
  }

  Widget _buildCostInputsSection(ProfitCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cost Information',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Landing Price',
          placeholder: 'Landing Price',
          controller: controller.landingPriceController,
          focusNode: controller.landingPriceFocusNode,
          isRequired: true,
          suffix: '₹',
          validator: (value) => controller
              .validateNumericField(value, 'Landing Price', isRequired: true),
          onFieldSubmitted: () => FocusScope.of(context)
              .requestFocus(controller.shippingPriceFocusNode),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Shipping Price',
          placeholder: '0',
          controller: controller.shippingPriceController,
          focusNode: controller.shippingPriceFocusNode,
          suffix: '₹',
          validator: (value) =>
              controller.validateNumericField(value, 'Shipping Price'),
          onFieldSubmitted: () =>
              FocusScope.of(context).requestFocus(controller.gstFocusNode),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'GST %',
          placeholder: 'GST',
          controller: controller.gstController,
          focusNode: controller.gstFocusNode,
          suffix: '%',
          validator: (value) =>
              controller.validatePercentageField(value, 'GST'),
          onFieldSubmitted: () =>
              FocusScope.of(context).requestFocus(controller.miscCostFocusNode),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Miscellaneous Cost',
          placeholder: 'Miscellaneous Cost',
          controller: controller.miscCostController,
          focusNode: controller.miscCostFocusNode,
          suffix: '₹',
          validator: (value) =>
              controller.validateNumericField(value, 'Miscellaneous Cost'),
          onFieldSubmitted: () => FocusScope.of(context)
              .requestFocus(controller.monthlyUnitsFocusNode),
        ),
      ],
    );
  }

  Widget _buildSalesProjectionSection(ProfitCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Projection',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Estimated Monthly Units Sold',
          placeholder: 'eg: 1000',
          controller: controller.monthlyUnitsController,
          focusNode: controller.monthlyUnitsFocusNode,
          allowDecimals: false,
          validator: (value) =>
              controller.validateNumericField(value, 'Monthly Units'),
          onFieldSubmitted: () => FocusScope.of(context)
              .requestFocus(controller.unitsReturnedFocusNode),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Estimated Units Returned',
          placeholder: 'eg: 200',
          controller: controller.unitsReturnedController,
          focusNode: controller.unitsReturnedFocusNode,
          allowDecimals: false,
          validator: (value) =>
              controller.validateNumericField(value, 'Units Returned'),
          onFieldSubmitted: () => FocusScope.of(context)
              .requestFocus(controller.faultyReturnsFocusNode),
        ),
        const SizedBox(height: 16),
        NumericInputFieldWidget(
          label: 'Faulty Returns',
          placeholder: 'eg: 200',
          controller: controller.faultyReturnsController,
          focusNode: controller.faultyReturnsFocusNode,
          allowDecimals: false,
          validator: (value) =>
              controller.validateNumericField(value, 'Faulty Returns'),
          onFieldSubmitted: () => FocusScope.of(context)
              .requestFocus(controller.targetProfitMarginFocusNode),
        ),
      ],
    );
  }

  Widget _buildTargetProfitSection(ProfitCalculatorController controller) {
    return NumericInputFieldWidget(
      label: 'Target Profit Margin %',
      placeholder: 'Desired Profit Margin',
      controller: controller.targetProfitMarginController,
      focusNode: controller.targetProfitMarginFocusNode,
      suffix: '%',
      validator: (value) =>
          controller.validatePercentageField(value, 'Target Profit Margin'),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: () => FocusScope.of(context).unfocus(),
    );
  }

  Widget _buildCalculationResults(ProfitCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calculation Results',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            Obx(() => CalculationDisplayWidget(
                  label: 'Total Expenditure',
                  value: controller.totalExpenditure,
                )),
            Obx(() => CalculationDisplayWidget(
                  label: 'Price to be sold at',
                  value: controller.priceToSoldAt,
                  backgroundColor: AppTheme.primaryPurple,
                )),
            Obx(() => CalculationDisplayWidget(
                  label: 'Profit Per Unit',
                  value: controller.profitPerUnit,
                )),
            Obx(() => CalculationDisplayWidget(
                  label: 'Return On Investment',
                  value: controller.returnOnInvestment,
                  isPercentage: true,
                  backgroundColor: Colors.green,
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ProfitCalculatorController controller) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                controller.isLoading ? null : controller.handleFormSubmission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: AppTheme.primaryPurple.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: controller.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'OK',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ));
  }
}
