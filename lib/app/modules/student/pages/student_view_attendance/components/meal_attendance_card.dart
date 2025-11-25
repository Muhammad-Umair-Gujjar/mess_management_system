import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/attendance.dart';
import '../../../student_controller.dart';

class MealAttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final StudentController controller;

  const MealAttendanceCard({
    super.key,
    required this.attendance,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final mealIcon = attendance.mealType == MealType.breakfast
        ? FontAwesomeIcons.sun
        : FontAwesomeIcons.moon;
    final mealName = attendance.mealType == MealType.breakfast
        ? 'Breakfast'
        : 'Dinner';
    final mealColor = attendance.mealType == MealType.breakfast
        ? AppColors.warning
        : AppColors.info;

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: BoxDecoration(
        color: attendance.isPresent
            ? mealColor.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
        border: Border.all(
          color: attendance.isPresent
              ? mealColor.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(context, mealIcon, mealName, mealColor),
          if (attendance.isPresent) ...[
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            _buildMealDetails(context, mealColor),
          ],
        ],
      ),
    );
  }

  Widget _buildMealHeader(
    BuildContext context,
    IconData mealIcon,
    String mealName,
    Color mealColor,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
          decoration: BoxDecoration(
            color: attendance.isPresent ? mealColor : AppColors.error,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'small'),
            ),
          ),
          child: Icon(
            mealIcon,
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
                mealName,
                style: AppTextStyles.subtitle1.copyWith(
                  color: attendance.isPresent ? mealColor : AppColors.error,
                ),
              ),
              Text(
                attendance.isPresent ? 'Present' : 'Absent',
                style: AppTextStyles.body2.copyWith(
                  color: attendance.isPresent
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ),
        Icon(
          attendance.isPresent
              ? FontAwesomeIcons.circleCheck
              : FontAwesomeIcons.circleXmark,
          color: attendance.isPresent ? AppColors.success : AppColors.error,
          size: ResponsiveHelper.getIconSize(context, 'large'),
        ),
      ],
    );
  }

  Widget _buildMealDetails(BuildContext context, Color mealColor) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
      decoration: BoxDecoration(
        color: mealColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'small'),
        ),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.utensils,
            size: ResponsiveHelper.getIconSize(context, 'small'),
            color: mealColor,
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
          Flexible(
            child: Text(
              _getMealDescription(attendance.mealType),
              style: AppTextStyles.body2.copyWith(color: mealColor,
              overflow: TextOverflow.ellipsis
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMealDescription(MealType mealType) {
    // This would typically come from the menu data
    return mealType == MealType.breakfast
        ? 'Aloo Paratha, Curd, Pickle'
        : 'Dal Rice, Sabzi, Roti, Salad';
  }
}




