import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../widgets/common/reusable_button.dart';

/// Header component for the Menu Management page
///
/// This widget displays the page title, description, and an "Add New Item" button.
/// It provides a clean, professional header for the admin menu management interface.
class MenuHeader extends StatelessWidget {
  final VoidCallback onAddItem;

  const MenuHeader({super.key, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          // Icon container with admin role styling
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.adminRole.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              FontAwesomeIcons.utensils,
              color: AppColors.adminRole,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 16.w),

          // Title and description section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menu Management',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Manage menu categories, items, and nutritional information',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Add new item button
          Flexible(
            child: ReusableButton(
              text: 'Add New Item',
              onPressed: onAddItem,
              type: ButtonType.primary,
              size: ButtonSize.medium,
              icon: FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
    );
  }
}
