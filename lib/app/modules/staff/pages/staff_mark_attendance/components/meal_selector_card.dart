import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
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
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Expanded(
            child: CustomTabBar(
              selectedIndex: selectedTabIndex,
              onTap: onTabChanged,
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
              borderRadius: BorderRadius.circular(12.r),
              selectedTextStyle: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedTextStyle: AppTextStyles.body2,
            ),
          ),
          SizedBox(width: 20.w),
          _buildMealTypeChips(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildMealTypeChips() {
    return Row(
      children: ['Breakfast', 'Dinner'].map((meal) {
        final isSelected = selectedMeal == meal;
        final color = meal == 'Breakfast' ? AppColors.warning : AppColors.info;

        return GestureDetector(
          onTap: () => onMealChanged(meal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(left: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: [color, color.withOpacity(0.8)])
                  : null,
              color: isSelected ? null : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  meal == 'Breakfast'
                      ? FontAwesomeIcons.sun
                      : FontAwesomeIcons.moon,
                  size: 14.sp,
                  color: isSelected ? Colors.white : color,
                ),
                SizedBox(width: 6.w),
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
