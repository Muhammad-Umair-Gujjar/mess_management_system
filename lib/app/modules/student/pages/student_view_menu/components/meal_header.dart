import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mess_management/app/data/models/attendance.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';

class MealHeader extends StatelessWidget {
  final MenuItem menuItem;
  final DateTime? selectedDate;

  const MealHeader({super.key, required this.menuItem, this.selectedDate});

  @override
  Widget build(BuildContext context) {
    // Format date as "Monday, Dec 08"
    final dateText = selectedDate != null
        ? DateFormat('EEEE, MMM dd').format(selectedDate!)
        : '';

    return Row(
      children: [
        Container(
          width: ResponsiveHelper.getSpacing(context, 'large') * 2,
          height: ResponsiveHelper.getSpacing(context, 'medium') * 2,
          decoration: BoxDecoration(
            gradient: menuItem.category.toLowerCase() == 'breakfast'
                ? LinearGradient(
                    colors: [
                      AppColors.warning,
                      AppColors.warning.withOpacity(0.7),
                    ],
                  )
                : LinearGradient(
                    colors: [AppColors.info, AppColors.info.withOpacity(0.7)],
                  ),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
          ),
          child: Icon(
            menuItem.category.toLowerCase() == 'breakfast'
                ? FontAwesomeIcons.sun
                : FontAwesomeIcons.moon,
            size: ResponsiveHelper.getIconSize(context, 'medium'),
            color: Colors.white,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menuItem.name,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (dateText.isNotEmpty) ...[
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
                Text(
                  dateText,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textLight,
                    fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
