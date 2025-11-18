import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../staff_controller.dart';
import 'stats_cards_grid.dart';
import 'recent_activities_list.dart';

class StudentStatsTab extends StatelessWidget {
  final StaffController controller;
  final bool isMobile;

  const StudentStatsTab({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Statistics', style: AppTextStyles.heading5),

          SizedBox(height: 24.h),

          // Stats Cards
          StatsCardsGrid(controller: controller),

          SizedBox(height: 32.h),

          Text('Recent Activities', style: AppTextStyles.heading5),

          SizedBox(height: 16.h),

          Expanded(child: RecentActivitiesList()),
        ],
      ),
    );
  }
}
