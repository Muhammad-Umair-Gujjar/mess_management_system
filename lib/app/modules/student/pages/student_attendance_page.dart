import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../data/models/attendance.dart';
import '../student_controller.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  late final ValueNotifier<DateTime> _selectedDay;
  late final PageController _pageController;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier(DateTime.now());
    _pageController = PageController();
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentController>(
      init: Get.find<StudentController>(),
      builder: (controller) => Container(
        decoration: AppDecorations.backgroundGradient(),
        child: ResponsiveHelper.buildResponsiveLayout(
          context: context,
          mobile: _buildMobileLayout(controller),
          desktop: _buildDesktopLayout(controller),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          _buildCalendarCard(controller),
          SizedBox(height: 24.h),
          _buildDayDetailsCard(controller),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildCalendarCard(controller)),
          SizedBox(width: 24.w),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildDayDetailsCard(controller),
                SizedBox(height: 24.h),
                _buildAttendanceStats(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance Calendar',
                    style: AppTextStyles.heading4.copyWith(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 20,
                        tablet: 22,
                        desktop: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Track your daily meal attendance',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              // Calendar format toggle
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CalendarFormat>(
                    value: _calendarFormat,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                    ),
                    dropdownColor: Colors.white,
                    items: const [
                      DropdownMenuItem(
                        value: CalendarFormat.month,
                        child: Text('Month'),
                      ),
                      DropdownMenuItem(
                        value: CalendarFormat.twoWeeks,
                        child: Text('2 Weeks'),
                      ),
                      DropdownMenuItem(
                        value: CalendarFormat.week,
                        child: Text('Week'),
                      ),
                    ],
                    onChanged: (format) {
                      if (format != null) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Calendar
          TableCalendar<Attendance>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) => controller.getAttendanceForDate(day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: AppTextStyles.body2,
              holidayTextStyle: AppTextStyles.body2.copyWith(
                color: AppColors.error,
              ),
              defaultTextStyle: AppTextStyles.body2,
              selectedTextStyle: AppTextStyles.body2.copyWith(
                color: Colors.white,
              ),
              todayTextStyle: AppTextStyles.body2.copyWith(color: Colors.white),
              selectedDecoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(4.r),
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
                size: 16.sp,
              ),
              rightChevronIcon: Icon(
                FontAwesomeIcons.chevronRight,
                color: AppColors.primary,
                size: 16.sp,
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
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay.value = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay.value, day),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return _buildAttendanceMarkers(events.cast<Attendance>());
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Legend
          _buildLegend(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildAttendanceMarkers(List<Attendance> attendances) {
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
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          child: Icon(icon, size: 8.sp, color: color),
        );
      }).toList(),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
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
          SizedBox(height: 12.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: [
              _buildLegendItem(
                FontAwesomeIcons.sun,
                'Breakfast',
                AppColors.warning,
              ),
              _buildLegendItem(FontAwesomeIcons.moon, 'Dinner', AppColors.info),
              _buildLegendItem(
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

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: color),
        SizedBox(width: 8.w),
        Text(label, style: AppTextStyles.body2),
      ],
    );
  }

  Widget _buildDayDetailsCard(StudentController controller) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDay,
      builder: (context, selectedDay, _) {
        final dayAttendances = controller.getAttendanceForDate(selectedDay);
        final isToday = isSameDay(selectedDay, DateTime.now());

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isToday
                            ? 'Today'
                            : DateFormat('EEEE').format(selectedDay),
                        style: AppTextStyles.heading5,
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(selectedDay),
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (isToday)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
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
              ),

              SizedBox(height: 20.h),

              // Meals for the day
              if (dayAttendances.isEmpty)
                _buildEmptyState()
              else
                ...dayAttendances
                    .map(
                      (attendance) =>
                          _buildMealAttendanceCard(attendance, controller),
                    )
                    .toList(),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
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

  Widget _buildMealAttendanceCard(
    Attendance attendance,
    StudentController controller,
  ) {
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
          Row(
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
                        color: attendance.isPresent
                            ? mealColor
                            : AppColors.error,
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
                color: attendance.isPresent
                    ? AppColors.success
                    : AppColors.error,
                size: 24.sp,
              ),
            ],
          ),

          if (attendance.isPresent) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: mealColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.utensils,
                    size: 16.sp,
                    color: mealColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _getMealDescription(attendance.mealType),
                    style: AppTextStyles.body2.copyWith(color: mealColor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceStats(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Overview', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),

          Builder(
            builder: (context) {
              final monthlyStats = controller.getMonthlyStats();
              final attendanceRate = controller.attendanceRate.value;

              return Column(
                children: [
                  _buildStatRow(
                    'Meals Attended',
                    '${monthlyStats['attendedMeals']}',
                    AppColors.success,
                  ),
                  SizedBox(height: 12.h),
                  _buildStatRow(
                    'Meals Missed',
                    '${monthlyStats['missedMeals']}',
                    AppColors.error,
                  ),
                  SizedBox(height: 12.h),
                  _buildStatRow(
                    'Attendance Rate',
                    '${attendanceRate.toStringAsFixed(1)}%',
                    AppColors.primary,
                  ),

                  SizedBox(height: 20.h),

                  // Progress Bar
                  Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: attendanceRate / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ).animate().scaleX(duration: 1000.ms, delay: 500.ms),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body2),
        Text(
          value,
          style: AppTextStyles.subtitle1.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getMealDescription(MealType mealType) {
    // This would typically come from the menu data
    return mealType == MealType.breakfast
        ? 'Aloo Paratha, Curd, Pickle'
        : 'Dal Rice, Sabzi, Roti, Salad';
  }
}
