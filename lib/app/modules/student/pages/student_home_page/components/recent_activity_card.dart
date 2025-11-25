import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class RecentActivityCard extends StatelessWidget {
  final StudentController controller;

  const RecentActivityCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(
            height: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
          ),
          _buildActivitiesList(context),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.clockRotateLeft,
              color: AppColors.primary,
              size: ResponsiveHelper.getIconSize(context, 'medium'),
            ),
            SizedBox(
              width: ResponsiveHelper.getSpacing(context, 'itemSpacing'),
            ),
            Text(
              'Recent Activity',
              style: AppTextStyles.heading5.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => Get.toNamed('/student/activity'),
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'button'),
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    final activities = controller.getRecentActivities().take(4).toList();

    if (activities.isEmpty) {
      return _buildEmptyState(context);
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'padding'),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.clockRotateLeft,
            color: Colors.grey,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
          ),
          SizedBox(
            height: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
          ),
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
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'itemSpacing'),
      ),
      child: Row(
        children: [
          _buildActivityIcon(context),
          SizedBox(
            width: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
          ),
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
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
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
    ).animate(delay: (100).ms).fadeIn().slideX(begin: 0.2);
  }

  Widget _buildActivityIcon(BuildContext context) {
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

    final iconSize = ResponsiveHelper.getIconSize(context, 'medium');
    return Container(
      width: iconSize + ResponsiveHelper.getSpacing(context, 'small') * 0.5,
      height: iconSize + ResponsiveHelper.getSpacing(context, 'small') * 0.5,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'small'),
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: ResponsiveHelper.getIconSize(context, 'small'),
      ),
    );
  }
}
