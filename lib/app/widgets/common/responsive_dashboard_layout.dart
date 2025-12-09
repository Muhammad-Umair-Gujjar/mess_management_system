import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          ? SafeArea(child: _buildResponsiveDrawer())
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
                width: ResponsiveHelper.getValue<double>(
                  context,
                  mobile: 320,
                  tablet: 250,
                  desktop: 250,
                ),
                child: _buildDesktopSidebar(),
              ).animate().slideX(begin: -1.0, duration: 300.ms),

            // Main Content Area
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: ResponsiveHelper.getMargin(context, 'contentMargin'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Header Section
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(context, 'large'),
                      ),
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
          margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.8),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'button'),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: ResponsiveHelper.getSpacing(context, 'small'),
                offset: Offset(0, ResponsiveHelper.getSpacing(context, 'xs')),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: _getRoleColor(widget.userRole),
              size: ResponsiveHelper.getIconSize(context, 'menuIcon'),
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
    // Calculate responsive drawer width with better mobile optimization
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = ResponsiveHelper.getValue<double>(
      context,
      mobile: (screenWidth * 0.55).clamp(
        240.0,
        300.0,
      ), // 75% of screen width, but max 300px, min 240px
      tablet: (screenWidth * 0.40).clamp(
        280.0,
        350.0,
      ), // 40% of screen width, but max 350px, min 280px
      desktop: 320.0, // Fixed width for desktop - slightly larger for comfort
    );

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              ResponsiveHelper.getBorderRadius(context, 'large'),
            ),
            bottomRight: Radius.circular(
              ResponsiveHelper.getBorderRadius(context, 'large'),
            ),
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
                    horizontal: ResponsiveHelper.getSpacing(
                      context,
                      'contentMargin',
                    ),
                    vertical: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  itemCount: widget.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.menuItems[index];
                    return Obx(() {
                          final isSelected = widget.currentIndex.value == index;
                          return _buildDrawerMenuItem(item, index, isSelected);
                        })
                        .animate(delay: Duration(milliseconds: 50))
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
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      margin: ResponsiveHelper.getMargin(context, 'sectionMargin'),
      decoration: AppDecorations.gradientContainer(
        gradient: _getRoleGradient(widget.userRole),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius:
                ResponsiveHelper.getComponentDimension(context, 'avatarLarge') /
                2,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              widget.userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue<double>(
              context,
              mobile: 20,
              tablet: 16,
              desktop: 16,
            ),
          ), // More spacing on mobile
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
          Text(
            widget.userRole.toUpperCase(),
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'label'),
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            widget.userEmail,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'body3'),
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildDrawerMenuItem(NavigationItem item, int index, bool isActive) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'small'),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context, 'small'),
          ),
          onTap: () {
            widget.onItemSelected(index);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
            decoration: BoxDecoration(
              gradient: isActive ? _getRoleGradient(widget.userRole) : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'medium'),
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _getRoleColor(widget.userRole).withOpacity(0.3),
                        blurRadius: ResponsiveHelper.getSpacing(
                          context,
                          'small',
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
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getSpacing(context, 'xs'),
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : _getRoleColor(widget.userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, 'small'),
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    size: ResponsiveHelper.getIconSize(context, 'cardIcon'),
                    color: isActive
                        ? Colors.white
                        : _getRoleColor(widget.userRole),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        'menuItem',
                      ),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Colors.white : AppColors.textPrimary,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          'body3',
                        ),
                        fontWeight: FontWeight.w600,
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

  Widget _buildDrawerFooter() {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      child: Column(
        children: [
          Divider(color: AppColors.textLight.withOpacity(0.2)),
          SizedBox(
            height: ResponsiveHelper.getValue<double>(
              context,
              mobile: 20,
              tablet: 16,
              desktop: 16,
            ),
          ), // More spacing on mobile
          // Quick Action Button
          // Logout Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'small'),
              ),
              onTap: () {
                if (widget.onLogoutPressed != null) {
                  widget.onLogoutPressed!();
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getSpacing(context, 'medium'),
                  horizontal: ResponsiveHelper.getSpacing(context, 'large'),
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'button'),
                  ),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      size: ResponsiveHelper.getIconSize(context, 'small'),
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getSpacing(context, 'small'),
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          'button',
                        ),
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

          Text(
            'Hostel Mess Management v1.0.0',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'body3'),
              color: AppColors.textLight,
            ),
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
}
