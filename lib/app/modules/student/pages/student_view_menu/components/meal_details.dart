import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';

class MealDetails extends StatelessWidget {
  final MenuItem menuItem;

  const MealDetails({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.bowlFood,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
                color: AppColors.primary,
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Text(
                'Description',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            menuItem.description,
            style: AppTextStyles.body1.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}




