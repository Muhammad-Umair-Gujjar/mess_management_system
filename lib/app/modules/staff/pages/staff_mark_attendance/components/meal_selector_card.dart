import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_tab_bar.dart';

class MealSelectorCard extends StatelessWidget {
  final int selectedTabIndex;
  final String selectedMeal;
  final Function(int) onTabChanged;
  final Function(String) onMealChanged;

  const MealSelectorCard({
    super.key,
    required this.selectedTabIndex,
    required this.selectedMeal,
    required this.onTabChanged,
    required this.onMealChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomTabBar(
              selectedIndex: selectedTabIndex,
              onTap: onTabChanged,
              tabHeight: 40.0, // Reduced height from default 56.0
              selectedIconSize: 'small', // Makes selected icon small
              unselectedIconSize: 'small', // Makes unselected icon extra small
              tabs: [
                CustomTabBarItem(
                  label: 'Mark Attendance',
                  icon: FontAwesomeIcons.userCheck,
                ),
                CustomTabBarItem(
                  label: 'Calendar View',
                  icon: FontAwesomeIcons.calendar,
                ),
              ],
              selectedColor: Colors.white,
              unselectedColor: AppColors.textSecondary,
              selectedBackgroundColor: AppColors.staffRole,
              unselectedBackgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
              selectedTextStyle: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w500,
              ),
              unselectedTextStyle: AppTextStyles.body2,
            ),
          ),
          // SizedBox(width: ResponsiveHelper.getSpacing(context, 'xs')),
          _buildMealTypeChips(context),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
  }

  Widget _buildMealTypeChips(BuildContext context) {
    return Row(
      children: ['Breakfast', 'Dinner'].map((meal) {
        final isSelected = selectedMeal == meal;
        final color = meal == 'Breakfast' ? AppColors.warning : AppColors.info;

        return GestureDetector(
          onTap: () => onMealChanged(meal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: ResponsiveHelper.getSpacing(context, 'xsmall'),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
              vertical: ResponsiveHelper.getSpacing(context, 'xsmall'),
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: [color, color.withOpacity(0.8)])
                  : null,
              color: isSelected ? null : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'medium'),
              ),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  meal == 'Breakfast'
                      ? FontAwesomeIcons.sun
                      : FontAwesomeIcons.moon,
                  size: ResponsiveHelper.getIconSize(context, 'xsmall'),
                  color: isSelected ? Colors.white : color,
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, 'xs')),
                Text(
                  meal,
                  style: AppTextStyles.body2.copyWith(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
