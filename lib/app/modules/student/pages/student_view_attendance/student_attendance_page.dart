import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../student_controller.dart';
import 'components/attendance_calendar_card.dart';
import 'components/day_details_card.dart';
import 'components/attendance_stats_card.dart';

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
          AttendanceCalendarCard(
            controller: controller,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDay: _selectedDay,
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
            onCalendarFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          DayDetailsCard(controller: controller, selectedDay: _selectedDay),
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
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: AttendanceCalendarCard(
                controller: controller,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDay: _selectedDay,
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
                onCalendarFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DayDetailsCard(
                    controller: controller,
                    selectedDay: _selectedDay,
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  AttendanceStatsCard(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




