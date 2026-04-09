import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import 'activity_item.dart';

class RecentActivitySection extends StatelessWidget {
  final Map<String, dynamic> todayStats;

  const RecentActivitySection({super.key, required this.todayStats});

  @override
  Widget build(BuildContext context) {
    final breakfastPresent = (todayStats['breakfastPresent'] ?? 0) as int;
    final dinnerPresent = (todayStats['dinnerPresent'] ?? 0) as int;
    final totalStudents = (todayStats['totalStudents'] ?? 0) as int;
    final breakfastAbsent = (todayStats['breakfastAbsent'] ?? 0) as int;
    final dinnerAbsent = (todayStats['dinnerAbsent'] ?? 0) as int;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTextStyles.heading5.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          ActivityItem(
            title:
                'Breakfast attendance marked for $breakfastPresent students',
            time: 'Breakfast - Today',
            icon: FontAwesomeIcons.check,
            color: AppColors.success,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          ActivityItem(
            title: 'Dinner attendance marked for $dinnerPresent students',
            time: 'Dinner - Today',
            icon: FontAwesomeIcons.moon,
            color: AppColors.info,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          ActivityItem(
            title:
                'Absentees today: Breakfast $breakfastAbsent, Dinner $dinnerAbsent (Total active: $totalStudents)',
            time: 'Live Overview',
            icon: FontAwesomeIcons.users,
            color: AppColors.warning,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }
}
