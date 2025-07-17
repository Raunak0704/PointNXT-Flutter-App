import 'package:get/get.dart';
import '../controllers/shipping_calculator_controller.dart';

/// Binding class for Shipping Calculator Screen
/// Handles dependency injection for ShippingCalculatorController
class ShippingCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingCalculatorController>(
      () => ShippingCalculatorController(),
    );
  }
}
