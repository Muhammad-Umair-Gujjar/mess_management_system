import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../admin_controller.dart';

class QuickActionsCard extends StatelessWidget {
  final AdminController controller;

  const QuickActionsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.heading5),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          ...quickActions
              .map(
                (action) => Container(
                  margin: EdgeInsets.only(
                    bottom: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
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
    ).animate().fadeIn(duration:  300.ms ).slideX(begin: 0.3);
  }
}




