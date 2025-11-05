import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/common/reusable_text_field.dart';

/// Filter controls for Menu Items tab
///
/// This component provides filtering and sorting options for menu items:
/// - Search text field for item names and descriptions
/// - Category dropdown filter
/// - Sort by dropdown (Name, Price, Category, Availability)
/// - Available only checkbox filter
class MenuFilters extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedCategory;
  final String sortBy;
  final bool showAvailableOnly;
  final List<Map<String, dynamic>> categories;
  final Function(String) onCategoryChanged;
  final Function(String) onSortChanged;
  final Function(bool) onAvailabilityChanged;
  final VoidCallback onSearchChanged;

  const MenuFilters({
    super.key,
    required this.searchController,
    required this.selectedCategory,
    required this.sortBy,
    required this.showAvailableOnly,
    required this.categories,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onAvailabilityChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          // Search field - takes more space
          Expanded(
            flex: 2,
            child: ReusableTextField(
              controller: searchController,
              hintText: 'Search menu items...',
              prefixIcon: Icons.search,
              type: TextFieldType.search,
              onChanged: (_) => onSearchChanged(),
            ),
          ),

          SizedBox(width: 16.w),

          // Category filter dropdown
          Expanded(child: _buildCategoryDropdown()),

          SizedBox(width: 16.w),

          // Sort by dropdown
          Expanded(child: _buildSortByDropdown()),

          SizedBox(width: 16.w),

          // Available only checkbox
          _buildAvailabilityFilter(),
        ],
      ),
    );
  }

  /// Builds the category filter dropdown
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      items: ['All Categories', ...categories.map((c) => c['name'] as String)]
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onCategoryChanged(value);
        }
      },
    );
  }

  /// Builds the sort by dropdown
  Widget _buildSortByDropdown() {
    return DropdownButtonFormField<String>(
      value: sortBy,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      items: ['Name', 'Price', 'Category', 'Availability']
          .map(
            (sort) => DropdownMenuItem<String>(value: sort, child: Text(sort)),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onSortChanged(value);
        }
      },
    );
  }

  /// Builds the availability filter checkbox
  Widget _buildAvailabilityFilter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: showAvailableOnly,
          onChanged: (value) => onAvailabilityChanged(value ?? false),
          activeColor: AppColors.adminRole,
        ),
        Text(
          'Available Only',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
