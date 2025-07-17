import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CategoryFilterWidget extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategorySelected;
  final int productCount;

  const CategoryFilterWidget({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategorySelected,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$productCount products',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (selectedCategories.isNotEmpty) ...[
                    SizedBox(width: 2.w),
                    TextButton(
                      onPressed: () => onCategorySelected([]),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Clear All',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          SizedBox(height: 2.w),

          // Category Chips
          SizedBox(
            height: 5.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(category);

                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    final newSelection = List<String>.from(selectedCategories);
                    if (selected) {
                      newSelection.add(category);
                    } else {
                      newSelection.remove(category);
                    }
                    onCategorySelected(newSelection);
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor:
                      AppTheme.lightTheme.colorScheme.primaryContainer,
                  checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                  labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                );
              },
            ),
          ),

          SizedBox(height: 2.w),

          // Divider
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            height: 1,
          ),
        ],
      ),
    );
  }
}
