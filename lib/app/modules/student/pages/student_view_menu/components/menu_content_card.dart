import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mess_management/app/data/models/attendance.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_tab_bar.dart';
import '../../../student_controller.dart';
import 'meal_tab_content.dart';

class MenuContentCard extends StatelessWidget {
  final StudentController controller;
  final int selectedTabIndex;
  final int selectedDay;
  final Function(int) onTabChanged;

  const MenuContentCard({
    super.key,
    required this.controller,
    required this.selectedTabIndex,
    required this.selectedDay,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Tab Bar
          Container(
            margin: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            child: CustomTabBar(
              selectedIndex: selectedTabIndex,
              onTap: onTabChanged,
              tabs: [
                CustomTabBarItem(
                  label: 'Breakfast',
                  icon: FontAwesomeIcons.sun,
                ),
                CustomTabBarItem(label: 'Dinner', icon: FontAwesomeIcons.moon),
              ],
              selectedColor: Colors.white,
              unselectedColor: AppColors.textSecondary,
              selectedBackgroundColor: AppColors.primary,
              unselectedBackgroundColor: AppColors.background,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
              tabHeight: 45.0,
            ),
          ),

          // Tab Content - Fixed height to avoid unbounded constraints
          SizedBox(
            height:
                ResponsiveHelper.getSpacing(context, 'xlarge') *
                12, // Fixed height instead of Expanded
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                MealTabContent(
                  controller: controller,
                  mealType: MealType.breakfast,
                  selectedDay: selectedDay,
                ),
                MealTabContent(
                  controller: controller,
                  mealType: MealType.dinner,
                  selectedDay: selectedDay,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3);
  }
}
