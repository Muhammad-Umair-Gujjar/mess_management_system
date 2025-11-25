import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../app/widgets/custom_tab_bar.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'large'),
        vertical: ResponsiveHelper.getSpacing(context, 'large'),
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




