import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../staff_controller.dart';

class StudentCard extends StatelessWidget {
  final dynamic student;
  final StaffController controller;
  final int index;
  final String selectedMeal;
  final DateTime selectedDay;

  const StudentCard({
    super.key,
    required this.student,
    required this.controller,
    required this.index,
    required this.selectedMeal,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = controller.isStudentPresent(
      student['id'],
      selectedMeal,
      selectedDay,
    );

    return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isPresent == null
                  ? AppColors.textLight.withOpacity(0.2)
                  : isPresent
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.error.withOpacity(0.5),
              width: 2.w,
            ),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              // Student Avatar
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.staffRole.withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.staffRole,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${student['id']} • Room: ${student['room']}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Status
              _buildAttendanceToggle(isPresent),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildAttendanceToggle(bool? isPresent) {
    return Row(
      children: [
        // Status Indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isPresent == null
                ? AppColors.textLight.withOpacity(0.1)
                : isPresent
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            isPresent == null
                ? 'Not Marked'
                : isPresent
                ? 'Present'
                : 'Absent',
            style: AppTextStyles.caption.copyWith(
              color: isPresent == null
                  ? AppColors.textLight
                  : isPresent
                  ? AppColors.success
                  : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Toggle Buttons
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                selectedMeal,
                selectedDay,
                true,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isPresent == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 16.sp,
                  color: isPresent == true ? Colors.white : AppColors.success,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                selectedMeal,
                selectedDay,
                false,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isPresent == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  size: 16.sp,
                  color: isPresent == false ? Colors.white : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
