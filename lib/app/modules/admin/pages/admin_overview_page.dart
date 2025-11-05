import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/reusable_button.dart';
import '../admin_controller.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Stats Overview
            _buildSystemStatsGrid(controller, isMobile, context),

            SizedBox(height: 32.h),

            // Recent Activity and Quick Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Activity
                Expanded(flex: 2, child: _buildRecentActivity(controller)),

                if (!isMobile) ...[
                  SizedBox(width: 24.w),
                  // Quick Actions
                  Expanded(flex: 1, child: _buildQuickActions(controller)),
                ],
              ],
            ),

            if (isMobile) ...[
              SizedBox(height: 24.h),
              _buildQuickActions(controller),
            ],

            SizedBox(height: 32.h),

            // Pending Approvals
            _buildPendingApprovals(controller, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatsGrid(
    AdminController controller,
    bool isMobile,
    BuildContext context,
  ) {
    return Obx(() {
      final stats = controller.systemStats;
      final overviewStats = [
        {
          'title': 'Total Users',
          'value': '${stats['totalUsers']}',
          'icon': FontAwesomeIcons.users,
          'color': AppColors.primary,
          'trend': '+12%',
          'trendUp': true,
        },
        {
          'title': 'Active Students',
          'value': '${stats['totalStudents']}',
          'icon': FontAwesomeIcons.userGraduate,
          'color': AppColors.info,
          'trend': '+5%',
          'trendUp': true,
        },
        {
          'title': 'Staff Members',
          'value': '${stats['totalStaff']}',
          'icon': FontAwesomeIcons.userTie,
          'color': AppColors.success,
          'trend': '+2',
          'trendUp': true,
        },
        {
          'title': 'Monthly Revenue',
          'value': '₹${(stats['monthlyRevenue']! / 1000).toStringAsFixed(0)}K',
          'icon': FontAwesomeIcons.chartLine,
          'color': AppColors.warning,
          'trend': '+18%',
          'trendUp': true,
        },
        {
          'title': 'Pending Approvals',
          'value': '${stats['pendingApprovals']}',
          'icon': FontAwesomeIcons.clock,
          'color': AppColors.error,
          'trend': '-3',
          'trendUp': false,
        },
        {
          'title': 'System Uptime',
          'value': '${stats['systemUptime']}%',
          'icon': FontAwesomeIcons.server,
          'color': AppColors.success,
          'trend': '99.9%',
          'trendUp': true,
        },
      ];

      // Responsive grid configuration for 4 boxes per row on large screens
      final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
        context,
        mobile: 2, // 2 columns on mobile
        tablet: 3, // 3 columns on tablet
        desktop: 4, // 4 columns on desktop
      );

      final aspectRatio = ResponsiveHelper.getCardAspectRatio(context);

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 6.w : 8.w,
          mainAxisSpacing: ResponsiveHelper.isMobile(context) ? 6.h : 8.h,
          childAspectRatio: aspectRatio,
        ),
        itemCount: overviewStats.length,
        itemBuilder: (context, index) {
          final stat = overviewStats[index];
          return _buildStatCard(stat, index);
        },
      );
    });
  }

  Widget _buildStatCard(Map<String, dynamic> stat, int index) {
    final color = stat['color'] as Color;

    return Container(
          padding: EdgeInsets.all(16.r), // Further reduced for compact design
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              20.r,
            ), // Reduced from 16.r to 8.r
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r), // Reduced from 12.r to 6.r
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        12.r,
                      ), // Reduced from 12.r to 6.r
                    ),
                    child: Icon(
                      stat['icon'],
                      size: 30.sp,
                      color: color,
                    ), // Reduced from 20.sp to 12.sp
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w, // Reduced from 8.w to 4.w
                      vertical: 4.h, // Reduced from 4.h to 2.h
                    ),
                    decoration: BoxDecoration(
                      color: (stat['trendUp'] as bool)
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        12.r,
                      ), // Reduced from 12.r to 6.r
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          (stat['trendUp'] as bool)
                              ? FontAwesomeIcons.arrowTrendUp
                              : FontAwesomeIcons.arrowTrendDown,
                          size: 15.sp, // Reduced from 10.sp to 6.sp
                          color: (stat['trendUp'] as bool)
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        SizedBox(width: 4.w), // Reduced from 4.w to 2.w
                        Text(
                          stat['trend'],
                          style: AppTextStyles.caption.copyWith(
                            color: (stat['trendUp'] as bool)
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp, // Added smaller font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h), // Added small spacing
              Text(
                stat['value'],
                style: AppTextStyles.heading4.copyWith(
                  // Changed from heading3 to heading4
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp, // Added explicit smaller size
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h), // Reduced from 4.h to 2.h
              Text(
                stat['title'],
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 25.sp, // Added smaller font size
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildRecentActivity(AdminController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Recent Activity', style: AppTextStyles.heading5),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTextStyles.body2.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...List.generate(5, (index) {
            final activities = [
              {
                'icon': FontAwesomeIcons.userPlus,
                'title': 'New user registration',
                'subtitle': 'John Doe registered as Student',
                'time': '5 minutes ago',
                'color': AppColors.success,
              },
              {
                'icon': FontAwesomeIcons.utensils,
                'title': 'Menu item added',
                'subtitle': 'Chicken Biryani added to menu',
                'time': '1 hour ago',
                'color': AppColors.info,
              },
              {
                'icon': FontAwesomeIcons.indianRupee,
                'title': 'Rate updated',
                'subtitle': 'Breakfast rate changed to ₹45',
                'time': '2 hours ago',
                'color': AppColors.warning,
              },
              {
                'icon': FontAwesomeIcons.userCheck,
                'title': 'Staff approval',
                'subtitle': 'Sarah Johnson approved as Staff',
                'time': '3 hours ago',
                'color': AppColors.primary,
              },
              {
                'icon': FontAwesomeIcons.chartBar,
                'title': 'Report generated',
                'subtitle': 'Monthly analytics report created',
                'time': '4 hours ago',
                'color': AppColors.success,
              },
            ];

            final activity = activities[index];
            return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: (activity['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
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
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              activity['subtitle'] as String,
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        activity['time'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: Duration(milliseconds: 200 + (index * 100)))
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildQuickActions(AdminController controller) {
    final quickActions = [
      {
        'title': 'Add New User',
        'subtitle': 'Register student or staff',
        'icon': FontAwesomeIcons.userPlus,
        'color': AppColors.primary,
        'onTap': () => controller.changePage(1),
      },
      {
        'title': 'Update Rates',
        'subtitle': 'Modify meal pricing',
        'icon': FontAwesomeIcons.indianRupee,
        'color': AppColors.warning,
        'onTap': () => controller.changePage(3),
      },
      {
        'title': 'Menu Management',
        'subtitle': 'Add/edit menu items',
        'icon': FontAwesomeIcons.utensils,
        'color': AppColors.success,
        'onTap': () => controller.changePage(2),
      },
      {
        'title': 'Send Notification',
        'subtitle': 'Broadcast to users',
        'icon': FontAwesomeIcons.bell,
        'color': AppColors.info,
        'onTap': () => controller.changePage(5),
      },
    ];

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),
          ...quickActions
              .map(
                (action) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ReusableButton(
                    text: action['title'] as String,
                    // subtitle: action['subtitle'] as String,
                    icon: action['icon'] as IconData,
                    type: ButtonType.outline,
                    size: ButtonSize.large,
                    onPressed: action['onTap'] as VoidCallback,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.3);
  }

  Widget _buildPendingApprovals(AdminController controller, bool isMobile) {
    return Obx(() {
      final approvals = controller.pendingApprovals;

      return Container(
        padding: EdgeInsets.all(24.r),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pending Approvals', style: AppTextStyles.heading5),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${approvals.length} pending',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (approvals.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      size: 48.sp,
                      color: AppColors.success.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No pending approvals',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...approvals
                  .map(
                    (approval) => Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  approval['type'],
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                approval['submittedDate'],
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (approval['name'] != null) ...[
                            Text(
                              approval['name'],
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (approval['email'] != null)
                              Text(
                                approval['email'],
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                          if (approval['description'] != null)
                            Text(
                              approval['description'],
                              style: AppTextStyles.body2,
                            ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: ReusableButton(
                                  text: 'Approve',
                                  type: ButtonType.success,
                                  size: ButtonSize.small,
                                  onPressed: () =>
                                      controller.approveUser(approval['id']),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ReusableButton(
                                  text: 'Reject',
                                  type: ButtonType.danger,
                                  size: ButtonSize.small,
                                  onPressed: () =>
                                      controller.rejectUser(approval['id']),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.3);
    });
  }
}
