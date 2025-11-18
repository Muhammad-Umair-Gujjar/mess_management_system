import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class WelcomeCard extends StatelessWidget {
  final StudentController controller;

  const WelcomeCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 20.r : 32.r),
      decoration: AppDecorations.gradientContainer(
        gradient: AppColors.primaryGradient,
      ),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeContent(context, greeting),
            SizedBox(height: 24.h),
            _buildWelcomeAvatar(context),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildWelcomeContent(context, greeting)),
            SizedBox(width: 32.w),
            _buildWelcomeAvatar(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3);
  }

  Widget _buildWelcomeContent(BuildContext context, String greeting) {
    return Obx(() {
      final student = controller.currentStudent.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting 👋',
            style: AppTextStyles.heading5.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            student?.name ?? 'Loading...',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              student?.hostelName != null && student?.roomNumber != null
                  ? '${student!.hostelName} • Room ${student.roomNumber}'
                  : 'Loading hostel info...',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Welcome back! Check your meal attendance, view today\'s menu, and manage your billing.',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 16,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildWelcomeAvatar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 16.r : 24.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Icon(
        FontAwesomeIcons.graduationCap,
        size: ResponsiveHelper.isMobile(context) ? 32.sp : 48.sp,
        color: Colors.white,
      ),
    ).animate().scale(delay: 500.ms);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
