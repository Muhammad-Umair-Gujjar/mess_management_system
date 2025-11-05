import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
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
        width: 600.w,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: EdgeInsets.all(24.r),
        decoration: AppDecorations.floatingCard(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(),
              SizedBox(height: 24.h),
              _buildBasicInfoSection(),
              SizedBox(height: 16.h),
              _buildDescriptionSection(),
              SizedBox(height: 16.h),
              _buildNutritionSection(),
              SizedBox(height: 24.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title
  Widget _buildDialogHeader() {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(color: AppColors.adminRole),
    );
  }

  /// Builds the basic information section (name and price)
  Widget _buildBasicInfoSection() {
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
        SizedBox(width: 16.w),
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
  Widget _buildDescriptionSection() {
    return ReusableTextField(
      controller: itemDescriptionController,
      label: 'Description',
      hintText: 'Enter item description',
      prefixIcon: Icons.description,
      maxLines: 3,
    );
  }

  /// Builds the nutritional information section
  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information',
          style: AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
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
            SizedBox(width: 12.w),
            Expanded(
              child: ReusableTextField(
                controller: proteinController,
                label: 'Protein (g)',
                hintText: '0.0',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ReusableTextField(
                controller: carbsController,
                label: 'Carbs (g)',
                hintText: '0.0',
                type: TextFieldType.number,
              ),
            ),
            SizedBox(width: 12.w),
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
  Widget _buildActionButtons() {
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
        SizedBox(width: 16.w),
        ReusableButton(
          text: isEdit ? 'Update Item' : 'Add Item',
          onPressed: onSave,
          type: ButtonType.primary,
          size: ButtonSize.medium,
          width: 120.w,
        ),
      ],
    );
  }
}
