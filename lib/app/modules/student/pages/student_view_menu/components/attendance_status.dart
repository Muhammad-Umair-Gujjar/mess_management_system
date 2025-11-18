import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
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
    return Obx(() {
      final attendance = controller.attendanceList
          .where(
            (a) =>
                a.date.day == menuItem.date.day &&
                a.date.month == menuItem.date.month &&
                a.date.year == menuItem.date.year &&
                a.mealType == menuItem.mealType,
          )
          .firstOrNull;

      final isPresent = attendance?.isPresent ?? false;
      final isFuture = menuItem.date.isAfter(DateTime.now());

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isPresent
              ? AppColors.success.withOpacity(0.1)
              : isFuture
              ? AppColors.info.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPresent
                ? AppColors.success.withOpacity(0.3)
                : isFuture
                ? AppColors.info.withOpacity(0.3)
                : AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isPresent
                    ? AppColors.success
                    : isFuture
                    ? AppColors.info
                    : AppColors.error,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isPresent
                    ? FontAwesomeIcons.check
                    : isFuture
                    ? FontAwesomeIcons.clock
                    : FontAwesomeIcons.xmark,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPresent
                        ? 'Attended'
                        : isFuture
                        ? 'Upcoming'
                        : 'Missed',
                    style: AppTextStyles.subtitle1.copyWith(
                      color: isPresent
                          ? AppColors.success
                          : isFuture
                          ? AppColors.info
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isPresent
                        ? 'You attended this meal'
                        : isFuture
                        ? 'Meal scheduled'
                        : 'You missed this meal',
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
    });
  }
}
