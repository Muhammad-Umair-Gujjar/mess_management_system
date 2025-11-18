import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: attendance.isPresent
            ? mealColor.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: attendance.isPresent
              ? mealColor.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(mealIcon, mealName, mealColor),
          if (attendance.isPresent) ...[
            SizedBox(height: 16.h),
            _buildMealDetails(mealColor),
          ],
        ],
      ),
    );
  }

  Widget _buildMealHeader(IconData mealIcon, String mealName, Color mealColor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: attendance.isPresent ? mealColor : AppColors.error,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(mealIcon, size: 20.sp, color: Colors.white),
        ),
        SizedBox(width: 16.w),
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
          size: 24.sp,
        ),
      ],
    );
  }

  Widget _buildMealDetails(Color mealColor) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: mealColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.utensils, size: 16.sp, color: mealColor),
          SizedBox(width: 8.w),
          Text(
            _getMealDescription(attendance.mealType),
            style: AppTextStyles.body2.copyWith(color: mealColor),
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
