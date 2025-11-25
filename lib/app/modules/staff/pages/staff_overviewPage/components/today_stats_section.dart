import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../staff_controller.dart';
import 'stat_card.dart';

class TodayStatsSection extends StatelessWidget {
  final Map<String, dynamic> todayStats;

  const TodayStatsSection({super.key, required this.todayStats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Overview',
          style: AppTextStyles.heading5.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        ResponsiveHelper.isDesktop(Get.context!)
            ? Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Students',
                      value: '${todayStats['totalStudents']}',
                      icon: FontAwesomeIcons.users,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  Expanded(
                    child: StatCard(
                      title: 'Breakfast Attendance',
                      value:
                          '${todayStats['breakfastPresent']}/${todayStats['totalStudents']}',
                      icon: FontAwesomeIcons.sun,
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  Expanded(
                    child: StatCard(
                      title: 'Dinner Attendance',
                      value:
                          '${todayStats['dinnerPresent']}/${todayStats['totalStudents']}',
                      icon: FontAwesomeIcons.moon,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  Expanded(
                    child: StatCard(
                      title: 'Attendance Rate',
                      value:
                          '${((todayStats['breakfastPresent'] + todayStats['dinnerPresent']) / (todayStats['totalStudents'] * 2) * 100).toStringAsFixed(1)}%',
                      icon: FontAwesomeIcons.chartLine,
                      color: AppColors.success,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Students',
                          value: '${todayStats['totalStudents']}',
                          icon: FontAwesomeIcons.users,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(context, 'medium'),
                      ),
                      Expanded(
                        child: StatCard(
                          title: 'Attendance Rate',
                          value:
                              '${((todayStats['breakfastPresent'] + todayStats['dinnerPresent']) / (todayStats['totalStudents'] * 2) * 100).toStringAsFixed(1)}%',
                          icon: FontAwesomeIcons.chartLine,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Breakfast',
                          value:
                              '${todayStats['breakfastPresent']}/${todayStats['totalStudents']}',
                          icon: FontAwesomeIcons.sun,
                          color: AppColors.warning,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(context, 'medium'),
                      ),
                      Expanded(
                        child: StatCard(
                          title: 'Dinner',
                          value:
                              '${todayStats['dinnerPresent']}/${todayStats['totalStudents']}',
                          icon: FontAwesomeIcons.moon,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}




