import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../admin_controller.dart';

class RecentActivityCard extends StatelessWidget {
  final AdminController controller;

  const RecentActivityCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
}
