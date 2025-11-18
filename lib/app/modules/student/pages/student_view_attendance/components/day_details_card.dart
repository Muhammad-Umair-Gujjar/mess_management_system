import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/attendance.dart';
import '../../../student_controller.dart';
import 'meal_attendance_card.dart';

class DayDetailsCard extends StatelessWidget {
  final StudentController controller;
  final ValueNotifier<DateTime> selectedDay;

  const DayDetailsCard({
    super.key,
    required this.controller,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDay,
      builder: (context, selectedDay, _) {
        final dayAttendances = controller.getAttendanceForDate(selectedDay);
        final isToday = isSameDay(selectedDay, DateTime.now());

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(selectedDay, isToday),
              SizedBox(height: 20.h),
              _buildContent(dayAttendances),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildHeader(DateTime selectedDay, bool isToday) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isToday ? 'Today' : DateFormat('EEEE').format(selectedDay),
              style: AppTextStyles.heading5,
            ),
            Text(
              DateFormat('MMM dd, yyyy').format(selectedDay),
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        const Spacer(),
        if (isToday)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Today',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(List<Attendance> dayAttendances) {
    if (dayAttendances.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: dayAttendances
          .map(
            (attendance) => MealAttendanceCard(
              attendance: attendance,
              controller: controller,
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.r),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.calendarXmark,
            size: 48.sp,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No meals scheduled',
            style: AppTextStyles.subtitle1.copyWith(color: AppColors.textLight),
          ),
          SizedBox(height: 8.h),
          Text(
            'There are no meals scheduled for this day.',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
