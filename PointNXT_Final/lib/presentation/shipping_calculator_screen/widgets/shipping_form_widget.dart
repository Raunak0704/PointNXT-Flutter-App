import '../../../core/app_export.dart';
import 'package:get/get.dart';

/// Widget for shipping form with two-column layout
class ShippingFormWidget extends StatelessWidget {
  const ShippingFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShippingCalculatorController>();

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Two-column layout for form fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShippingServiceDropdown(controller),
                    const SizedBox(height: 16),
                    _buildPickupPinCodeField(controller),
                    const SizedBox(height: 16),
                    _buildDeliveryPinCodeField(controller),
                    const SizedBox(height: 16),
                    _buildWeightField(controller),
                    const SizedBox(height: 16),
                    _buildDimensionsFields(controller),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentModeSection(controller),
                    const SizedBox(height: 16),
                    _buildDestinationCountryDropdown(controller),
                    const SizedBox(height: 16),
                    _buildShipmentValueField(controller),
                    const SizedBox(height: 32),
                    _buildCalculateButton(controller),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingServiceDropdown(
      ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Service',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedShippingService.isEmpty
                  ? null
                  : controller.selectedShippingService,
              decoration: const InputDecoration(
                hintText: 'Select shipping service',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: controller.shippingServiceOptions
                  .map((service) => DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      ))
                  .toList(),
              onChanged: controller.onShippingServiceChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a shipping service';
                }
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildPickupPinCodeField(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Pin Code',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.pickupPinCodeController,
          focusNode: controller.pickupPinCodeFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter 6 digit Pickup Pincode',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (value) =>
              controller.validatePinCode(value, 'Pickup Pin Code'),
        ),
      ],
    );
  }

  Widget _buildDeliveryPinCodeField(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Area Pincode',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.deliveryPinCodeController,
          focusNode: controller.deliveryPinCodeFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter 6 digit Delivery Area Pincode',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (value) =>
              controller.validatePinCode(value, 'Delivery Pin Code'),
        ),
      ],
    );
  }

  Widget _buildWeightField(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (gms)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.weightController,
          focusNode: controller.weightFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter weight in grams',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) =>
              controller.validateNumericField(value, 'Weight'),
        ),
      ],
    );
  }

  Widget _buildDimensionsFields(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dimensions (Length/Width/Height in mm)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.lengthController,
                focusNode: controller.lengthFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Length',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    controller.validateNumericField(value, 'Length'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.widthController,
                focusNode: controller.widthFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Width',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    controller.validateNumericField(value, 'Width'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.heightController,
                focusNode: controller.heightFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Height',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    controller.validateNumericField(value, 'Height'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentModeSection(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Mode',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Column(
              children: controller.paymentModeOptions
                  .map((mode) => RadioListTile<String>(
                        title: Text(
                          mode,
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        value: mode,
                        groupValue: controller.selectedPaymentMode,
                        onChanged: controller.onPaymentModeChanged,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ))
                  .toList(),
            )),
      ],
    );
  }

  Widget _buildDestinationCountryDropdown(
      ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destination Country',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedDestinationCountry,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: controller.destinationCountryOptions
                  .map((country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ))
                  .toList(),
              onChanged: controller.onDestinationCountryChanged,
            )),
      ],
    );
  }

  Widget _buildShipmentValueField(ShippingCalculatorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipment Value',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.shipmentValueController,
          focusNode: controller.shipmentValueFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter shipment value',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) =>
              controller.validateNumericField(value, 'Shipment Value'),
        ),
      ],
    );
  }

  Widget _buildCalculateButton(ShippingCalculatorController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
            onPressed:
                controller.isLoading ? null : controller.calculateShippingRates,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
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
          )),
    );
  }
}
