import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class RecentActivitiesList extends StatelessWidget {
  const RecentActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'action': 'Student Approved',
        'student': 'Ali Ahmed',
        'time': '2 hours ago',
      },
      {
        'action': 'New Registration',
        'student': 'Sara Khan',
        'time': '4 hours ago',
      },
      {
        'action': 'Student Rejected',
        'student': 'Ahmed Hassan',
        'time': '1 day ago',
      },
      {
        'action': 'Profile Updated',
        'student': 'Fatima Ali',
        'time': '2 days ago',
      },
    ];

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Container(
              margin: EdgeInsets.only(
                bottom: ResponsiveHelper.getSpacing(context, 'xsmall'),
              ),
              padding: EdgeInsets.all(
                ResponsiveHelper.getSpacing(context, 'medium'),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'small'),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getSpacing(context, 'xsmall'),
                    ),
                    decoration: BoxDecoration(
                      color: _getActivityColor(
                        activity['action']!,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getSpacing(context, 'xsmall'),
                      ),
                    ),
                    child: Icon(
                      _getActivityIcon(activity['action']!),
                      size: ResponsiveHelper.getIconSize(context, 'small'),
                      color: _getActivityColor(activity['action']!),
                    ),
                  ),

                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'small'),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['action']!,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          activity['student']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    activity['time']!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            )
            .animate(delay: Duration(milliseconds: 50))
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.3);
      },
    );
  }

  Color _getActivityColor(String action) {
    switch (action.toLowerCase()) {
      case 'student approved':
        return AppColors.success;
      case 'student rejected':
        return AppColors.error;
      case 'new registration':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action.toLowerCase()) {
      case 'student approved':
        return FontAwesomeIcons.check;
      case 'student rejected':
        return FontAwesomeIcons.xmark;
      case 'new registration':
        return FontAwesomeIcons.userPlus;
      default:
        return FontAwesomeIcons.pencil;
    }
  }
}
