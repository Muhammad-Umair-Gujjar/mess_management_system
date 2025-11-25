import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../staff_controller.dart';

class CalendarView extends StatelessWidget {
  final StaffController controller;
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const CalendarView({
    super.key,
    required this.controller,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          children: [
            // Calendar Header
            Text('Attendance Overview', style: AppTextStyles.heading5),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
      
            // Calendar
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) => controller.getEventsForDay(day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.error,
                ),
                holidayTextStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.error,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                ),
                rightChevronIcon: Icon(
                  FontAwesomeIcons.chevronRight,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                ),
                titleTextStyle: AppTextStyles.heading5,
              ),
              onDaySelected: onDaySelected,
              onPageChanged: onPageChanged,
            ),
          ],
        ),
      ),
    );
  }
}




