import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';

class TodaysMenuCard extends StatelessWidget {
  final StudentController controller;

  const TodaysMenuCard({super.key, required this.controller});

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
          _buildMealCard(
            context,
            '🌅 Breakfast',
            'Aloo Paratha, Curd, Pickle',
            '8:00 AM - 10:00 AM',
            AppColors.warning,
          ),
          SizedBox(height: 16.h),
          _buildMealCard(
            context,
            '🌙 Dinner',
            'Dal Rice, Sabzi, Roti, Salad',
            '7:00 PM - 9:00 PM',
            AppColors.info,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.3);
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.utensils, color: AppColors.accent, size: 20.sp),
        SizedBox(width: 12.w),
        Text('Today\'s Menu', style: AppTextStyles.heading5),
        const Spacer(),
        TextButton(
          onPressed: () => controller.changePage(3), // Navigate to menu page
          child: Text(
            'View All',
            style: AppTextStyles.button.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String meal,
    String items,
    String time,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal, style: AppTextStyles.subtitle1.copyWith(color: color)),
          SizedBox(height: 8.h),
          Text(items, style: AppTextStyles.body2),
          SizedBox(height: 4.h),
          Text(time, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
