import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../core/theme/app_decorations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/responsive_dashboard_layout.dart';
import 'student_controller.dart';
import 'pages/student_home_page.dart';
import 'pages/student_attendance_page.dart';
import 'pages/student_billing_page.dart';
import 'pages/student_menu_page.dart';
import 'pages/student_feedback_page.dart';

class EnhancedStudentDashboard extends StatelessWidget {
  const EnhancedStudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController(), permanent: true);

    return ResponsiveDashboardLayout(
      title: 'Student Dashboard',
      userRole: 'Student',
      userName: 'Ali Ahmed',
      userEmail: 'ali.ahmed@university.edu',
      currentIndex: controller.currentPageIndex,
      onItemSelected: controller.changePage,
      menuItems: controller.navigationItems,
      header: _buildTopAppBar(controller),
      onLogoutPressed: () => Get.offAllNamed('/'),
      child: Obx(() {
        final currentIndex = controller.currentPageIndex.value;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _getCurrentPage(currentIndex),
        );
      }),
    );
  }

  Widget _buildTopAppBar(StudentController controller) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 32.w,),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 20.r,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              // Page Title
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.getCurrentPageTitle(),
                      style: AppTextStyles.heading5.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.getCurrentPageSubtitle(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const StudentHomePage();
      case 1:
        return const StudentAttendancePage();
      case 2:
        return const StudentBillingPage();
      case 3:
        return const StudentMenuPage();
      case 4:
        return const StudentFeedbackPage();
      default:
        return _buildPlaceholderPage(
          'Dashboard',
          FontAwesomeIcons.house,
          AppColors.studentRole,
        );
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(40.r),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(48.r),
          decoration: AppDecorations.glassmorphicContainer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: AppDecorations.gradientContainer(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: Icon(icon, size: 64.sp, color: Colors.white),
              ).animate().scale(duration: 600.ms),

              SizedBox(height: 24.h),

              Text(
                title,
                style: AppTextStyles.heading3.copyWith(color: color),
              ).animate().fadeIn(delay: 300.ms),

              SizedBox(height: 12.h),

              Text(
                'Coming Soon!',
                style: AppTextStyles.subtitle1,
              ).animate().fadeIn(delay: 500.ms),

              SizedBox(height: 24.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Advanced features are under development',
                  style: AppTextStyles.body2.copyWith(color: color),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
