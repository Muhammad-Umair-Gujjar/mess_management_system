import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';

import '../../student_controller.dart';
import 'components/welcome_card.dart';
import 'components/quick_stats_grid.dart';
import 'components/todays_menu_card.dart';
import 'components/todays_attendance_card.dart';
import 'components/recent_activity_card.dart';
import 'components/quick_actions_card.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            WelcomeCard(controller: controller),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Quick Stats Grid
            QuickStatsGrid(controller: controller),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Today's Menu and Attendance
            ResponsiveHelper.buildResponsiveLayout(
              context: context,
              mobile: Column(
                children: [
                  TodaysMenuCard(controller: controller),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  TodaysAttendanceCard(controller: controller),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: TodaysMenuCard(controller: controller)),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  Expanded(child: TodaysAttendanceCard(controller: controller)),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Recent Activity and Quick Actions
            ResponsiveHelper.buildResponsiveLayout(
              context: context,
              mobile: Column(
                children: [
                  RecentActivityCard(controller: controller),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  QuickActionsCard(controller: controller),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: RecentActivityCard(controller: controller),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  Expanded(child: QuickActionsCard(controller: controller)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




