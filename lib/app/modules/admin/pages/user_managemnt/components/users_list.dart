import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../controllers/user_management_controller.dart';
import 'user_card.dart';
import 'user_empty_state.dart';

class UsersList extends StatelessWidget {
  final UserManagementController controller;
  final String searchQuery;
  final String selectedRole;
  final String selectedStatus;
  final Function(String, Map<String, dynamic>) onUserAction;

  const UsersList({
    Key? key,
    required this.controller,
    required this.searchQuery,
    required this.selectedRole,
    required this.selectedStatus,
    required this.onUserAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Obx(() {
      // Show loading state
      if (controller.isLoading.value) {
        return Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: AppDecorations.floatingCard(),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      final filteredUsers = controller.filteredUsers;

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(filteredUsers, isMobile, context),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshUsers,
                child: filteredUsers.isEmpty
                    ? const UserEmptyState()
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final userData = controller.getFormattedUserData(
                            filteredUsers[index],
                          );
                          return UserCard(
                            user: userData,
                            index: index,
                            onActionSelected: onUserAction,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(List filteredUsers, bool isMobile, BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Text(
            'Users (${filteredUsers.length})',
            style: AppTextStyles.heading5,
          ),
          const Spacer(),
          if (!isMobile) ...[
            _buildStatsChip(
              'Students: ${controller.userStats['activeStudents'] ?? 0}',
              AppColors.studentRole,
              context,
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            _buildStatsChip(
              'Staff: ${controller.userStats['activeStaff'] ?? 0}',
              AppColors.staffRole,
              context,
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              'Total: ${controller.userStats['totalUsers'] ?? 0} users',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsChip(String text, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'xs'),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'small'),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
