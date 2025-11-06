import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_decorations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../widgets/common/responsive_dashboard_layout.dart';
import 'pages/staff_attendance_page.dart';
import 'pages/staff_student_management_page.dart';
// import 'pages/staff_reports_page.dart'; // Commented out - can be enabled later
import 'staff_controller.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StaffController());

    return GetBuilder<StaffController>(
      builder: (controller) => ResponsiveDashboardLayout(
        title: 'Staff Dashboard',
        userRole: 'Staff',
        userName: 'Sarah Johnson',
        userEmail: 'sarah.johnson@messmaster.com',
        currentIndex: controller.currentPageIndex,
        onItemSelected: controller.changePage,
        menuItems: controller.navigationItems,
        header: _buildHeader(controller),
        onLogoutPressed: () => Get.offAllNamed('/'),
        child: GetBuilder<StaffController>(
          id: 'page_content',
          builder: (controller) =>
              _buildPageContent(controller.currentPageIndex.value),
        ),
      ),
    );
  }

  Widget _buildHeader(StaffController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isMobile(Get.context!) ? 16.w : 32.w,
        vertical: 24.h,
      ),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getCurrentPageTitle(),
                style: AppTextStyles.heading4.copyWith(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    Get.context!,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.getCurrentPageSubtitle(),
                style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
          const Spacer(),
          // Quick Stats
          () {
            final stats = controller.getTodayStats();
            return Row(
              children: [
                _buildQuickStat(
                  'Students',
                  '${stats['totalStudents']}',
                  FontAwesomeIcons.users,
                  AppColors.primary,
                ),
                SizedBox(width: 24.w),
                _buildQuickStat(
                  'Breakfast',
                  '${stats['breakfastPresent']}/${stats['totalStudents']}',
                  FontAwesomeIcons.sun,
                  AppColors.warning,
                ),
                SizedBox(width: 24.w),
                _buildQuickStat(
                  'Dinner',
                  '${stats['dinnerPresent']}/${stats['totalStudents']}',
                  FontAwesomeIcons.moon,
                  AppColors.info,
                ),
              ],
            );
          }(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: color)),
              Text(
                value,
                style: AppTextStyles.subtitle1.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return _buildOverviewPage();
      case 1:
        return const StaffAttendancePage();
      case 2:
        return const StaffStudentManagementPage();
      // case 3:
      //   return const StaffReportsPage(); // Commented out - can be enabled later
      default:
        return _buildOverviewPage();
    }
  }

  Widget _buildOverviewPage() {
    return GetBuilder<StaffController>(
      builder: (controller) {
        final todayStats = controller.getTodayStats();

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: AppDecorations.floatingCard().copyWith(
                  gradient: AppColors.primaryGradient,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.sun,
                          size: 32.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_getGreeting()}!',
                                style: AppTextStyles.heading4.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Welcome back, Sarah. Here\'s your daily overview.',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1),

              SizedBox(height: 24.h),

              // Today's Statistics Cards
              Text(
                'Today\'s Overview',
                style: AppTextStyles.heading5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              ResponsiveHelper.isDesktop(Get.context!)
                  ? Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Students',
                            '${todayStats['totalStudents']}',
                            FontAwesomeIcons.users,
                            AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildStatCard(
                            'Breakfast Attendance',
                            '${todayStats['breakfastPresent']}/${todayStats['totalStudents']}',
                            FontAwesomeIcons.sun,
                            AppColors.warning,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildStatCard(
                            'Dinner Attendance',
                            '${todayStats['dinnerPresent']}/${todayStats['totalStudents']}',
                            FontAwesomeIcons.moon,
                            AppColors.info,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildStatCard(
                            'Attendance Rate',
                            '${((todayStats['breakfastPresent'] + todayStats['dinnerPresent']) / (todayStats['totalStudents'] * 2) * 100).toStringAsFixed(1)}%',
                            FontAwesomeIcons.chartLine,
                            AppColors.success,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Students',
                                '${todayStats['totalStudents']}',
                                FontAwesomeIcons.users,
                                AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildStatCard(
                                'Attendance Rate',
                                '${((todayStats['breakfastPresent'] + todayStats['dinnerPresent']) / (todayStats['totalStudents'] * 2) * 100).toStringAsFixed(1)}%',
                                FontAwesomeIcons.chartLine,
                                AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Breakfast',
                                '${todayStats['breakfastPresent']}/${todayStats['totalStudents']}',
                                FontAwesomeIcons.sun,
                                AppColors.warning,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildStatCard(
                                'Dinner',
                                '${todayStats['dinnerPresent']}/${todayStats['totalStudents']}',
                                FontAwesomeIcons.moon,
                                AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

              SizedBox(height: 32.h),

              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTextStyles.heading5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              ResponsiveHelper.isDesktop(Get.context!)
                  ? Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            'Mark Attendance',
                            'Record student meal attendance',
                            FontAwesomeIcons.calendarCheck,
                            AppColors.primary,
                            () => controller.changePage(1),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildActionCard(
                            'Manage Students',
                            'Add or update student information',
                            FontAwesomeIcons.userPlus,
                            AppColors.info,
                            () => controller.changePage(2),
                          ),
                        ),
                        // Commented out - can be enabled later
                        // SizedBox(width: 16.w),
                        // Expanded(
                        //   child: _buildActionCard(
                        //     'View Reports',
                        //     'Check analytics and reports',
                        //     FontAwesomeIcons.chartLine,
                        //     AppColors.success,
                        //     () => controller.changePage(3),
                        //   ),
                        // ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildActionCard(
                          'Mark Attendance',
                          'Record student meal attendance',
                          FontAwesomeIcons.calendarCheck,
                          AppColors.primary,
                          () => controller.changePage(1),
                        ),
                        SizedBox(height: 16.h),
                        _buildActionCard(
                          'Manage Students',
                          'Add or update student information',
                          FontAwesomeIcons.userPlus,
                          AppColors.info,
                          () => controller.changePage(2),
                        ),
                        // Commented out - can be enabled later
                        // SizedBox(height: 16.h),
                        // _buildActionCard(
                        //   'View Reports',
                        //   'Check analytics and reports',
                        //   FontAwesomeIcons.chartLine,
                        //   AppColors.success,
                        //   () => controller.changePage(3),
                        // ),
                      ],
                    ),

              SizedBox(height: 32.h),

              // Recent Activity
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: AppDecorations.floatingCard(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: AppTextStyles.heading5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildActivityItem(
                      'Attendance marked for ${todayStats['breakfastPresent']} students',
                      'Breakfast - Today',
                      FontAwesomeIcons.check,
                      AppColors.success,
                    ),
                    SizedBox(height: 12.h),
                    _buildActivityItem(
                      'Menu updated for tomorrow',
                      '2 hours ago',
                      FontAwesomeIcons.utensils,
                      AppColors.info,
                    ),
                    SizedBox(height: 12.h),
                    _buildActivityItem(
                      'New student registered',
                      'Yesterday',
                      FontAwesomeIcons.userPlus,
                      AppColors.primary,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 24.sp, color: color),
              Text(
                value,
                style: AppTextStyles.heading4.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: AppDecorations.floatingCard().copyWith(
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 24.sp, color: color),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).slideX(begin: 0.1);
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
