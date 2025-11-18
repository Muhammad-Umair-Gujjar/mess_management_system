import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mess_management/app/data/models/attendance.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';
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
      final menuItem = controller.menuItems
          .where(
            (item) =>
                item.mealType == mealType &&
                item.date.day == selectedDate.day &&
                item.date.month == selectedDate.month &&
                item.date.year == selectedDate.year,
          )
          .firstOrNull;

      if (menuItem == null) {
        return _buildEmptyMealState();
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealHeader(menuItem: menuItem),
            SizedBox(height: 24.h),
            MealDetails(menuItem: menuItem),
            SizedBox(height: 24.h),
            NutritionalCard(menuItem: menuItem),
            if (ResponsiveHelper.isMobile(context)) ...[
              SizedBox(height: 24.h),
              AttendanceStatus(controller: controller, menuItem: menuItem),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildEmptyMealState() {
    final mealName = mealType == MealType.breakfast ? 'Breakfast' : 'Dinner';

    return Center(
      child: Container(
        padding: EdgeInsets.all(40.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mealType == MealType.breakfast
                  ? FontAwesomeIcons.sun
                  : FontAwesomeIcons.moon,
              size: 64.sp,
              color: AppColors.textLight,
            ),
            SizedBox(height: 20.h),
            Text(
              'No $mealName Planned',
              style: AppTextStyles.heading5.copyWith(
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: 8.h),
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
