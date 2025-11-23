import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../staff_controller.dart';
import 'components/welcome_section.dart';
import 'components/today_stats_section.dart';
import 'components/quick_actions_section.dart';
import 'components/recent_activity_section.dart';

class StaffOverviewPage extends StatelessWidget {
  const StaffOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffController>(
      builder: (controller) {
        final todayStats = controller.getTodayStats();

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const WelcomeSection(),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

              // Today's Statistics Cards
              TodayStatsSection(todayStats: todayStats),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

              // Quick Actions
              QuickActionsSection(controller: controller),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

              // Recent Activity
              RecentActivitySection(todayStats: todayStats),
            ],
          ),
        );
      },
    );
  }
}
