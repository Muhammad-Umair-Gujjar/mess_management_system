import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int index;
  final Function(String, Map<String, dynamic>) onActionSelected;

  const UserCard({
    Key? key,
    required this.user,
    required this.index,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = user['status'] == 'Active';
    final role = user['role'] as String;

    return Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            border: Border.all(
              color: isActive
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
            ),
          ),
          child: ResponsiveHelper.isMobile(context)
              ? _buildMobileLayout(context, role, isActive)
              : _buildDesktopLayout(context, role, isActive),
        )
         .animate(delay: Duration(milliseconds: 50)) 
        .fadeIn(duration:  300.ms )
        .slideX(begin: -0.3);
  }

  Widget _buildMobileLayout(BuildContext context, String role, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row with avatar, name and actions
        Row(
          children: [
            _buildUserAvatar(context, role),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: AppTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user['email'],
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildActionMenu(context, isActive),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        // Bottom row with role, status and room info
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                vertical: ResponsiveHelper.getSpacing(context, 'xs'),
              ),
              decoration: BoxDecoration(
                color: _getRoleColor(role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'small'),
                ),
              ),
              child: Text(
                role,
                style: AppTextStyles.caption.copyWith(
                  color: _getRoleColor(role),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                vertical: ResponsiveHelper.getSpacing(context, 'xs'),
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'small'),
                ),
              ),
              child: Text(
                user['status'],
                style: AppTextStyles.caption.copyWith(
                  color: isActive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (user['roomNumber'] != null) ...[
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Expanded(
                child: Text(
                  'Room: ${user['roomNumber']}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, String role, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // User Avatar
            _buildUserAvatar(context, role),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

            // User Info
            _buildUserInfo(context, role),

            // Status and Actions
            _buildStatusAndActions(context, isActive),

            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),

            // Action Menu
            _buildActionMenu(context, isActive),
          ],
        ),
      ],
    );
  }

  Widget _buildUserAvatar(BuildContext context, String role) {
    return Container(
      width: ResponsiveHelper.isMobile(context)
          ? ResponsiveHelper.getIconSize(context, 'medium')
          : ResponsiveHelper.getIconSize(context, 'large'),
      height: ResponsiveHelper.isMobile(context)
          ? ResponsiveHelper.getIconSize(context, 'medium')
          : ResponsiveHelper.getIconSize(context, 'large'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getRoleColor(role), _getRoleColor(role).withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'large'),
        ),
      ),
      child: Center(
        child: Text(
          user['name'].toString().substring(0, 1).toUpperCase(),
          style: AppTextStyles.heading5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, String role) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                user['name'],
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                  vertical: ResponsiveHelper.getSpacing(context, 'xs'),
                ),
                decoration: BoxDecoration(
                  color: _getRoleColor(role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'small'),
                  ),
                ),
                child: Text(
                  role,
                  style: AppTextStyles.caption.copyWith(
                    color: _getRoleColor(role),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            user['email'],
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          if (user['roomNumber'] != null) ...[
            Text(
              'Room: ${user['roomNumber']}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusAndActions(BuildContext context, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'small'),
            vertical: ResponsiveHelper.getSpacing(context, 'xs'),
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'small'),
            ),
          ),
          child: Text(
            user['status'],
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
        if (!ResponsiveHelper.isMobile(context))
          Text(
            'Last: ${user['lastLogin']}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context, bool isActive) {
    return PopupMenuButton<String>(
      icon: Icon(
        FontAwesomeIcons.ellipsisVertical,
        size: ResponsiveHelper.getIconSize(context, 'small'),
      ),
      onSelected: (value) => onActionSelected(value, user),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('View Details')),
        const PopupMenuItem(value: 'edit', child: Text('Edit User')),
        if (isActive)
          const PopupMenuItem(value: 'suspend', child: Text('Suspend'))
        else
          const PopupMenuItem(value: 'activate', child: Text('Activate')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return AppColors.adminRole;
      case 'Staff':
        return AppColors.staffRole;
      default:
        return AppColors.studentRole;
    }
  }
}




