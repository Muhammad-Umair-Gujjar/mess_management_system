import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_tab_bar.dart';

class ManagementTabSelector extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;

  const ManagementTabSelector({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
      decoration: AppDecorations.floatingCard(),
      child: CustomTabBar(
        selectedIndex: selectedTabIndex,
        onTap: onTabChanged,
        tabHeight: 45,
        tabs: [
          CustomTabBarItem(
            label: 'Active Students',
            icon: FontAwesomeIcons.users,
          ),
          CustomTabBarItem(
            label: 'Statistics',
            icon: FontAwesomeIcons.chartBar,
          ),
        ],
        selectedColor: Colors.white,
        unselectedColor: AppColors.textSecondary,
        selectedBackgroundColor: AppColors.success,
        unselectedBackgroundColor: Colors.transparent,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'small'),
        ),
        selectedTextStyle: AppTextStyles.body2.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedTextStyle: AppTextStyles.body2,
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
  }
}
