import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';

class RecentActivityCard extends StatelessWidget {
  final StudentController controller;

  const RecentActivityCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 16.h),
          _buildActivitiesList(),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.3);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.clockRotateLeft,
              color: AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text('Recent Activity', style: AppTextStyles.heading5),
          ],
        ),
        TextButton(
          onPressed: () => Get.toNamed('/student/activity'),
          child: Text('View All'),
        ),
      ],
    );
  }

  Widget _buildActivitiesList() {
    final activities = controller.getRecentActivities().take(4).toList();

    if (activities.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: activities
          .asMap()
          .entries
          .map(
            (entry) => _ActivityItem(activity: entry.value, index: entry.key),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.r),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.clockRotateLeft,
            color: Colors.grey,
            size: 40.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No recent activity',
            style: AppTextStyles.subtitle2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;
  final int index;

  const _ActivityItem({required this.activity, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          _buildActivityIcon(),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] ?? '',
                  style: AppTextStyles.subtitle2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  activity['description'] ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            activity['time'] ?? '',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.2);
  }

  Widget _buildActivityIcon() {
    final type = activity['type'] ?? '';
    IconData icon;
    Color color;

    switch (type) {
      case 'meal':
        icon = FontAwesomeIcons.utensils;
        color = AppColors.secondary;
        break;
      case 'attendance':
        icon = FontAwesomeIcons.calendarCheck;
        color = AppColors.success;
        break;
      case 'payment':
        icon = FontAwesomeIcons.creditCard;
        color = AppColors.info;
        break;
      case 'complaint':
        icon = FontAwesomeIcons.exclamationTriangle;
        color = AppColors.warning;
        break;
      default:
        icon = FontAwesomeIcons.bell;
        color = AppColors.primary;
    }

    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: color, size: 16.sp),
    );
  }
}
