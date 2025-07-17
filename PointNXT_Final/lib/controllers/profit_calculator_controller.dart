import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Controller for Profit Calculator Screen that manages form state and calculations
/// Uses GetX reactive state management for real-time profit calculations
class ProfitCalculatorController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Observable variables for reactive UI updates
  final _isLoading = false.obs;
  final _isAmazonFeesExpanded = false.obs;

  // Dropdown selections
  final _selectedChannel = ''.obs;
  final _selectedProduct = ''.obs;

  // Form controllers
  final TextEditingController landingPriceController = TextEditingController();
  final TextEditingController shippingPriceController =
      TextEditingController(text: '0');
  final TextEditingController gstController = TextEditingController();
  final TextEditingController miscCostController = TextEditingController();
  final TextEditingController monthlyUnitsController = TextEditingController();
  final TextEditingController unitsReturnedController = TextEditingController();
  final TextEditingController faultyReturnsController = TextEditingController();
  final TextEditingController targetProfitMarginController =
      TextEditingController();

  // Focus nodes for proper keyboard navigation
  final FocusNode landingPriceFocusNode = FocusNode();
  final FocusNode shippingPriceFocusNode = FocusNode();
  final FocusNode gstFocusNode = FocusNode();
  final FocusNode miscCostFocusNode = FocusNode();
  final FocusNode monthlyUnitsFocusNode = FocusNode();
  final FocusNode unitsReturnedFocusNode = FocusNode();
  final FocusNode faultyReturnsFocusNode = FocusNode();
  final FocusNode targetProfitMarginFocusNode = FocusNode();

  // Calculated values
  final _totalExpenditure = 0.0.obs;
  final _priceToSoldAt = 0.0.obs;
  final _profitPerUnit = 0.0.obs;
  final _returnOnInvestment = 0.0.obs;

  // Dropdown options
  final List<String> channelOptions = [
    'Amazon',
    'Flipkart',
    'Meesho',
    'Myntra',
    'Nykaa',
    'Others'
  ];

  final List<String> productOptions = [
    'Electronics',
    'Clothing',
    'Home & Kitchen',
    'Sports & Fitness',
    'Books',
    'Beauty & Personal Care',
    'Others'
  ];

  // Amazon Fees (sample data - should be fetched from API)
  final Map<String, double> amazonFees = {
    'Referral Fee': 0.0,
    'Closing Fee': 0.0,
    'Pick & Pack Fee': 0.0,
    'Weight Handling Fee': 0.0,
    'Storage Fee': 0.0,
    'Fulfillment Fee': 0.0,
  };

  // Getters for accessing observable data
  bool get isLoading => _isLoading.value;
  bool get isAmazonFeesExpanded => _isAmazonFeesExpanded.value;
  String get selectedChannel => _selectedChannel.value;
  String get selectedProduct => _selectedProduct.value;
  double get totalExpenditure => _totalExpenditure.value;
  double get priceToSoldAt => _priceToSoldAt.value;
  double get profitPerUnit => _profitPerUnit.value;
  double get returnOnInvestment => _returnOnInvestment.value;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to controllers for real-time calculations
    _addCalculationListeners();
  }

  /// Adds listeners to text controllers for real-time calculations
  void _addCalculationListeners() {
    landingPriceController.addListener(_calculateProfitMetrics);
    shippingPriceController.addListener(_calculateProfitMetrics);
    gstController.addListener(_calculateProfitMetrics);
    miscCostController.addListener(_calculateProfitMetrics);
    monthlyUnitsController.addListener(_calculateProfitMetrics);
    unitsReturnedController.addListener(_calculateProfitMetrics);
    faultyReturnsController.addListener(_calculateProfitMetrics);
    targetProfitMarginController.addListener(_calculateProfitMetrics);
  }

  /// Handles channel dropdown selection
  void onChannelChanged(String? value) {
    if (value != null) {
      _selectedChannel.value = value;
      _calculateProfitMetrics();
    }
  }

  /// Handles product dropdown selection
  void onProductChanged(String? value) {
    if (value != null) {
      _selectedProduct.value = value;
      _calculateProfitMetrics();
    }
  }

  /// Toggles Amazon Fees expansion
  void toggleAmazonFeesExpansion() {
    _isAmazonFeesExpanded.value = !_isAmazonFeesExpanded.value;
  }

  /// Calculates profit metrics based on current input values
  void _calculateProfitMetrics() {
    try {
      // Parse input values with fallback to 0
      final landingPrice = double.tryParse(landingPriceController.text) ?? 0.0;
      final shippingPrice =
          double.tryParse(shippingPriceController.text) ?? 0.0;
      final gstPercentage = double.tryParse(gstController.text) ?? 0.0;
      final miscCost = double.tryParse(miscCostController.text) ?? 0.0;
      final targetProfitMargin =
          double.tryParse(targetProfitMarginController.text) ?? 0.0;

      // Calculate GST amount
      final gstAmount = (landingPrice * gstPercentage) / 100;

      // Calculate Amazon fees (sample calculation - should be based on actual Amazon fee structure)
      final amazonFeesTotal = _calculateAmazonFees(landingPrice);

      // Calculate total expenditure
      final totalExp =
          landingPrice + shippingPrice + gstAmount + miscCost + amazonFeesTotal;
      _totalExpenditure.value = totalExp;

      // Calculate price to be sold at (including target profit margin)
      final priceToSell = totalExp + (totalExp * targetProfitMargin / 100);
      _priceToSoldAt.value = priceToSell;

      // Calculate profit per unit
      final profit = priceToSell - totalExp;
      _profitPerUnit.value = profit;

      // Calculate return on investment
      final roi = totalExp > 0 ? (profit / totalExp) * 100 : 0.0;
      _returnOnInvestment.value = roi;
    } catch (e) {
      // Handle calculation errors
    }
  }

  /// Calculates Amazon fees based on product price
  /// This is a simplified calculation - actual Amazon fees are more complex
  double _calculateAmazonFees(double productPrice) {
    if (selectedChannel != 'Amazon') return 0.0;

    // Sample Amazon fee calculation (replace with actual fee structure)
    final referralFee =
        productPrice * 0.15; // 15% referral fee (varies by category)
    final closingFee = 25.0; // Fixed closing fee
    final pickPackFee = 15.0; // Pick & pack fee
    final weightHandlingFee = 12.0; // Weight handling fee
    final storageFee = 5.0; // Monthly storage fee
    final fulfillmentFee = 40.0; // Fulfillment fee

    // Update Amazon fees breakdown
    amazonFees['Referral Fee'] = referralFee;
    amazonFees['Closing Fee'] = closingFee;
    amazonFees['Pick & Pack Fee'] = pickPackFee;
    amazonFees['Weight Handling Fee'] = weightHandlingFee;
    amazonFees['Storage Fee'] = storageFee;
    amazonFees['Fulfillment Fee'] = fulfillmentFee;

    return referralFee +
        closingFee +
        pickPackFee +
        weightHandlingFee +
        storageFee +
        fulfillmentFee;
  }

  /// Validates form inputs
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedChannel.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select a channel',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      if (selectedProduct.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select a product category',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      return true;
    }
    return false;
  }

  /// Handles form submission
  void handleFormSubmission() {
    if (validateForm()) {
      _isLoading.value = true;

      // TODO: Save calculation results to backend
      // API call example: POST /api/profit-calculator/save

      Future.delayed(const Duration(seconds: 1), () {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Profit calculation saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  /// Resets form to initial state
  void resetForm() {
    formKey.currentState?.reset();
    _selectedChannel.value = '';
    _selectedProduct.value = '';

    landingPriceController.clear();
    shippingPriceController.text = '0';
    gstController.clear();
    miscCostController.clear();
    monthlyUnitsController.clear();
    unitsReturnedController.clear();
    faultyReturnsController.clear();
    targetProfitMarginController.clear();

    _totalExpenditure.value = 0.0;
    _priceToSoldAt.value = 0.0;
    _profitPerUnit.value = 0.0;
    _returnOnInvestment.value = 0.0;
  }

  /// Validator for numeric fields
  String? validateNumericField(String? value, String fieldName,
      {bool isRequired = false}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName is required';
    }
    if (value != null && value.isNotEmpty) {
      final numValue = double.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue < 0) {
        return '$fieldName cannot be negative';
      }
    }
    return null;
  }

  /// Validator for percentage fields
  String? validatePercentageField(String? value, String fieldName,
      {bool isRequired = false}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName is required';
    }
    if (value != null && value.isNotEmpty) {
      final numValue = double.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid percentage';
      }
      if (numValue < 0 || numValue > 100) {
        return '$fieldName must be between 0 and 100';
      }
    }
    return null;
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    landingPriceController.dispose();
    shippingPriceController.dispose();
    gstController.dispose();
    miscCostController.dispose();
    monthlyUnitsController.dispose();
    unitsReturnedController.dispose();
    faultyReturnsController.dispose();
    targetProfitMarginController.dispose();

    landingPriceFocusNode.dispose();
    shippingPriceFocusNode.dispose();
    gstFocusNode.dispose();
    miscCostFocusNode.dispose();
    monthlyUnitsFocusNode.dispose();
    unitsReturnedFocusNode.dispose();
    faultyReturnsFocusNode.dispose();
    targetProfitMarginFocusNode.dispose();

    super.onClose();
  }
}
