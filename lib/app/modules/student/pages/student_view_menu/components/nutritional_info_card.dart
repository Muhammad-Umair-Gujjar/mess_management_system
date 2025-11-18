import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';

class NutritionalInfoCard extends StatelessWidget {
  final StudentController controller;

  const NutritionalInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Nutrition', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),

          // Calories Progress
          _buildNutritionProgress(
            'Calories',
            2400,
            3500, // Weekly target: 500 per day * 7 days
            AppColors.warning,
            FontAwesomeIcons.fire,
          ),

          SizedBox(height: 16.h),

          // Protein Progress
          _buildNutritionProgress(
            'Protein',
            180,
            350, // Weekly target
            AppColors.success,
            FontAwesomeIcons.dumbbell,
          ),
        ],
      ),
    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildNutritionProgress(
    String label,
    double current,
    double target,
    Color color,
    IconData icon,
  ) {
    final percentage = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '${current.toInt()}/${target.toInt()}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
