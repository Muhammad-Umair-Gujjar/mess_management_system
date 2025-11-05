import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';

/// Tab bar component for Menu Management page
///
/// This widget creates a custom tab bar with three tabs:
/// - Menu Items: For managing individual food items
/// - Categories: For managing food categories
/// - Nutrition: For viewing nutritional analytics
class MenuTabBar extends StatelessWidget {
  final TabController tabController;

  const MenuTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: AppDecorations.floatingCard(),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.adminRole,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.adminRole,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          _buildTab(icon: FontAwesomeIcons.plateWheat, label: 'Menu Items'),
          _buildTab(icon: FontAwesomeIcons.layerGroup, label: 'Categories'),
          _buildTab(icon: FontAwesomeIcons.heartPulse, label: 'Nutrition'),
        ],
      ),
    );
  }

  /// Builds a single tab with icon and label
  Widget _buildTab({required IconData icon, required String label}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.sp),
          SizedBox(width: 8.w),
          Text(label),
        ],
      ),
    );
  }
}
