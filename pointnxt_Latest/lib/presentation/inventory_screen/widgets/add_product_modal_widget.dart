import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddProductModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProduct;

  const AddProductModalWidget({
    super.key,
    required this.onAddProduct,
  });

  @override
  State<AddProductModalWidget> createState() => _AddProductModalWidgetState();
}

class _AddProductModalWidgetState extends State<AddProductModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _thresholdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSupplier;
  String _selectedImageUrl = '';

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Beauty',
    'Food & Beverages',
    'Toys',
  ];

  final List<String> _suppliers = [
    'TechCorp',
    'EcoFashion',
    'HydroLife',
    'FitnessPro',
    'LightTech',
    'KitchenCraft',
    'GlobalSupply',
    'QuickShip',
  ];

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop',
    'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=400&fit=crop',
    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=400&fit=crop',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    'https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=400&h=400&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = _sampleImages.first;
    _generateSKU();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _thresholdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateSKU() {
    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    _skuController.text = 'PRD-$timestamp';
  }

  void _scanBarcode() {
    // Simulate barcode scanning
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Barcode scanner would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'add_box',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Product',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Fill in the product details below',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _scanBarcode,
                  icon: CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text(
                    'Scan',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image selection
                    _buildImageSelection(),

                    SizedBox(height: 3.h),

                    // Product name
                    _buildTextField(
                      'Product Name',
                      _nameController,
                      'Enter product name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product name is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // SKU and Category row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'SKU',
                            _skuController,
                            'Product SKU',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'SKU is required';
                              }
                              return null;
                            },
                            suffixIcon: GestureDetector(
                              onTap: _generateSKU,
                              child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: 'refresh',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _buildDropdown(
                            'Category',
                            _categories,
                            _selectedCategory,
                            (value) =>
                                setState(() => _selectedCategory = value),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Price and Stock row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Price (\$)',
                            _priceController,
                            '0.00',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Price is required';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price <= 0) {
                                return 'Enter valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _buildTextField(
                            'Initial Stock',
                            _stockController,
                            '0',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Stock is required';
                              }
                              final stock = int.tryParse(value);
                              if (stock == null || stock < 0) {
                                return 'Enter valid stock';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Low stock threshold and supplier
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Low Stock Alert',
                            _thresholdController,
                            '10',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Threshold required';
                              }
                              final threshold = int.tryParse(value);
                              if (threshold == null || threshold < 0) {
                                return 'Enter valid threshold';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _buildDropdown(
                            'Supplier',
                            _suppliers,
                            _selectedSupplier,
                            (value) =>
                                setState(() => _selectedSupplier = value),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Description
                    _buildTextField(
                      'Description (Optional)',
                      _descriptionController,
                      'Enter product description...',
                      maxLines: 3,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    child: const Text('Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _sampleImages.length,
            itemBuilder: (context, index) {
              final imageUrl = _sampleImages[index];
              final isSelected = imageUrl == _selectedImageUrl;

              return GestureDetector(
                onTap: () => setState(() => _selectedImageUrl = imageUrl),
                child: Container(
                  width: 25.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CustomImageWidget(
                          imageUrl: imageUrl,
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.cover,
                        ),
                        if (isSelected)
                          Positioned(
                            top: 1.w,
                            right: 1.w,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                'Select $label',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              isExpanded: true,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newProduct = {
        "id": "PRD${DateTime.now().millisecondsSinceEpoch}",
        "name": _nameController.text.trim(),
        "sku": _skuController.text.trim(),
        "category": _selectedCategory!,
        "stock": int.parse(_stockController.text),
        "lowStockThreshold": int.parse(_thresholdController.text),
        "price": "\$${double.parse(_priceController.text).toStringAsFixed(2)}",
        "supplier": _selectedSupplier ?? "Unknown",
        "image": _selectedImageUrl,
        "lastUpdated": DateTime.now().toString().substring(0, 10),
        "isLowStock": int.parse(_stockController.text) <
            int.parse(_thresholdController.text),
        "description": _descriptionController.text.trim(),
      };

      widget.onAddProduct(newProduct);
    }
  }
}
