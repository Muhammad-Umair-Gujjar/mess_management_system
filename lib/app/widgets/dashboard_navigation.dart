import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/responsive_constants.dart';
import '../../core/utils/responsive_helper.dart';

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
      width: ResponsiveHelper.getValue(
        context,
        mobile: 320.0,
        tablet: 360.0,
        desktop: 320.0,
      ),
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
            blurRadius: ResponsiveHelper.getValue(
              context,
              mobile: 20.0,
              tablet: 22.0,
              desktop: 24.0,
            ),
            offset: Offset(ResponsiveHelper.getSpacing(context, 'small'), 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Profile Section
          _buildUserProfile(context),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

          // Navigation Menu
          Expanded(child: _buildNavigationMenu(context)),

          // Bottom Actions
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'large'),
      margin: ResponsiveHelper.getMargin(context, 'medium'),
      decoration: AppDecorations.gradientContainer(
        gradient: _getRoleGradient(userRole),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: ResponsiveHelper.getPadding(context, 'large'),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'large'),
              ),
            ),
            child: Icon(
              _getRoleIcon(userRole),
              size: ResponsiveHelper.getIconSize(context, 'large'),
              color: Colors.white,
            ),
          ).animate().scale(delay: 300.ms),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

          // User Info
          Text(
            userName,
            style: AppTextStyles.heading5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),

          Text(
            userRole.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

          Text(
            userEmail,
            style: AppTextStyles.body3.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Obx(
              () => _buildNavigationItem(
                context,
                item,
                index,
                currentIndex.value == index,
              ),
            )
            .animate(delay: Duration(milliseconds: 50))
            .fadeIn()
            .slideX(begin: -0.3);
      },
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    bool isActive,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'small'),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: ResponsiveHelper.getPadding(context, 'medium'),
            decoration: BoxDecoration(
              gradient: isActive ? _getRoleGradient(userRole) : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'medium'),
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _getRoleColor(userRole).withOpacity(0.3),
                        blurRadius: ResponsiveHelper.getValue(
                          context,
                          mobile: 12.0,
                          tablet: 14.0,
                          desktop: 16.0,
                        ),
                        offset: Offset(
                          0,
                          ResponsiveHelper.getSpacing(context, 'xs'),
                        ),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: ResponsiveHelper.getPadding(context, 'small'),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : _getRoleColor(userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, 'small'),
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    size: ResponsiveHelper.getIconSize(context, 'small'),
                    color: isActive ? Colors.white : _getRoleColor(userRole),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.navMenuItem.copyWith(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                      // fontSize: 16.0,
                    ),
                  ),
                ),

                if (item.badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                      vertical: ResponsiveHelper.getSpacing(context, 'xs'),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(context, 'small'),
                      ),
                    ),
                    child: Text(
                      item.badge!.toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          'caption',
                        ),
                      ),
                    ),
                  ),

                if (isActive)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveHelper.getIconSize(context, 'xsmall'),
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'medium'),
      child: Column(
        children: [
          // Logout Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _handleLogout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getSpacing(context, 'small'),
                  horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'medium'),
                  ),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.rightFromBracket,
                      size: ResponsiveHelper.getIconSize(context, 'small'),
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getSpacing(context, 'small'),
                    ),
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

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

          // Version Info
          Text(
            'Hostel Mess Management v1.0.0',
            style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3);
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
              Get.offAllNamed('/login');
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
