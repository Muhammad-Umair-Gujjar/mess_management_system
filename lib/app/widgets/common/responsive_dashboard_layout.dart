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
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final showSideNav = isDesktop; // Only show sidebar on desktop

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: (!isDesktop)
          ? _buildResponsiveDrawer()
          : null, // Only provide drawer for mobile/tablet
      appBar: (!isDesktop)
          ? _buildResponsiveAppBar()
          : null, // Only show AppBar for mobile/tablet
      body: Container(
        decoration: AppDecorations.backgroundGradient(),
        child: Row(
          children: [
            // Desktop Side Navigation
            if (showSideNav)
              SizedBox(
                width: 320.w,
                child: _buildDesktopSidebar(),
              ).animate().slideX(begin: -1.0, duration: 600.ms),

            // Main Content Area
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
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
                      child: AnimatedScale(
                        scale: ResponsiveHelper.isMobile(context) ? 1.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: double.infinity,
                          child: widget.child,
                        ),
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

  AppBar _buildResponsiveAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: _getRoleColor(widget.userRole),
              size: 24.sp,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      // Keep header minimal - only menu icon, no other actions
    );
  }

  Widget _buildDesktopSidebar() {
    return DashboardNavigation(
      userRole: widget.userRole,
      userName: widget.userName,
      userEmail: widget.userEmail,
      currentIndex: widget.currentIndex,
      onItemSelected: widget.onItemSelected,
      menuItems: widget.menuItems,
    );
  }

  Widget _buildResponsiveDrawer() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final drawerWidth = isMobile
        ? 330
              .w // Increased width for phones for better visibility
        : 360.w; // Larger on tablet for better readability

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isMobile(context)
                        ? 16.w
                        : 20.w,
                    vertical: ResponsiveHelper.isMobile(context) ? 8.h : 12.h,
                  ),
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
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        isMobile ? 28.r : 24.r,
      ), // Larger padding on mobile
      margin: EdgeInsets.all(isMobile ? 18.r : 16.r), // Larger margin on mobile
      decoration: AppDecorations.gradientContainer(
        gradient: _getRoleGradient(widget.userRole),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: isMobile ? 36.r : 32.r, // Larger avatar on mobile
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              widget.userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: isMobile ? 28.sp : 24.sp, // Larger text on mobile
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20.h : 16.h), // More spacing on mobile
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: isMobile ? 20.sp : 18.sp, // Larger text on mobile
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 6.h : 4.h), // More spacing on mobile
          Text(
            widget.userRole.toUpperCase(),
            style: TextStyle(
              fontSize: isMobile ? 14.sp : 12.sp, // Larger text on mobile
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isMobile ? 10.h : 8.h), // More spacing on mobile
          Text(
            widget.userEmail,
            style: TextStyle(
              fontSize: isMobile ? 14.sp : 12.sp, // Larger email text on mobile
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: isMobile ? 12.h : 12.h,
      ), // Consistent spacing
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
            padding: EdgeInsets.all(
              isMobile ? 20.r : 18.r,
            ), // Larger padding on mobile
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
                  padding: EdgeInsets.all(
                    isMobile ? 10.r : 8.r,
                  ), // Larger padding on mobile
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : _getRoleColor(widget.userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    item.icon,
                    size: isMobile ? 24.sp : 22.sp, // Larger icons on mobile
                    color: isActive
                        ? Colors.white
                        : _getRoleColor(widget.userRole),
                  ),
                ),
                SizedBox(
                  width: isMobile ? 20.w : 18.w,
                ), // More spacing on mobile
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: isMobile
                          ? 18.sp
                          : 17.sp, // Larger text on mobile
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        isMobile ? 20.r : 16.r,
      ), // Larger padding on mobile
      child: Column(
        children: [
          Divider(color: AppColors.textLight.withOpacity(0.2)),
          SizedBox(height: isMobile ? 20.h : 16.h), // More spacing on mobile
          // Quick Action Buttons
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

          SizedBox(height: 20.h),

          // Logout Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                if (widget.onLogoutPressed != null) {
                  widget.onLogoutPressed!();
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 16.h : 12.h, // Larger padding on mobile
                  horizontal: isMobile ? 20.w : 16.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      size: isMobile ? 20.sp : 16.sp, // Larger icon on mobile
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: isMobile ? 10.w : 8.w,
                    ), // More spacing on mobile
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: isMobile
                            ? 16.sp
                            : 14.sp, // Larger text on mobile
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            isMobile ? 14.r : 12.r,
          ), // Larger padding on mobile
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: isMobile ? 22.sp : 20.sp, // Larger icons on mobile
            color: color,
          ),
        ),
        SizedBox(height: isMobile ? 8.h : 6.h), // More spacing on mobile
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12.sp : 10.sp, // Larger text on mobile
            color: AppColors.textLight,
          ),
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
