import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mess_management/core/utils/responsive_helper.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/custom_grid_view.dart';
import '../../../controllers/admin_overview_controller.dart';

class SystemStatsGrid extends StatelessWidget {
  final AdminOverviewController overviewController;
  final bool isMobile;

  const SystemStatsGrid({
    super.key,
    required this.overviewController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = overviewController.systemStats;
      final overviewStats = [
        {
          'title': 'Total Users',
          'value': '${stats['totalUsers']}',
          'icon': FontAwesomeIcons.users,
          'color': AppColors.primary,
          'trend': '+12%',
          'trendUp': true,
        },
        {
          'title': 'Active Students',
          'value': '${stats['totalStudents']}',
          'icon': FontAwesomeIcons.userGraduate,
          'color': AppColors.info,
          'trend': '+5%',
          'trendUp': true,
        },
        {
          'title': 'Staff Members',
          'value': '${stats['totalStaff']}',
          'icon': FontAwesomeIcons.userTie,
          'color': AppColors.success,
          'trend': '+2',
          'trendUp': true,
        },
        {
          'title': 'Monthly Revenue',
          'value':
              '${(stats['monthlyRevenue']! / 1000).toStringAsFixed(0)}K Rs',
          'icon': FontAwesomeIcons.chartLine,
          'color': AppColors.warning,
          'trend': '+18%',
          'trendUp': true,
        },
        {
          'title': 'Pending Approvals',
          'value': '${stats['pendingApprovals']}',
          'icon': FontAwesomeIcons.clock,
          'color': AppColors.error,
          'trend': '-3',
          'trendUp': false,
        },
        {
          'title': 'System Uptime',
          'value': '${stats['systemUptime']}%',
          'icon': FontAwesomeIcons.server,
          'color': AppColors.success,
          'trend': '99.9%',
          'trendUp': true,
        },
      ];

      // Convert to GridCardData format
      final gridData = overviewStats
          .map(
            (stat) => GridCardData(
              title: stat['title'] as String,
              value: stat['value'] as String,
              icon: stat['icon'] as IconData,
              color: stat['color'] as Color,
              trend: stat['trend'] as String?,
              trendIcon: (stat['trendUp'] as bool)
                  ? FontAwesomeIcons.arrowTrendUp
                  : FontAwesomeIcons.arrowTrendDown,
              trendColor: (stat['trendUp'] as bool)
                  ? AppColors.success
                  : AppColors.error,
            ),
          )
          .toList();

      return CustomGridView(
        data: gridData,
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
          context,
          configType: 'statsCards',
        ),
        mobileCrossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
          context,
          mobile: 2,
          configType: 'statsCards',
        ),
        tabletCrossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
          context,
          tablet: 3,
          configType: 'statsCards',
        ),
        crossAxisSpacing: ResponsiveHelper.getSpacing(context, 'itemSpacing'),
        mainAxisSpacing: ResponsiveHelper.getSpacing(context, 'itemSpacing'),
        childAspectRatio: ResponsiveHelper.getAspectRatio(context, 'statsCard'),
        mobileAspectRatio: ResponsiveHelper.getAspectRatio(
          context,
          'statsCard',
        ),
        tabletAspectRatio: ResponsiveHelper.getAspectRatio(
          context,
          'statsCard',
        ), // Tablet: wider cards
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        cardStyle: CustomGridCardStyle.gradient,
        showAnimation: true,
      );
    });
  }
}
