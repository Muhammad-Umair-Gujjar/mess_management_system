import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Choose Your Role',
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF2D3748),
                fontSize: 50.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 64.h),

            // Role Selection Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoleCard(
                  'Student',
                  'Access your meal plans, attendance, and billing',
                  FontAwesomeIcons.graduationCap,
                  const Color(0xFF3182CE),
                  () => Get.toNamed('/student'),
                ),
                SizedBox(width: 32.w),
                _buildRoleCard(
                  'Mess Staff',
                  'Mark attendance, manage daily operations',
                  FontAwesomeIcons.userTie,
                  const Color(0xFF38A169),
                  () => Get.toNamed('/staff'),
                ),
                SizedBox(width: 32.w),
                _buildRoleCard(
                  'Administrator',
                  'Full system control, analytics, and management',
                  FontAwesomeIcons.userShield,
                  const Color(0xFFE53E3E),
                  () => Get.toNamed('/admin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 440.w,
          height: 470.h,
          padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 32.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.13),
                spreadRadius: 2,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(icon, size: 50.sp, color: color),
              ),

              SizedBox(height: 28.h),

              // Title
              Text(
                title,
                style: AppTextStyles.heading4.copyWith(
                  color: const Color(0xFF2D3748),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 18.h),

              // Description
              Text(
                description,
                style: AppTextStyles.body2.copyWith(
                  color: const Color(0xFF718096),
                  fontSize: 22.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Access Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Access Dashboard',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
