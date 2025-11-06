import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/toast_message.dart';
import '../../../widgets/custom_grid_view.dart';

import '../student_controller.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeCard(context, controller),

            SizedBox(height: 32.h),

            // Quick Stats Grid
            _buildQuickStatsGrid(context, controller),

            SizedBox(height: 32.h),

            // Today's Menu and Attendance
            ResponsiveHelper.buildResponsiveLayout(
              context: context,
              mobile: Column(
                children: [
                  _buildTodaysMenu(context, controller),
                  SizedBox(height: 24.h),
                  _buildTodaysAttendance(context, controller),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTodaysMenu(context, controller)),
                  SizedBox(width: 24.w),
                  Expanded(child: _buildTodaysAttendance(context, controller)),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Recent Activity and Quick Actions
            ResponsiveHelper.buildResponsiveLayout(
              context: context,
              mobile: Column(
                children: [
                  _buildRecentActivity(context, controller),
                  SizedBox(height: 24.h),
                  _buildQuickActions(context, controller),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRecentActivity(context, controller),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(child: _buildQuickActions(context, controller)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, StudentController controller) {
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
            _buildWelcomeContent(context, controller, greeting),
            SizedBox(height: 24.h),
            _buildWelcomeAvatar(context),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              child: _buildWelcomeContent(context, controller, greeting),
            ),
            SizedBox(width: 32.w),
            _buildWelcomeAvatar(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3);
  }

  Widget _buildWelcomeContent(
    BuildContext context,
    StudentController controller,
    String greeting,
  ) {
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

  Widget _buildQuickStatsGrid(
    BuildContext context,
    StudentController controller,
  ) {
    return Obx(() {
      final monthlyStats = controller.getMonthlyStats();
      final attendanceRate = controller.attendanceRate.value;
      final monthlyBill = controller.monthlyBilling.value;

      final gridData = [
        GridCardData(
          title: 'Meals Attended',
          value: '${monthlyStats['attendedMeals']}',
          subtitle: 'This Month',
          icon: FontAwesomeIcons.check,
          color: AppColors.success,
          trend: '+8%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Monthly Bill',
          value: '₹${monthlyBill.toStringAsFixed(0)}',
          subtitle: 'Current',
          icon: FontAwesomeIcons.receipt,
          color: AppColors.warning,
          trend: '+5%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Attendance Rate',
          value: '${attendanceRate.toStringAsFixed(1)}%',
          subtitle: 'Overall',
          icon: FontAwesomeIcons.chartLine,
          color: AppColors.primary,
          trend: '+2%',
          trendIcon: FontAwesomeIcons.arrowTrendUp,
          trendColor: AppColors.success,
        ),
        GridCardData(
          title: 'Days Active',
          value: '${DateTime.now().day}',
          subtitle: 'This Month',
          icon: FontAwesomeIcons.calendar,
          color: AppColors.info,
          trend: '${DateTime.now().day}d',
          trendIcon: FontAwesomeIcons.calendar,
          trendColor: AppColors.info,
        ),
      ];

      return CustomGridView(
        data: gridData,
        crossAxisCount: 4, // Desktop: 4 columns
        mobileCrossAxisCount: 1, // Mobile: 1 column for better readability
        tabletCrossAxisCount: 2, // Tablet: 2 columns
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5, // Desktop aspect ratio
        mobileAspectRatio:
            2.0, // Mobile: wider cards for better content display
        tabletAspectRatio: 1.6, // Tablet: slightly wider cards
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        cardStyle: CustomGridCardStyle.elevated,
        showAnimation: true,
      );
    });
  }

  Widget _buildTodaysMenu(BuildContext context, StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.utensils,
                color: AppColors.accent,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text('Today\'s Menu', style: AppTextStyles.heading5),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    controller.changePage(3), // Navigate to menu page
                child: Text(
                  'View All',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

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

  Widget _buildTodaysAttendance(
    BuildContext context,
    StudentController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.calendarCheck,
                color: AppColors.success,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text('Today\'s Attendance', style: AppTextStyles.heading5),
            ],
          ),

          SizedBox(height: 20.h),

          Obx(() {
            final todayStats = controller.getTodaysStats();
            return Column(
              children: [
                _buildAttendanceItem(
                  '🌅 Breakfast',
                  todayStats['breakfastAttended'] == 1,
                  () => _markAttendance(controller, 'breakfast'),
                ),
                SizedBox(height: 16.h),
                _buildAttendanceItem(
                  '🌙 Dinner',
                  todayStats['dinnerAttended'] == 1,
                  () => _markAttendance(controller, 'dinner'),
                ),
              ],
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3);
  }

  Widget _buildAttendanceItem(
    String meal,
    bool isAttended,
    VoidCallback onTap,
  ) {
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

  Widget _buildRecentActivity(
    BuildContext context,
    StudentController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),

          ...List.generate(4, (index) {
            final activities = [
              {
                'title': 'Breakfast marked present',
                'time': '2 hours ago',
                'icon': FontAwesomeIcons.utensils,
                'color': AppColors.success,
              },
              {
                'title': 'Monthly bill updated',
                'time': '1 day ago',
                'icon': FontAwesomeIcons.receipt,
                'color': AppColors.warning,
              },
              {
                'title': 'Menu updated for next week',
                'time': '2 days ago',
                'icon': FontAwesomeIcons.calendarDays,
                'color': AppColors.info,
              },
              {
                'title': 'Feedback submitted',
                'time': '3 days ago',
                'icon': FontAwesomeIcons.comment,
                'color': AppColors.accent,
              },
            ];

            final activity = activities[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      size: 16.sp,
                      color: activity['color'] as Color,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: AppTextStyles.subtitle2,
                        ),
                        Text(
                          activity['time'] as String,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).animate(interval: 100.ms).fadeIn().slideX(begin: -0.2),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildQuickActions(
    BuildContext context,
    StudentController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),

          _buildActionButton(
            'View Attendance',
            FontAwesomeIcons.calendarCheck,
            AppColors.success,
            () => controller.changePage(1),
          ),
          SizedBox(height: 12.h),

          _buildActionButton(
            'Check Billing',
            FontAwesomeIcons.receipt,
            AppColors.warning,
            () => controller.changePage(2),
          ),
          SizedBox(height: 12.h),

          _buildActionButton(
            'Submit Feedback',
            FontAwesomeIcons.comment,
            AppColors.accent,
            () => controller.changePage(4),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3);
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitle2.copyWith(color: color),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _markAttendance(StudentController controller, String mealType) {
    ToastMessage.success('Attendance marked for $mealType');
  }
}
