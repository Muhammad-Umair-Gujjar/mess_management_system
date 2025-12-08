import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';
import '../../../student_controller.dart';

class AttendanceStatus extends StatelessWidget {
  final StudentController controller;
  final MenuItem menuItem;

  const AttendanceStatus({
    super.key,
    required this.controller,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context, 'small'),
            ),
            decoration: BoxDecoration(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
            ),
            child: Icon(
              FontAwesomeIcons.utensils,
              size: ResponsiveHelper.getIconSize(context, 'small'),
              color: Colors.white,
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu Available',
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'This ${menuItem.category} is ready to serve',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
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
