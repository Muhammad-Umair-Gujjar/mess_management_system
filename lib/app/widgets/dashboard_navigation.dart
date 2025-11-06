import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';

class ResponsiveDashboardNavigation extends StatelessWidget {
  final String userRole;
  final String userName;
  final String userEmail;
  final RxInt currentIndex;
  final Function(int) onItemSelected;
  final List<NavigationItem> menuItems;

  const ResponsiveDashboardNavigation({
    super.key,
    required this.userRole,
    required this.userName,
    required this.userEmail,
    required this.currentIndex,
    required this.onItemSelected,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    // Always show menu icon; tapping opens Drawer with navigation
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}

class DashboardNavigation extends StatelessWidget {
  final String userRole;
  final String userName;
  final String userEmail;
  final RxInt currentIndex;
  final Function(int) onItemSelected;
  final List<NavigationItem> menuItems;

  const DashboardNavigation({
    super.key,
    required this.userRole,
    required this.userName,
    required this.userEmail,
    required this.currentIndex,
    required this.onItemSelected,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20.r,
            offset: Offset(4.w, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Profile Section
          _buildUserProfile(),

          SizedBox(height: 32.h),

          // Navigation Menu
          Expanded(child: _buildNavigationMenu()),

          // Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.all(16.r),
      decoration: AppDecorations.gradientContainer(
        gradient: _getRoleGradient(userRole),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              _getRoleIcon(userRole),
              size: 32.sp,
              color: Colors.white,
            ),
          ).animate().scale(delay: 200.ms),

          SizedBox(height: 16.h),

          // User Info
          Text(
            userName,
            style: AppTextStyles.heading5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),

          SizedBox(height: 4.h),

          Text(
            userRole.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3),

          SizedBox(height: 8.h),

          Text(
            userEmail,
            style: AppTextStyles.body3.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.3),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Obx(
              () => _buildNavigationItem(
                item,
                index,
                currentIndex.value == index,
              ),
            )
            .animate(delay: Duration(milliseconds: 600 + index * 100))
            .fadeIn()
            .slideX(begin: -0.3);
      },
    );
  }

  Widget _buildNavigationItem(NavigationItem item, int index, bool isActive) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: isActive ? _getRoleGradient(userRole) : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _getRoleColor(userRole).withOpacity(0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : _getRoleColor(userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20.sp,
                    color: isActive ? Colors.white : _getRoleColor(userRole),
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.navMenuItem.copyWith(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),

                if (item.badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      item.badge!.toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),

                if (isActive)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Logout Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _handleLogout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.rightFromBracket,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Version Info
          Text(
            'MessMaster v1.0.0',
            style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3);
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/');
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  LinearGradient _getRoleGradient(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return LinearGradient(
          colors: [
            AppColors.studentRole,
            AppColors.studentRole.withOpacity(0.8),
          ],
        );
      case 'staff':
        return LinearGradient(
          colors: [AppColors.staffRole, AppColors.staffRole.withOpacity(0.8)],
        );
      case 'admin':
        return LinearGradient(
          colors: [AppColors.adminRole, AppColors.adminRole.withOpacity(0.8)],
        );
      default:
        return AppColors.primaryGradient;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return AppColors.studentRole;
      case 'staff':
        return AppColors.staffRole;
      case 'admin':
        return AppColors.adminRole;
      default:
        return AppColors.primary;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return FontAwesomeIcons.graduationCap;
      case 'staff':
        return FontAwesomeIcons.userTie;
      case 'admin':
        return FontAwesomeIcons.userShield;
      default:
        return FontAwesomeIcons.user;
    }
  }
}

class NavigationItem {
  final IconData icon;
  final String title;
  final String route;
  final int? badge;

  const NavigationItem({
    required this.icon,
    required this.title,
    required this.route,
    this.badge,
  });
}
