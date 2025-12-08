import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';

class NutritionalCard extends StatelessWidget {
  final MenuItem menuItem;

  const NutritionalCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.seedling,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
                color: AppColors.success,
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Text(
                'Nutritional Information',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Row(
            children: [
              _buildNutritionalItem(
                context,
                'Calories',
                '${menuItem.nutritionalInfo.calories.toInt()}',
                'kcal',
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
              _buildNutritionalItem(
                context,
                'Protein',
                '${menuItem.nutritionalInfo.protein.toInt()}',
                'g',
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
              _buildNutritionalItem(
                context,
                'Carbs',
                '${menuItem.nutritionalInfo.carbs.toInt()}',
                'g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalItem(
    BuildContext context,
    String label,
    String value,
    String unit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.success),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small') * 0.5),
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
