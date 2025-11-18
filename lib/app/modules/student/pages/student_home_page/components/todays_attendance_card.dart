import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../student_controller.dart';

class TodaysAttendanceCard extends StatelessWidget {
  final StudentController controller;

  const TodaysAttendanceCard({super.key, required this.controller});

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
          Obx(() {
            final todayStats = controller.getTodaysStats();
            return Column(
              children: [
                _AttendanceItem(
                  meal: '🌅 Breakfast',
                  isAttended: todayStats['breakfastAttended'] == 1,
                  onTap: () => _markAttendance(controller, 'breakfast'),
                ),
                SizedBox(height: 16.h),
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
    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3);
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.calendarCheck,
          color: AppColors.success,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Text('Today\'s Attendance', style: AppTextStyles.heading5),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isAttended
            ? AppColors.success.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isAttended ? AppColors.success : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAttended ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
            color: isAttended ? AppColors.success : Colors.grey,
            size: 20.sp,
          ),
          SizedBox(width: 16.w),
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
