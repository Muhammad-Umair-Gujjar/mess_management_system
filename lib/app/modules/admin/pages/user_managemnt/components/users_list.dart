import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../admin_controller.dart';
import 'user_card.dart';
import 'user_empty_state.dart';

class UsersList extends StatelessWidget {
  final AdminController controller;
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
      final filteredUsers = controller.filterUsers(
        searchQuery,
        selectedRole,
        selectedStatus,
      );

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(filteredUsers, isMobile),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            Expanded(
              child: filteredUsers.isEmpty
                  ? const UserEmptyState()
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return UserCard(
                          user: user,
                          index: index,
                          onActionSelected: onUserAction,
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(List<Map<String, dynamic>> filteredUsers, bool isMobile) {
    return Row(
      children: [
        Text('Users (${filteredUsers.length})', style: AppTextStyles.heading5),
        const Spacer(),
        if (!isMobile) ...[
          Text(
            'Showing ${filteredUsers.length} of ${controller.users.length} users',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}
