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
    final statCards = [
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
        delay: 100,
      ),
      StatCard(
        title: 'Pending Approval',
        value: '${controller.getPendingApprovals().length}',
        icon: FontAwesomeIcons.clock,
        color: AppColors.warning,
        delay: 200,
      ),
      StatCard(
        title: 'This Month',
        value: '${(controller.allStudents.length * 0.15).round()}',
        icon: FontAwesomeIcons.userPlus,
        color: AppColors.info,
        delay: 300,
      ),
    ];

    // Use GridView for mobile to show 2 cards per row, Wrap for larger screens
    return ResponsiveHelper.isMobile(context)
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: statCards.length,
            itemBuilder: (context, index) => statCards[index],
          )
        : Wrap(
            spacing: ResponsiveHelper.getSpacing(context, 'medium'),
            runSpacing: ResponsiveHelper.getSpacing(context, 'medium'),
            children: statCards,
          );
  }
}
