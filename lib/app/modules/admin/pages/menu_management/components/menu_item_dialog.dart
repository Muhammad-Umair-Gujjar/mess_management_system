import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../../../widgets/common/reusable_text_field.dart';
import '../../../controllers/admin_menu_controller.dart';

/// Dialog for adding or editing menu items
///
/// This component provides a comprehensive form for creating or modifying menu items.
/// It includes fields for basic item information, nutritional data, category selection, and weekday planning.
class MenuItemDialog extends StatefulWidget {
  final String title;
  final bool isEdit;
  final TextEditingController itemNameController;
  final TextEditingController itemDescriptionController;
  final TextEditingController itemPriceController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final String? initialCategory;
  final String? initialWeekday;
  final Function(String category, String weekday) onSave;
  final VoidCallback onCancel;

  const MenuItemDialog({
    super.key,
    required this.title,
    required this.isEdit,
    required this.itemNameController,
    required this.itemDescriptionController,
    required this.itemPriceController,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
    required this.onSave,
    required this.onCancel,
    this.initialCategory,
    this.initialWeekday,
  });

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  late AdminMenuController controller;
  String? selectedCategory;
  String? selectedWeekday;

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminMenuController>();
    selectedCategory = widget.initialCategory;
    selectedWeekday = _capitalizeWeekday(widget.initialWeekday) ?? 'Monday';
  }

  /// Helper method to capitalize weekday from database format
  String? _capitalizeWeekday(String? weekday) {
    if (weekday == null) return null;
    final normalized = weekday.toLowerCase();
    switch (normalized) {
      case 'monday':
        return 'Monday';
      case 'tuesday':
        return 'Tuesday';
      case 'wednesday':
        return 'Wednesday';
      case 'thursday':
        return 'Thursday';
      case 'friday':
        return 'Friday';
      case 'saturday':
        return 'Saturday';
      case 'sunday':
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // For mobile, use full screen width dialog
    if (isMobile) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context, 'small'),
          vertical: ResponsiveHelper.getSpacing(context, 'large'),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getSpacing(context, 'large'),
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: AppDecorations.floatingCard(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildBasicInfoSection(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildCategoryAndWeekdaySection(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildDescriptionSection(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildNutritionSection(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      );
    }

    // For tablet and desktop, use fixed width dialog
    return Dialog(
      child: Container(
        width: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: double.infinity,
          tablet: 550.0,
          desktop: 600.0,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
        decoration: AppDecorations.floatingCard(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildBasicInfoSection(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildCategoryAndWeekdaySection(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildDescriptionSection(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildNutritionSection(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title
  Widget _buildDialogHeader(BuildContext context) {
    return Text(
      widget.title,
      style: AppTextStyles.heading3.copyWith(color: AppColors.adminRole),
    );
  }

  /// Builds the basic information section (name and price)
  Widget _buildBasicInfoSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReusableTextField(
            controller: widget.itemNameController,
            label: 'Item Name *',
            hintText: 'Enter item name',
            prefixIcon: Icons.restaurant,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
        Expanded(
          child: ReusableTextField(
            controller: widget.itemPriceController,
            label: 'Price (Rs) *',
            hintText: 'Enter price',
            prefixIcon: Icons.currency_rupee,
            type: TextFieldType.number,
          ),
        ),
      ],
    );
  }

  /// Builds the category and weekday selection section
  Widget _buildCategoryAndWeekdaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category & Scheduling',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(child: _buildWeekdayDropdown(context)),
          ],
        ),
      ],
    );
  }

  /// Builds the category dropdown
  Widget _buildCategoryDropdown(BuildContext context) {
    return Obx(() {
      final categories = controller.mealCategories;
      
      final categoryNames = categories.map((c) => c.name).toList();

      // Ensure selected category is valid
      if (selectedCategory == null ||
          !categoryNames.contains(selectedCategory)) {
        selectedCategory = categoryNames.isNotEmpty
            ? categoryNames.first
            : null;
      }

      return DropdownButtonFormField<String>(
        value: selectedCategory,
        style: const TextStyle(       
        // fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
        decoration: InputDecoration(
          labelText: 'Category *',

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        ),
        items: categoryNames.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category,style: TextStyle(fontWeight: FontWeight.w400),),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      );
    });
  }

  /// Builds the weekday dropdown
  Widget _buildWeekdayDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedWeekday,
       style: const TextStyle(        // 👈 This controls SELECTED item text
        // fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: 'Weekday *',

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      ),
      items: weekdays.map((weekday) {
        return DropdownMenuItem<String>(value: weekday, child: Text(weekday));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedWeekday = value;
        });
      },
      validator: (value) => value == null ? 'Please select a weekday' : null,
    );
  }

  /// Builds the description section
  Widget _buildDescriptionSection(BuildContext context) {
    return ReusableTextField(
      controller: widget.itemDescriptionController,
      label: 'Description',
      hintText: 'Enter item description',
      prefixIcon: Icons.description,
      maxLines: 3,
    );
  }

  /// Builds the nutritional information section
  Widget _buildNutritionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        Row(
          children: [
            Expanded(
              child: ReusableTextField(
                controller: widget.caloriesController,
                label: 'Calories',
                hintText: '0',
                prefixIcon: Icons.local_fire_department,
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: widget.proteinController,
                label: 'Protein',
                hintText: '0.0g',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: widget.carbsController,
                label: 'Carbs',
                hintText: '0.0g',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: widget.fatController,
                label: 'Fat',
                hintText: '0.0g',
                type: TextFieldType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the action buttons (Cancel and Save)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
        ReusableButton(
          text: widget.isEdit ? 'Update Item' : 'Add Item',
          onPressed: () {
            if (selectedCategory != null && selectedWeekday != null) {
              widget.onSave(selectedCategory!, selectedWeekday!);
            } else {
              // Show error message
              Get.snackbar(
                'Error',
                'Please select both category and weekday',
                backgroundColor: AppColors.error,
                colorText: Colors.white,
              );
            }
          },
          type: ButtonType.primary,
          size: ButtonSize.medium,
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 100.0,
            tablet: 110.0,
            desktop: 120.0,
          ),
        ),
      ],
    );
  }
}
