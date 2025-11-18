import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';

class QuickActionsCard extends StatelessWidget {
  final StudentController controller;

  const QuickActionsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          _buildActionsGrid(context),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.bolt, color: AppColors.warning, size: 20.sp),
        SizedBox(width: 12.w),
        Text('Quick Actions', style: AppTextStyles.heading5),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    final actions = _getQuickActions();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) =>
          _QuickActionTile(action: actions[index], index: index),
    );
  }

  List<Map<String, dynamic>> _getQuickActions() {
    return [
      {
        'title': 'View Menu',
        'icon': FontAwesomeIcons.utensils,
        'color': AppColors.secondary,
        'onTap': () => Get.toNamed('/student/menu'),
      },
      {
        'title': 'View Attendance',
        'icon': FontAwesomeIcons.calendarCheck,
        'color': AppColors.success,
        'onTap': () => Get.toNamed('/student/attendance'),
      },
      {
        'title': 'Bills',
        'icon': FontAwesomeIcons.creditCard,
        'color': AppColors.info,
        'onTap': () => Get.toNamed('/student/payment'),
      },
      {
        'title': 'Complaint',
        'icon': FontAwesomeIcons.exclamationTriangle,
        'color': AppColors.warning,
        'onTap': () => Get.toNamed('/student/complaint'),
      },
    ];
  }
}

class _QuickActionTile extends StatelessWidget {
  final Map<String, dynamic> action;
  final int index;

  const _QuickActionTile({required this.action, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action['onTap'],
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: (action['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: (action['color'] as Color).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: action['color'],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(action['icon'], color: Colors.white, size: 18.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              action['title'],
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: action['color'],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100).ms).scale(begin: const Offset(0.8, 0.8));
  }
}
