import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class MenuPageHeader extends StatelessWidget {
  final StudentController controller;

  const MenuPageHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'medium'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Weekly Menu',
                  style: AppTextStyles.heading4.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'heading4'),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
                Text(
                  'Plan your meals for the week',
                  maxLines: 2,
                  style: AppTextStyles.body2.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textLight,
                    fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
          Container(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                vertical: ResponsiveHelper.getSpacing(context, 'small'),
              ),
              tablet: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                vertical: ResponsiveHelper.getSpacing(context, 'small'),
              ),
              desktop: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                vertical: ResponsiveHelper.getSpacing(context, 'small'),
              ),
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'medium'),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.calendarWeek,
                  size: ResponsiveHelper.getIconSize(context, 'xsmall'),
                  color: Colors.white,
                ),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, 'xsmall'),
                ),
                Text(
                  'This Week',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      'body3',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




