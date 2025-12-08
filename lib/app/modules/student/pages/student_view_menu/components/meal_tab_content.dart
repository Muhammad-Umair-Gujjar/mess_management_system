import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mess_management/app/data/models/attendance.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';
import 'meal_header.dart';
import 'meal_details.dart';
import 'nutritional_card.dart';
import 'attendance_status.dart';

class MealTabContent extends StatelessWidget {
  final StudentController controller;
  final MealType mealType;
  final int selectedDay;

  const MealTabContent({
    super.key,
    required this.controller,
    required this.mealType,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = _getSelectedDate();
      final menuItem = controller.getMenuForDate(selectedDate, mealType);

      if (menuItem == null) {
        return _buildEmptyMealState(context);
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealHeader(menuItem: menuItem, selectedDate: selectedDate),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            MealDetails(menuItem: menuItem),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            NutritionalCard(menuItem: menuItem),
            if (ResponsiveHelper.isMobile(context)) ...[
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              AttendanceStatus(controller: controller, menuItem: menuItem),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildEmptyMealState(BuildContext context) {
    final mealName = mealType == MealType.breakfast ? 'Breakfast' : 'Dinner';

    return Center(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xlarge')),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mealType == MealType.breakfast
                  ? FontAwesomeIcons.sun
                  : FontAwesomeIcons.moon,
              size: ResponsiveHelper.getIconSize(context, 'xlarge'),
              color: AppColors.textLight,
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            Text(
              'No $mealName Planned',
              style: AppTextStyles.heading5.copyWith(
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              'Menu for this day is not available yet.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getSelectedDate() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return startOfWeek.add(Duration(days: selectedDay));
  }
}
