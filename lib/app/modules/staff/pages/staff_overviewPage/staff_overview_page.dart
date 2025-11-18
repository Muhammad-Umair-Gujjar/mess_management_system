import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const WelcomeSection(),

              SizedBox(height: 24.h),

              // Today's Statistics Cards
              TodayStatsSection(todayStats: todayStats),

              SizedBox(height: 32.h),

              // Quick Actions
              QuickActionsSection(controller: controller),

              SizedBox(height: 32.h),

              // Recent Activity
              RecentActivitySection(todayStats: todayStats),
            ],
          ),
        );
      },
    );
  }
}
