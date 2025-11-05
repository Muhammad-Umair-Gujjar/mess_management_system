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
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
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

              // Search Bar
              Container(
                width: 300.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search, size: 20.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: -0.3),

              SizedBox(width: 24.w),

              // Notification Icon
              _buildActionButton(
                FontAwesomeIcons.bell,
                () => _showNotifications(),
                badgeCount: 3,
              ).animate().fadeIn(delay: 500.ms).scale(),

              SizedBox(width: 16.w),

              // Settings Icon
              _buildActionButton(
                FontAwesomeIcons.gear,
                () => _showSettings(),
              ).animate().fadeIn(delay: 600.ms).scale(),

              SizedBox(width: 16.w),

              // Logout Button
              _buildActionButton(
                FontAwesomeIcons.rightFromBracket,
                () => _showLogoutDialog(),
                color: AppColors.error,
              ).animate().fadeIn(delay: 700.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
    int? badgeCount,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: (color ?? AppColors.textSecondary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: color ?? AppColors.textSecondary,
              ),
            ),
            if (badgeCount != null && badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  constraints: BoxConstraints(minWidth: 20.r, minHeight: 20.r),
                  child: Text(
                    badgeCount.toString(),
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
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

  void _showNotifications() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.r),
          decoration: AppDecorations.glassmorphicContainer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.bell, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Text('Notifications', style: AppTextStyles.heading5),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...List.generate(
                3,
                (index) => _buildNotificationItem(
                  'New menu for next week',
                  'The mess committee has updated the menu for next week. Check it out!',
                  '2 hours ago',
                  index,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String time,
    int index,
  ) {
    return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: AppDecorations.neumorphicContainer(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.subtitle2),
              SizedBox(height: 4.h),
              Text(message, style: AppTextStyles.body2),
              SizedBox(height: 8.h),
              Text(time, style: AppTextStyles.caption),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.3);
  }

  void _showSettings() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Settings', style: AppTextStyles.heading5),
            SizedBox(height: 24.h),
            _buildSettingsItem('Profile Settings', FontAwesomeIcons.user),
            _buildSettingsItem(
              'Notification Preferences',
              FontAwesomeIcons.bell,
            ),
            _buildSettingsItem('Privacy & Security', FontAwesomeIcons.shield),
            _buildSettingsItem(
              'Help & Support',
              FontAwesomeIcons.questionCircle,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSettingsItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.subtitle2),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Get.back(),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Logout', style: AppTextStyles.heading5),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Logout', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
