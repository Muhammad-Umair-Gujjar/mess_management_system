import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  Size get preferredSize => const Size.fromHeight(80);

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
            blurRadius: 15.0,
            offset: Offset(0, 2.0),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          child: Row(
            children: [
              // Menu/Logo Section
              _buildLeadingSection(isMobile, isTablet),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

              // Title Section
              if (!isMobile) _buildTitleSection(),

              const Spacer(),

              // Search Section
              if (widget.showSearch) _buildSearchSection(isMobile),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

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
              size: ResponsiveHelper.getIconSize(context, 'medium'),
              color: AppColors.textPrimary,
            ),
            tooltip: 'Menu',
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        ],
        // Logo
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
          ),
          child: Icon(
            FontAwesomeIcons.graduationCap,
            size: ResponsiveHelper.getIconSize(
              context,
              isMobile ? 'small' : 'medium',
            ),
            color: Colors.white,
          ),
        ),
        if (!isMobile) ...[
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
          Text(
            'Hostel Mess Management',
            style: AppTextStyles.heading5.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
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
            fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
            color: AppColors.textPrimary,
          ),
        ),
        if (widget.userRole != null)
          Text(
            '${widget.userRole} Dashboard',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textLight,
              fontSize: ResponsiveHelper.getFontSize(context, 'caption'),
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
                  width:
                      ResponsiveHelper.getContainerWidth(
                        context,
                        mobileRatio: 0.5,
                      ) *
                      _searchAnimation.value,
                  child: ReusableTextField(
                    controller: _searchTextController,
                    type: TextFieldType.search,
                    hintText: 'Search...',
                    onChanged: widget.onSearchChanged,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSpacing(
                        context,
                        'medium',
                      ),
                      vertical: ResponsiveHelper.getSpacing(context, 'small'),
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
                  size: ResponsiveHelper.getIconSize(context, 'small'),
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
      width: ResponsiveHelper.getContainerWidth(
        context,
        tabletRatio: 0.4,
        desktopRatio: 0.3,
      ),
      child: ReusableTextField(
        controller: _searchTextController,
        type: TextFieldType.search,
        hintText: 'Search students, menus, reports...',
        onChanged: widget.onSearchChanged,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
          vertical: ResponsiveHelper.getSpacing(context, 'medium'),
        ),
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

        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

        // User Profile
        if (!isMobile) _buildUserProfile(),

        if (isMobile || isTablet) ...[
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
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
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            border: Border.all(
              color: AppColors.textLight.withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            size: ResponsiveHelper.getIconSize(context, 'small'),
            color: color ?? AppColors.textPrimary,
          ),
        ).animate().scale(delay: 300.ms),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'small'),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: ResponsiveHelper.getComponentDimension(
                  context,
                  'badgeSize',
                ),
                minHeight: ResponsiveHelper.getComponentDimension(
                  context,
                  'badgeSize',
                ),
              ),
              child: Text(
                badgeCount > 9 ? '9+' : badgeCount.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.getFontSize(context, 'caption'),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().scale(delay: 300.ms),
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
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
            vertical: ResponsiveHelper.getSpacing(context, 'small'),
          ),
          decoration: BoxDecoration(
            gradient: _getUserRoleGradient(),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: ResponsiveHelper.getValue(
                  context,
                  mobile: 6.0,
                  tablet: 8.0,
                  desktop: 8.0,
                ),
                offset: Offset(
                  0,
                  ResponsiveHelper.getValue(
                    context,
                    mobile: 2.0,
                    tablet: 2.0,
                    desktop: 2.0,
                  ),
                ),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.getIconSize(context, 'medium') * 0.75,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  (widget.userName?.substring(0, 1).toUpperCase()) ?? 'U',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userName ?? 'User',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                    ),
                  ),
                  Text(
                    widget.userRole ?? 'User',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        'caption',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Icon(
                FontAwesomeIcons.chevronDown,
                size: ResponsiveHelper.getIconSize(context, 'small'),
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
              Icon(
                FontAwesomeIcons.user,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              Text('Profile', style: AppTextStyles.body2),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.gear,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
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
                size: ResponsiveHelper.getIconSize(context, 'medium'),
                color: AppColors.error,
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              Text(
                'Logout',
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'medium'),
        ),
      ),
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
