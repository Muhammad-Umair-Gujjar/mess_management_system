import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../admin_controller.dart';

class RecentActivityCard extends StatelessWidget {
  final AdminController controller;

  const RecentActivityCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
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
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
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
                'subtitle': 'Breakfast rate changed to Rs45',
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
                  margin: EdgeInsets.only(
                    bottom: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          ResponsiveHelper.getSpacing(context, 'small'),
                        ),
                        decoration: BoxDecoration(
                          color: (activity['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getSpacing(context, 'small'),
                          ),
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          size: ResponsiveHelper.getIconSize(context, 'small'),
                          color: activity['color'] as Color,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(context, 'medium'),
                      ),
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
                .animate(delay: Duration(milliseconds: 50))
                .fadeIn(duration: 300.ms)
                .slideX(begin: -0.3);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3);
  }
}
