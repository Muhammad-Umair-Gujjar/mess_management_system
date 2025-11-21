import 'package:flutter/material.dart';
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
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'large'),
        vertical: ResponsiveHelper.getSpacing(context, 'small'),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
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
          type: TextFieldType.search,
          onChanged: (_) => onSearchChanged(),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        // Row with category and sort dropdowns
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            Expanded(child: _buildSortByDropdown(context)),
             SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            Expanded(child: _buildAvailabilityFilter(context)),
            
          ],
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
  
                type: TextFieldType.search,
                onChanged: (_) => onSearchChanged(),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
            Expanded(child: _buildCategoryDropdown(context)),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        // Bottom row - sort and availability
        Row(
          children: [
            Expanded(child: _buildSortByDropdown(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
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
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),

        // Category filter dropdown
        Expanded(child: _buildCategoryDropdown(context)),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),

        // Sort by dropdown
        Expanded(child: _buildSortByDropdown(context)),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),

        // Available only checkbox
        _buildAvailabilityFilter(context),
      ],
    );
  }

  /// Builds the category filter dropdown
  Widget _buildCategoryDropdown([BuildContext? ctx]) {
    final context = ctx ?? Get.context!;

    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 12.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 12.0,
            tablet: 14.0,
            desktop: 16.0,
          ),
          vertical: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            mobile: 12.0,
            tablet: 13.0,
            desktop: 14.0,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 12.0,
          tablet: 13.0,
          desktop: 14.0,
        ),
      ),
      items: ['All Categories', ...categories.map((c) => c['name'] as String)]
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
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

    return DropdownButtonFormField<String>(
      value: sortBy,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 12.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 12.0,
            tablet: 14.0,
            desktop: 16.0,
          ),
          vertical: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            mobile: 12.0,
            tablet: 13.0,
            desktop: 14.0,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 12.0,
          tablet: 13.0,
          desktop: 14.0,
        ),
      ),
      items: ['Name', 'Price', 'Category', 'Availability']
          .map(
            (sort) => DropdownMenuItem<String>(
              value: sort,
              child: Text(
                sort,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
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
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 12.0,
              tablet: 13.0,
              desktop: 14.0,
            ),
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
