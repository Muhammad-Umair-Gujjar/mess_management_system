import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class AttendanceStatsCard extends StatelessWidget {
  final StudentController controller;

  const AttendanceStatsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: ResponsiveHelper.getValue<double>(
          context,
          mobile: 400,
          tablet: 450,
          desktop: 500,
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildStats(context),
        ],
      ),
    ).animate().fadeIn(delay:  300.ms ).slideY(begin: 0.3);
  }

  Widget _buildHeader() {
    return Text('Monthly Overview', style: AppTextStyles.heading5);
  }

  Widget _buildStats(BuildContext context) {
    final monthlyStats = controller.getMonthlyStats();
    final attendanceRate = controller.attendanceRate.value;

    return Column(
      children: [
        _StatRow(
          label: 'Meals Attended',
          value: '${monthlyStats['attendedMeals']}',
          color: AppColors.success,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
        _StatRow(
          label: 'Meals Missed',
          value: '${monthlyStats['missedMeals']}',
          color: AppColors.error,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
        _StatRow(
          label: 'Attendance Rate',
          value: '${attendanceRate.toStringAsFixed(1)}%',
          color: AppColors.primary,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
        _buildProgressBar(context, attendanceRate),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, double attendanceRate) {
    return Container(
      height: ResponsiveHelper.getSpacing(context, 'small'),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'xs'),
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: attendanceRate / 100,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'xs'),
            ),
          ),
        ),
      ),
    ).animate().scaleX( duration: 300.ms , delay:  300.ms );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body2),
        Text(
          value,
          style: AppTextStyles.subtitle1.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}




