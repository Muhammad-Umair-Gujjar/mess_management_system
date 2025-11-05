import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../common/reusable_text_field.dart';

class ResponsiveTopNavbar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final String? userRole;
  final String? userName;
  final String? userAvatar;
  final List<NavMenuItem>? menuItems;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onLogoutPressed;
  final bool showSearch;
  final Function(String)? onSearchChanged;

  const ResponsiveTopNavbar({
    super.key,
    required this.title,
    this.userRole,
    this.userName,
    this.userAvatar,
    this.menuItems,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onLogoutPressed,
    this.showSearch = true,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => Size.fromHeight(80.h);

  @override
  State<ResponsiveTopNavbar> createState() => _ResponsiveTopNavbarState();
}

class _ResponsiveTopNavbarState extends State<ResponsiveTopNavbar>
    with TickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchAnimation;
  bool _isSearchExpanded = false;
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: widget.preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardBackground.withOpacity(0.95),
            AppColors.cardBackground.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1.w,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.w : 32.w,
            vertical: 12.h,
          ),
          child: Row(
            children: [
              // Menu/Logo Section
              _buildLeadingSection(isMobile, isTablet),

              SizedBox(width: 16.w),

              // Title Section
              if (!isMobile) _buildTitleSection(),

              const Spacer(),

              // Search Section
              if (widget.showSearch) _buildSearchSection(isMobile),

              SizedBox(width: 16.w),

              // Actions Section
              _buildActionsSection(isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingSection(bool isMobile, bool isTablet) {
    return Row(
      children: [
        if (isMobile || isTablet) ...[
          IconButton(
            onPressed: widget.onMenuPressed,
            icon: Icon(
              FontAwesomeIcons.bars,
              size: 24.sp,
              color: AppColors.textPrimary,
            ),
            tooltip: 'Menu',
          ),
          SizedBox(width: 8.w),
        ],
        // Logo
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            FontAwesomeIcons.graduationCap,
            size: isMobile ? 20.sp : 24.sp,
            color: Colors.white,
          ),
        ),
        if (!isMobile) ...[
          SizedBox(width: 12.w),
          Text(
            'MessMaster',
            style: AppTextStyles.heading5.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.heading5.copyWith(
            fontSize: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
        if (widget.userRole != null)
          Text(
            '${widget.userRole} Dashboard',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textLight,
              fontSize: 12.sp,
            ),
          ),
      ],
    );
  }

  Widget _buildSearchSection(bool isMobile) {
    if (isMobile) {
      return AnimatedBuilder(
        animation: _searchAnimation,
        builder: (context, child) {
          return Row(
            children: [
              if (_isSearchExpanded)
                Container(
                  width: 200.w * _searchAnimation.value,
                  child: ReusableTextField(
                    controller: _searchTextController,
                    type: TextFieldType.search,
                    hintText: 'Search...',
                    onChanged: widget.onSearchChanged,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearchExpanded = !_isSearchExpanded;
                    if (_isSearchExpanded) {
                      _searchController.forward();
                    } else {
                      _searchController.reverse();
                      _searchTextController.clear();
                    }
                  });
                },
                icon: Icon(
                  _isSearchExpanded
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.magnifyingGlass,
                  size: 20.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          );
        },
      );
    }

    // Desktop search
    return Container(
      width: 300.w,
      child: ReusableTextField(
        controller: _searchTextController,
        type: TextFieldType.search,
        hintText: 'Search students, menus, reports...',
        onChanged: widget.onSearchChanged,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildActionsSection(bool isMobile, bool isTablet) {
    return Row(
      children: [
        // Notifications
        _buildActionButton(
          icon: FontAwesomeIcons.bell,
          onPressed: widget.onNotificationPressed,
          badgeCount: 3,
        ),

        SizedBox(width: 12.w),

        // User Profile
        if (!isMobile) _buildUserProfile(),

        if (isMobile || isTablet) ...[
          SizedBox(width: 12.w),
          _buildActionButton(
            icon: FontAwesomeIcons.rightFromBracket,
            onPressed: widget.onLogoutPressed,
            color: AppColors.error,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onPressed,
    int? badgeCount,
    Color? color,
  }) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.textLight.withOpacity(0.2),
              width: 1.w,
            ),
          ),
          child: Icon(icon, size: 20.sp, color: color ?? AppColors.textPrimary),
        ).animate().scale(delay: 200.ms),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10.r),
              ),
              constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
              child: Text(
                badgeCount > 9 ? '9+' : badgeCount.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().scale(delay: 400.ms),
          ),
      ],
    );
  }

  Widget _buildUserProfile() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showUserMenu(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: _getUserRoleGradient(),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  (widget.userName?.substring(0, 1).toUpperCase()) ?? 'U',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userName ?? 'User',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    widget.userRole ?? 'User',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Icon(
                FontAwesomeIcons.chevronDown,
                size: 12.sp,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3);
  }

  LinearGradient _getUserRoleGradient() {
    switch (widget.userRole?.toLowerCase()) {
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

  void _showUserMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(FontAwesomeIcons.user, size: 16.sp),
              SizedBox(width: 12.w),
              Text('Profile', style: AppTextStyles.body2),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(FontAwesomeIcons.gear, size: 16.sp),
              SizedBox(width: 12.w),
              Text('Settings', style: AppTextStyles.body2),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.rightFromBracket,
                size: 16.sp,
                color: AppColors.error,
              ),
              SizedBox(width: 12.w),
              Text(
                'Logout',
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ).then((value) {
      if (value == 'logout') {
        widget.onLogoutPressed?.call();
      }
    });
  }
}

class NavMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  const NavMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
  });
}
