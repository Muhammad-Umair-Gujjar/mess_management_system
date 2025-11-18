import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../staff_controller.dart';
import 'quick_actions_row.dart';
import 'search_and_filter_row.dart';
import 'students_list_view.dart';

class AttendanceMarkingView extends StatelessWidget {
  final StaffController controller;
  final bool isMobile;
  final String selectedMeal;
  final DateTime selectedDay;
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkAllAbsent;

  const AttendanceMarkingView({
    super.key,
    required this.controller,
    required this.isMobile,
    required this.selectedMeal,
    required this.selectedDay,
    required this.onMarkAllPresent,
    required this.onMarkAllAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mark $selectedMeal Attendance',
                    style: AppTextStyles.heading5,
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(selectedDay),
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              QuickActionsRow(
                controller: controller,
                onMarkAllPresent: onMarkAllPresent,
                onMarkAllAbsent: onMarkAllAbsent,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Search and Filter
          SearchAndFilterRow(controller: controller),

          SizedBox(height: 20.h),

          // Students List
          Expanded(
            child: StudentsListView(
              controller: controller,
              isMobile: isMobile,
              selectedMeal: selectedMeal,
              selectedDay: selectedDay,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }
}
