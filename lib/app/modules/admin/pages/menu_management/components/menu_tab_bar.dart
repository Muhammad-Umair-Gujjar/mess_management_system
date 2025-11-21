import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../app/widgets/custom_tab_bar.dart';

/// Tab bar component for Menu Management page
///
/// This widget creates a custom tab bar with three tabs:
/// - Menu Items: For managing individual food items
/// - Categories: For managing food categories
/// - Nutrition: For viewing nutritional analytics
class MenuTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const MenuTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        // horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
        vertical: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      decoration: AppDecorations.floatingCard(),
      child: CustomUnderlineTabBar(
      
        tabs: [
          CustomTabBarItem(
            label: 'Menu Items',
            icon: FontAwesomeIcons.plateWheat,
          ),
          CustomTabBarItem(
            label: 'Categories',
            icon: FontAwesomeIcons.layerGroup,
          ),
          CustomTabBarItem(
            label: 'Nutrition',
            icon: FontAwesomeIcons.heartPulse,
          ),
        ],
        selectedIndex: selectedIndex,
        onTap: onTabChanged,

        selectedColor: AppColors.adminRole,
        unselectedColor: AppColors.textSecondary,
        indicatorColor: AppColors.adminRole,
        indicatorHeight: 3,

        showIcons: true,
      ),
    );
  }
}
