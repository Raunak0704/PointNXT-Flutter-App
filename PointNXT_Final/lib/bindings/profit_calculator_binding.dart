import 'package:get/get.dart';
import '../controllers/profit_calculator_controller.dart';

/// Binding class for Profit Calculator Screen
/// Handles dependency injection for the profit calculator feature
class ProfitCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfitCalculatorController>(
      () => ProfitCalculatorController(),
    );
  }
}
