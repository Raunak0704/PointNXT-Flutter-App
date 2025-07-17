import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Model for shipping rate results
class ShippingRate {
  final String name;
  final double freightCost;
  final double codCost;
  final double total;

  ShippingRate({
    required this.name,
    required this.freightCost,
    required this.codCost,
    required this.total,
  });
}

/// Controller for Shipping Calculator Screen that manages form state and shipping calculations
/// Uses GetX reactive state management for real-time shipping rate calculations
class ShippingCalculatorController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Observable variables for reactive UI updates
  final _isLoading = false.obs;
  final _shippingRates = <ShippingRate>[].obs;

  // Dropdown selections
  final _selectedShippingService = ''.obs;
  final _selectedDestinationCountry = 'IN'.obs;
  final _selectedPaymentMode = 'Prepaid'.obs;

  // Form controllers
  final TextEditingController pickupPinCodeController = TextEditingController();
  final TextEditingController deliveryPinCodeController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController shipmentValueController =
      TextEditingController(text: '2000');

  // Focus nodes for proper keyboard navigation
  final FocusNode pickupPinCodeFocusNode = FocusNode();
  final FocusNode deliveryPinCodeFocusNode = FocusNode();
  final FocusNode weightFocusNode = FocusNode();
  final FocusNode lengthFocusNode = FocusNode();
  final FocusNode widthFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode shipmentValueFocusNode = FocusNode();

  // Dropdown options
  final List<String> shippingServiceOptions = [
    'Blue Dart',
    'DTDC',
    'Delhivery',
    'Ecom Express',
    'FedEx',
    'Shiprocket',
    'Xpressbees'
  ];

  final List<String> destinationCountryOptions = [
    'IN - India',
    'US - United States',
    'UK - United Kingdom',
    'CA - Canada',
    'AU - Australia',
    'SG - Singapore'
  ];

  final List<String> paymentModeOptions = [
    'Prepaid',
    'COD (Cash on Delivery)',
    'To Pay'
  ];

  // Getters for accessing observable data
  bool get isLoading => _isLoading.value;
  String get selectedShippingService => _selectedShippingService.value;
  String get selectedDestinationCountry => _selectedDestinationCountry.value;
  String get selectedPaymentMode => _selectedPaymentMode.value;
  List<ShippingRate> get shippingRates => _shippingRates;

  @override
  void onInit() {
    super.onInit();
    // Set default values
    _selectedDestinationCountry.value = 'IN - India';
    _selectedPaymentMode.value = 'Prepaid';
  }

  /// Handles shipping service dropdown selection
  void onShippingServiceChanged(String? value) {
    if (value != null) {
      _selectedShippingService.value = value;
    }
  }

  /// Handles destination country dropdown selection
  void onDestinationCountryChanged(String? value) {
    if (value != null) {
      _selectedDestinationCountry.value = value;
    }
  }

  /// Handles payment mode selection
  void onPaymentModeChanged(String? value) {
    if (value != null) {
      _selectedPaymentMode.value = value;
    }
  }

  /// Validates PIN code input (6 digits)
  String? validatePinCode(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length != 6) {
      return '$fieldName must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return '$fieldName must contain only digits';
    }
    return null;
  }

  /// Validates numeric fields
  String? validateNumericField(String? value, String fieldName,
      {bool isRequired = true}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName is required';
    }
    if (value != null && value.isNotEmpty) {
      final numValue = double.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue <= 0) {
        return '$fieldName must be greater than 0';
      }
    }
    return null;
  }

  /// Validates form inputs
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedShippingService.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select a shipping service',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      return true;
    }
    return false;
  }

  /// Calculates shipping rates based on form inputs
  Future<void> calculateShippingRates() async {
    if (!validateForm()) return;

    _isLoading.value = true;
    _shippingRates.clear();

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock shipping rate calculation
      final weight = double.tryParse(weightController.text) ?? 0;
      final value = double.tryParse(shipmentValueController.text) ?? 0;
      final isCOD = selectedPaymentMode.contains('COD');

      // Generate mock shipping rates for different carriers
      final mockRates = _generateMockShippingRates(weight, value, isCOD);
      _shippingRates.addAll(mockRates);

      Get.snackbar(
        'Success',
        'Shipping rates calculated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to calculate shipping rates: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Generates mock shipping rates for demo purposes
  List<ShippingRate> _generateMockShippingRates(
      double weight, double value, bool isCOD) {
    final baseRates = <String, double>{
      'Blue Dart Express': 85.0,
      'DTDC Express': 75.0,
      'Delhivery Surface': 45.0,
      'Ecom Express': 55.0,
      'FedEx Express': 95.0,
    };

    return baseRates.entries.map((entry) {
      final weightMultiplier = (weight / 500).ceil();
      final freightCost = entry.value * weightMultiplier;
      final codCost = isCOD ? value * 0.02 : 0.0; // 2% COD charges
      final total = freightCost + codCost;

      return ShippingRate(
        name: entry.key,
        freightCost: freightCost,
        codCost: codCost,
        total: total,
      );
    }).toList();
  }

  /// Resets form to initial state
  void resetForm() {
    formKey.currentState?.reset();
    _selectedShippingService.value = '';
    _selectedDestinationCountry.value = 'IN - India';
    _selectedPaymentMode.value = 'Prepaid';

    pickupPinCodeController.clear();
    deliveryPinCodeController.clear();
    weightController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();
    shipmentValueController.text = '2000';

    _shippingRates.clear();
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    pickupPinCodeController.dispose();
    deliveryPinCodeController.dispose();
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    shipmentValueController.dispose();

    pickupPinCodeFocusNode.dispose();
    deliveryPinCodeFocusNode.dispose();
    weightFocusNode.dispose();
    lengthFocusNode.dispose();
    widthFocusNode.dispose();
    heightFocusNode.dispose();
    shipmentValueFocusNode.dispose();

    super.onClose();
  }
}
