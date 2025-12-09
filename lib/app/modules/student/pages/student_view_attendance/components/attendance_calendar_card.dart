import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/attendance.dart';
import '../../../student_controller.dart';

class AttendanceCalendarCard extends StatelessWidget {
  final StudentController controller;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final ValueNotifier<DateTime> selectedDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(CalendarFormat format) onFormatChanged;
  final Function(DateTime focusedDay) onPageChanged;
  final Function(CalendarFormat format) onCalendarFormatChanged;

  const AttendanceCalendarCard({
    super.key,
    required this.controller,
    required this.focusedDay,
    required this.calendarFormat,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.onCalendarFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildCalendar(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildLegend(context),
        ],
      ),
    ).animate().fadeIn(duration:  300.ms ).slideY(begin: -0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: (ResponsiveHelper.isMobile(context) ? 7 : 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance Calendar',
                style: AppTextStyles.heading5.copyWith(
                  // fontSize: ResponsiveHelper.getResponsiveFontSize(
                  //   context,
                  //   mobile: 22,
                  //   tablet: 24,
                  //   desktop: 22,
                  // ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
              Text(
                'Track your daily meal attendance',

                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textLight,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 16,
                    tablet: 16,
                    desktop: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(flex: (ResponsiveHelper.isMobile(context) ? 5 : 3), child: _buildFormatToggle(context)),
      ],
    );
  }

  Widget _buildFormatToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        // vertical: ResponsiveHelper.getSpacing(context, 'xs'),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CalendarFormat>(
          value: calendarFormat,
          style: AppTextStyles.body1.copyWith(color: AppColors.primary),
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(value: CalendarFormat.month, child: Text('Month')),
            DropdownMenuItem(
              value: CalendarFormat.twoWeeks,
              child: Text('2 Weeks'),
            ),
            DropdownMenuItem(value: CalendarFormat.week, child: Text('Week')),
          ],
          onChanged: (format) {
            if (format != null) {
              onCalendarFormatChanged(format);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar<Attendance>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      eventLoader: (day) => controller.getAttendanceForDate(day),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: AppTextStyles.body2,
        holidayTextStyle: AppTextStyles.body2.copyWith(color: AppColors.error),
        defaultTextStyle: AppTextStyles.body2,
        selectedTextStyle: AppTextStyles.body2.copyWith(color: Colors.white),
        todayTextStyle: AppTextStyles.body2.copyWith(color: Colors.white),
        selectedDecoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
        ),
        markerDecoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'xs'),
          ),
        ),
        markersMaxCount: 2,
        canMarkersOverflow: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: AppTextStyles.heading5,
        leftChevronIcon: Icon(
          FontAwesomeIcons.chevronLeft,
          color: AppColors.primary,
          size: ResponsiveHelper.getIconSize(context, 'small'),
        ),
        rightChevronIcon: Icon(
          FontAwesomeIcons.chevronRight,
          color: AppColors.primary,
          size: ResponsiveHelper.getIconSize(context, 'small'),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppTextStyles.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        weekendStyle: AppTextStyles.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
      onPageChanged: onPageChanged,
      selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return _buildAttendanceMarkers(context, events.cast<Attendance>());
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAttendanceMarkers(
    BuildContext context,
    List<Attendance> attendances,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: attendances.take(2).map((attendance) {
        Color color = AppColors.error; // Default for absent
        IconData icon = FontAwesomeIcons.xmark;

        if (attendance.isPresent) {
          color = attendance.mealType == MealType.breakfast
              ? AppColors.warning
              : AppColors.info;
          icon = attendance.mealType == MealType.breakfast
              ? FontAwesomeIcons.sun
              : FontAwesomeIcons.moon;
        }

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xs') / 2,
          ),
          child: Icon(
            icon,
            size: ResponsiveHelper.getIconSize(context, 'xsmall'),
            color: color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'medium'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Wrap(
            spacing: ResponsiveHelper.getSpacing(context, 'medium'),
            runSpacing: ResponsiveHelper.getSpacing(context, 'small'),
            children: [
              _buildLegendItem(
                context,
                FontAwesomeIcons.sun,
                'Breakfast',
                AppColors.warning,
              ),
              _buildLegendItem(
                context,
                FontAwesomeIcons.moon,
                'Dinner',
                AppColors.info,
              ),
              _buildLegendItem(
                context,
                FontAwesomeIcons.xmark,
                'Absent',
                AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.getIconSize(context, 'xsmall'),
          color: color,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        Text(label, style: AppTextStyles.body2),
      ],
    );
  }
}




