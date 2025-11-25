import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'xsmall'),
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'xsmall'),
            ),
          ),
          child: Icon(
            icon,
            size: ResponsiveHelper.getIconSize(context, 'small'),
            color: color,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            
              Text(
                time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




