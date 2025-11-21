import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../staff_controller.dart';
import 'stat_card.dart';

class StatsCardsGrid extends StatelessWidget {
  final StaffController controller;

  const StatsCardsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ResponsiveHelper.getSpacing(context, 'medium'),
      runSpacing: ResponsiveHelper.getSpacing(context, 'medium'),
      children: [
        StatCard(
          title: 'Total Students',
          value: '${controller.allStudents.length}',
          icon: FontAwesomeIcons.users,
          color: AppColors.primary,
          delay: 0,
        ),
        StatCard(
          title: 'Active Students',
          value:
              '${controller.allStudents.where((s) => s['isApproved'] == true).length}',
          icon: FontAwesomeIcons.userCheck,
          color: AppColors.success,
          delay: 200,
        ),
        StatCard(
          title: 'Pending Approval',
          value: '${controller.getPendingApprovals().length}',
          icon: FontAwesomeIcons.clock,
          color: AppColors.warning,
          delay: 400,
        ),
        StatCard(
          title: 'This Month',
          value: '${(controller.allStudents.length * 0.15).round()}',
          icon: FontAwesomeIcons.userPlus,
          color: AppColors.info,
          delay: 600,
        ),
      ],
    );
  }
}
