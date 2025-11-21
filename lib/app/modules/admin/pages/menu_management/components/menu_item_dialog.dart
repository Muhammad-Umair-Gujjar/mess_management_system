import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../../../widgets/common/reusable_text_field.dart';

/// Dialog for adding or editing menu items
///
/// This component provides a comprehensive form for creating or modifying menu items.
/// It includes fields for basic item information and nutritional data.
class MenuItemDialog extends StatelessWidget {
  final String title;
  final bool isEdit;
  final TextEditingController itemNameController;
  final TextEditingController itemDescriptionController;
  final TextEditingController itemPriceController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final VoidCallback onSave;
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
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 400.0,
          tablet: 500.0,
          desktop: 600.0,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
      title,
      style: AppTextStyles.heading3.copyWith(color: AppColors.adminRole),
    );
  }

  /// Builds the basic information section (name and price)
  Widget _buildBasicInfoSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReusableTextField(
            controller: itemNameController,
            label: 'Item Name *',
            hintText: 'Enter item name',
            prefixIcon: Icons.restaurant,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
        Expanded(
          child: ReusableTextField(
            controller: itemPriceController,
            label: 'Price (₹) *',
            hintText: 'Enter price',
            prefixIcon: Icons.currency_rupee,
            type: TextFieldType.number,
          ),
        ),
      ],
    );
  }

  /// Builds the description section
  Widget _buildDescriptionSection(BuildContext context) {
    return ReusableTextField(
      controller: itemDescriptionController,
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
          style: AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        Row(
          children: [
            Expanded(
              child: ReusableTextField(
                controller: caloriesController,
                label: 'Calories',
                hintText: '0',
                prefixIcon: Icons.local_fire_department,
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: proteinController,
                label: 'Protein (g)',
                hintText: '0.0',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: carbsController,
                label: 'Carbs (g)',
                hintText: '0.0',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: ReusableTextField(
                controller: fatController,
                label: 'Fat (g)',
                hintText: '0.0',
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
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
        ReusableButton(
          text: isEdit ? 'Update Item' : 'Add Item',
          onPressed: onSave,
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
