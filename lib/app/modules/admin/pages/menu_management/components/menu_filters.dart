import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: isMobile
          ? _buildMobileLayout(context)
          : isTablet
          ? _buildTabletLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  /// Mobile layout - vertical stacking for better space utilization
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Search field - full width
        ReusableTextField(
          controller: searchController,
          hintText: 'Search menu items...',
          prefixIcon: Icons.search,
          type: TextFieldType.search,
          onChanged: (_) => onSearchChanged(),
        ),
        SizedBox(height: 12.h),

        // Row with category and sort dropdowns
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(context)),
            SizedBox(width: 12.w),
            Expanded(child: _buildSortByDropdown(context)),
          ],
        ),
        SizedBox(height: 12.h),

        // Availability filter - centered
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildAvailabilityFilter(context)],
        ),
      ],
    );
  }

  /// Tablet layout - hybrid approach
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        // Top row - search field takes priority
        Row(
          children: [
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
            Expanded(child: _buildCategoryDropdown(context)),
          ],
        ),
        SizedBox(height: 12.h),

        // Bottom row - sort and availability
        Row(
          children: [
            Expanded(child: _buildSortByDropdown(context)),
            SizedBox(width: 16.w),
            _buildAvailabilityFilter(context),
          ],
        ),
      ],
    );
  }

  /// Desktop layout - original horizontal layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
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
        Expanded(child: _buildCategoryDropdown(context)),
        SizedBox(width: 16.w),

        // Sort by dropdown
        Expanded(child: _buildSortByDropdown(context)),
        SizedBox(width: 16.w),

        // Available only checkbox
        _buildAvailabilityFilter(context),
      ],
    );
  }

  /// Builds the category filter dropdown
  Widget _buildCategoryDropdown([BuildContext? ctx]) {
    final context = ctx ?? Get.context!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12.w : 16.w,
          vertical: isMobile ? 8.h : 12.h,
        ),
        labelStyle: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
      ),
      style: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
      items: ['All Categories', ...categories.map((c) => c['name'] as String)]
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
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
  Widget _buildSortByDropdown([BuildContext? ctx]) {
    final context = ctx ?? Get.context!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return DropdownButtonFormField<String>(
      value: sortBy,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12.w : 16.w,
          vertical: isMobile ? 8.h : 12.h,
        ),
        labelStyle: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
      ),
      style: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
      items: ['Name', 'Price', 'Category', 'Availability']
          .map(
            (sort) => DropdownMenuItem<String>(
              value: sort,
              child: Text(
                sort,
                style: TextStyle(fontSize: isMobile ? 12.sp : 14.sp),
              ),
            ),
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
  Widget _buildAvailabilityFilter([BuildContext? ctx]) {
    final context = ctx ?? Get.context!;
    final isMobile = ResponsiveHelper.isMobile(context);

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
          style: TextStyle(
            fontSize: isMobile ? 12.sp : 14.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
