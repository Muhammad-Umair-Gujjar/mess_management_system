import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/constants/app_colors.dart';

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
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isActive
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // User Avatar
                  _buildUserAvatar(role),
                  SizedBox(width: 16.w),

                  // User Info
                  _buildUserInfo(role),

                  // Status and Actions
                  _buildStatusAndActions(isActive),

                  SizedBox(width: 16.w),

                  // Action Menu
                  _buildActionMenu(isActive),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3);
  }

  Widget _buildUserAvatar(String role) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getRoleColor(role), _getRoleColor(role).withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(25.r),
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

  Widget _buildUserInfo(String role) {
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
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getRoleColor(role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildStatusAndActions(bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            user['status'],
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Last: ${user['lastLogin']}',
          style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildActionMenu(bool isActive) {
    return PopupMenuButton<String>(
      icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 16.sp),
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
