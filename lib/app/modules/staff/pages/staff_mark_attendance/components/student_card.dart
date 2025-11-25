import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'small'),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            border: Border.all(
              color: isPresent == null
                  ? AppColors.textLight.withOpacity(0.2)
                  : isPresent
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.error.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              // Student Avatar
              CircleAvatar(
                radius: ResponsiveHelper.getSpacing(context, 'large'),
                backgroundColor: AppColors.staffRole.withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.staffRole,
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

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
              _buildAttendanceToggle(context, isPresent),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildAttendanceToggle(BuildContext context, bool? isPresent) {
    return Row(
      children: [
        // Status Indicator
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'small'),
            vertical: ResponsiveHelper.getSpacing(context, 'xs'),
          ),
          decoration: BoxDecoration(
            color: isPresent == null
                ? AppColors.textLight.withOpacity(0.1)
                : isPresent
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'small'),
            ),
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

        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),

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
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'xsmall'),
                ),
                decoration: BoxDecoration(
                  color: isPresent == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'xsmall'),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                  color: isPresent == true ? Colors.white : AppColors.success,
                ),
              ),
            ),

            SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),

            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                selectedMeal,
                selectedDay,
                false,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'xsmall'),
                ),
                decoration: BoxDecoration(
                  color: isPresent == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'xsmall'),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
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
