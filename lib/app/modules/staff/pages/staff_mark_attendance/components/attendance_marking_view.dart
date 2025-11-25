import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        isMobile
            ? ResponsiveHelper.getSpacing(context, 'medium')
            : ResponsiveHelper.getSpacing(context, 'large'),
      ),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions - responsive layout
          isMobile ? _buildMobileHeader(context) : _buildDesktopHeader(context),

          SizedBox(
            height: isMobile
                ? ResponsiveHelper.getSpacing(context, 'medium')
                : ResponsiveHelper.getSpacing(context, 'large'),
          ),

          // Search and Filter
          SearchAndFilterRow(controller: controller),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

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
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.3);
  }

  /// Mobile header layout - stack elements vertically
  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mark $selectedMeal Attendance',
              style: AppTextStyles.heading5.copyWith(fontSize: 18),
            ),
            // SizedBox(height: ResponsiveHelper.getSpacing(context, 'xxsmall')),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(selectedDay),
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // Quick actions - moved below title on mobile
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            QuickActionsRow(
              controller: controller,
              onMarkAllPresent: onMarkAllPresent,
              onMarkAllAbsent: onMarkAllAbsent,
            ),
          ],
        ),
      ],
    );
  }

  /// Desktop header layout - original horizontal layout
  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
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
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
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
    );
  }
}
