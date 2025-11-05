import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/responsive_helper.dart';
import '../dashboard_navigation.dart';

class ResponsiveDashboardLayout extends StatefulWidget {
  final String title;
  final String userRole;
  final String userName;
  final String userEmail;
  final RxInt currentIndex;
  final Function(int) onItemSelected;
  final List<NavigationItem> menuItems;
  final Widget child;
  final Widget? header;
  final VoidCallback? onLogoutPressed;

  const ResponsiveDashboardLayout({
    super.key,
    required this.title,
    required this.userRole,
    required this.userName,
    required this.userEmail,
    required this.currentIndex,
    required this.onItemSelected,
    required this.menuItems,
    required this.child,
    this.header,
    this.onLogoutPressed,
  });

  @override
  State<ResponsiveDashboardLayout> createState() =>
      _ResponsiveDashboardLayoutState();
}

class _ResponsiveDashboardLayoutState extends State<ResponsiveDashboardLayout>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _drawerAnimationController;

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final showSideNav = !isMobile && !isTablet;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: (isMobile || isTablet) ? _buildResponsiveDrawer() : null,
      body: Container(
        decoration: AppDecorations.backgroundGradient(),
        child: Row(
          children: [
            // Desktop Side Navigation
            if (showSideNav)
              SizedBox(
                width: 320.w,
                child: DashboardNavigation(
                  userRole: widget.userRole,
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                  currentIndex: widget.currentIndex,
                  onItemSelected: widget.onItemSelected,
                  menuItems: widget.menuItems,
                ),
              ).animate().slideX(begin: -1.0, duration: 600.ms),

            // Main Content Area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(
                  ResponsiveHelper.isMobile(context) ? 16.r : 24.r,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Header Section
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: 24.h),
                    ],

                    // Main Page Content
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveDrawer() {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cardBackground,
              AppColors.cardBackground.withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            // Drawer Header
            _buildDrawerHeader(),

            // Navigation Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: widget.menuItems.length,
                itemBuilder: (context, index) {
                  final item = widget.menuItems[index];
                  return Obx(() {
                        final isSelected = widget.currentIndex.value == index;
                        return _buildDrawerMenuItem(item, index, isSelected);
                      })
                      .animate(delay: Duration(milliseconds: 100 * index))
                      .slideX(begin: -0.5)
                      .fadeIn();
                },
              ),
            ),

            // Drawer Footer
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.all(16.r),
      decoration: AppDecorations.gradientContainer(
        gradient: _getRoleGradient(widget.userRole),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              widget.userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.userRole.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.userEmail,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildDrawerMenuItem(NavigationItem item, int index, bool isActive) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            widget.onItemSelected(index);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: isActive ? _getRoleGradient(widget.userRole) : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _getRoleColor(widget.userRole).withOpacity(0.3),
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
                        : _getRoleColor(widget.userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20.sp,
                    color: isActive
                        ? Colors.white
                        : _getRoleColor(widget.userRole),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Colors.white : AppColors.textPrimary,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
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

  Widget _buildDrawerFooter() {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Divider(color: AppColors.textLight.withOpacity(0.2)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                Icons.qr_code_scanner,
                'QR Scan',
                AppColors.primary,
              ),
              _buildQuickActionButton(
                Icons.notifications_outlined,
                'Alerts',
                AppColors.warning,
              ),
              _buildQuickActionButton(
                Icons.headset_mic_outlined,
                'Support',
                AppColors.info,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'MessMaster v1.0.0',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.textLight),
        ),
      ],
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
}
