import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_grid_view.dart';
import '../../../student_controller.dart';

class QuickStatsGrid extends StatelessWidget {
  final StudentController controller;

  const QuickStatsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final monthlyStats = controller.getMonthlyStats();
      final attendanceRate = controller.attendanceRate.value;
      final monthlyBill = controller.monthlyBilling.value;

      final gridData = [
        GridCardData(
          title: 'Meals Attended',
          value: '${monthlyStats['attendedMeals']}',
          // subtitle: 'This Month',
          icon: FontAwesomeIcons.check,
          color: AppColors.success,
          trend: '+8%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Monthly Bill',
          value: '${monthlyBill.toStringAsFixed(0)} Rs',
          // subtitle: 'Current',
          icon: FontAwesomeIcons.receipt,
          color: AppColors.warning,
          trend: '+5%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Attendance Rate',
          value: '${attendanceRate.toStringAsFixed(1)}%',
          // subtitle: 'Overall',
          icon: FontAwesomeIcons.chartLine,
          color: AppColors.primary,
          trend: '+2%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Days Active',
          value: '${DateTime.now().day}',
          // subtitle: 'This Month',
          icon: FontAwesomeIcons.calendar,
          color: AppColors.info,
          trend: '${DateTime.now().day}d',
          trendIcon: FontAwesomeIcons.calendar,
          trendColor: AppColors.info,
        ),
      ];

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
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        cardStyle: CustomGridCardStyle.elevated,
        showAnimation: true,
      );
    });
  }
}
