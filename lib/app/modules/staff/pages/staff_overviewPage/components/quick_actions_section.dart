import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../staff_controller.dart';
import 'action_card.dart';

class QuickActionsSection extends StatelessWidget {
  final StaffController controller;

  const QuickActionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.heading5.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        ResponsiveHelper.isDesktop(Get.context!)
            ? Row(
                children: [
                  Expanded(
                    child: ActionCard(
                      title: 'Mark Attendance',
                      subtitle: 'Record student meal attendance',
                      icon: FontAwesomeIcons.calendarCheck,
                      color: AppColors.primary,
                      onTap: () => controller.changePage(1),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  Expanded(
                    child: ActionCard(
                      title: 'Manage Students',
                      subtitle: 'Add or update student information',
                      icon: FontAwesomeIcons.userPlus,
                      color: AppColors.info,
                      onTap: () => controller.changePage(2),
                    ),
                  ),
                  // Commented out - can be enabled later
                  // SizedBox(width: 16.w),
                  // Expanded(
                  //   child: ActionCard(
                  //     title: 'View Reports',
                  //     subtitle: 'Check analytics and reports',
                  //     icon: FontAwesomeIcons.chartLine,
                  //     color: AppColors.success,
                  //     onTap: () => controller.changePage(3),
                  //   ),
                  // ),
                ],
              )
            : Column(
                children: [
                  ActionCard(
                    title: 'Mark Attendance',
                    subtitle: 'Record student meal attendance',
                    icon: FontAwesomeIcons.calendarCheck,
                    color: AppColors.primary,
                    onTap: () => controller.changePage(1),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  ActionCard(
                    title: 'Manage Students',
                    subtitle: 'Add or update student information',
                    icon: FontAwesomeIcons.userPlus,
                    color: AppColors.info,
                    onTap: () => controller.changePage(2),
                  ),
                  // Commented out - can be enabled later
                  // SizedBox(height: 16.h),
                  // ActionCard(
                  //   title: 'View Reports',
                  //   subtitle: 'Check analytics and reports',
                  //   icon: FontAwesomeIcons.chartLine,
                  //   color: AppColors.success,
                  //   onTap: () => controller.changePage(3),
                  // ),
                ],
              ),
      ],
    );
  }
}




