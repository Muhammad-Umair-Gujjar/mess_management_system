import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/menu.dart';

class NutritionalCard extends StatelessWidget {
  final MenuItem menuItem;

  const NutritionalCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.seedling,
                size: 20.sp,
                color: AppColors.success,
              ),
              SizedBox(width: 12.w),
              Text(
                'Nutritional Information',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildNutritionalItem(
                'Calories',
                '${menuItem.calories.toInt()}',
                'kcal',
              ),
              SizedBox(width: 24.w),
              _buildNutritionalItem(
                'Protein',
                '${(menuItem.calories * 0.15 / 4).toInt()}',
                'g',
              ),
              SizedBox(width: 24.w),
              _buildNutritionalItem(
                'Carbs',
                '${(menuItem.calories * 0.55 / 4).toInt()}',
                'g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.success),
        ),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            text: value,
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
