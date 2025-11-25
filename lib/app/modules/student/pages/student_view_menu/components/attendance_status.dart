import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
        decoration: BoxDecoration(
          color: isPresent
              ? AppColors.success.withOpacity(0.1)
              : isFuture
              ? AppColors.info.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
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
              padding: EdgeInsets.all(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
              decoration: BoxDecoration(
                color: isPresent
                    ? AppColors.success
                    : isFuture
                    ? AppColors.info
                    : AppColors.error,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'small'),
                ),
              ),
              child: Icon(
                isPresent
                    ? FontAwesomeIcons.check
                    : isFuture
                    ? FontAwesomeIcons.clock
                    : FontAwesomeIcons.xmark,
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




