import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../student_controller.dart';

class TodaysAttendanceCard extends StatelessWidget {
  final StudentController controller;

  const TodaysAttendanceCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          Obx(() {
            final todayStats = controller.getTodaysStats();
            return Column(
              children: [
                _AttendanceItem(
                  meal: '🌅 Breakfast',
                  isAttended: todayStats['breakfastAttended'] == 1,
                  onTap: () => _markAttendance(controller, 'breakfast'),
                ),
                SizedBox(
                  height: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
                ),
                _AttendanceItem(
                  meal: '🌙 Dinner',
                  isAttended: todayStats['dinnerAttended'] == 1,
                  onTap: () => _markAttendance(controller, 'dinner'),
                ),
              ],
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.calendarCheck,
          color: AppColors.success,
          size: ResponsiveHelper.getIconSize(context, 'medium'),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'itemSpacing')),
        Text(
          'Today\'s Attendance',
          style: AppTextStyles.heading5.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
          ),
        ),
      ],
    );
  }

  void _markAttendance(StudentController controller, String mealType) {
    ToastMessage.success('Attendance marked for $mealType');
  }
}

class _AttendanceItem extends StatelessWidget {
  final String meal;
  final bool isAttended;
  final VoidCallback onTap;

  const _AttendanceItem({
    required this.meal,
    required this.isAttended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'sectionMargin'),
      decoration: BoxDecoration(
        color: isAttended
            ? AppColors.success.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'medium'),
        ),
        border: Border.all(
          color: isAttended ? AppColors.success : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAttended ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
            color: isAttended ? AppColors.success : Colors.grey,
            size: ResponsiveHelper.getIconSize(context, 'medium'),
          ),
          SizedBox(
            width: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
          ),
          Expanded(
            child: Text(
              meal,
              style: AppTextStyles.subtitle2.copyWith(
                color: isAttended ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            isAttended ? 'Present' : 'Absent',
            style: AppTextStyles.caption.copyWith(
              color: isAttended ? AppColors.success : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
