import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, selectedDay, isToday),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
              _buildContent(context, dayAttendances),
            ],
          ),
        ).animate().fadeIn(duration:  300.ms );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DateTime selectedDay,
    bool isToday,
  ) {
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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, 'small'),
              vertical: ResponsiveHelper.getSpacing(context, 'xs'),
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'large'),
              ),
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

  Widget _buildContent(BuildContext context, List<Attendance> dayAttendances) {
    if (dayAttendances.isEmpty) {
      return _buildEmptyState(context);
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xlarge')),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.calendarXmark,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
            color: AppColors.textLight,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Text(
            'No meals scheduled',
            style: AppTextStyles.subtitle1.copyWith(color: AppColors.textLight),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
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




