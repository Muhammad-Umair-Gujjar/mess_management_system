import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/reusable_button.dart';
import '../../../widgets/common/reusable_text_field.dart';
import '../admin_controller.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key});

  @override
  State<AdminUserManagementPage> createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  String _searchQuery = '';
  String _selectedRole = '';
  String _selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters and Actions
          _buildFiltersAndActions(isMobile),

          SizedBox(height: 24.h),

          // Users List
          Expanded(child: _buildUsersList(controller, isMobile)),
        ],
      ),
    );
  }

  Widget _buildFiltersAndActions(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          if (isMobile) ...[
            // Mobile Layout
            ReusableTextField(
              hintText: 'Search users...',
              type: TextFieldType.search,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRole.isEmpty ? null : _selectedRole,
                    items: ['Student', 'Staff', 'Admin'].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedRole = value ?? ''),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStatus.isEmpty ? null : _selectedStatus,
                    items: ['Active', 'Inactive', 'Suspended'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value ?? ''),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ReusableButton(
                    text: 'Add User',
                    icon: FontAwesomeIcons.userPlus,
                    type: ButtonType.primary,
                    size: ButtonSize.medium,
                    onPressed: _showAddUserDialog,
                  ),
                ),
                SizedBox(width: 12.w),
                ReusableButton(
                  text: 'Export',
                  icon: FontAwesomeIcons.download,
                  type: ButtonType.outline,
                  size: ButtonSize.medium,
                  onPressed: () {},
                ),
              ],
            ),
          ] else ...[
            // Desktop Layout
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ReusableTextField(
                    hintText: 'Search users by name or email...',
                    type: TextFieldType.search,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 150.w,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRole.isEmpty ? null : _selectedRole,
                    items: ['Student', 'Staff', 'Admin'].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedRole = value ?? ''),
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 150.w,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStatus.isEmpty ? null : _selectedStatus,
                    items: ['Active', 'Inactive', 'Suspended'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value ?? ''),
                  ),
                ),
                SizedBox(width: 16.w),
                ReusableButton(
                  text: 'Add User',
                  icon: FontAwesomeIcons.userPlus,
                  type: ButtonType.primary,
                  size: ButtonSize.medium,
                  onPressed: _showAddUserDialog,
                ),
                SizedBox(width: 12.w),
                ReusableButton(
                  text: 'Export',
                  icon: FontAwesomeIcons.download,
                  type: ButtonType.outline,
                  size: ButtonSize.medium,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildUsersList(AdminController controller, bool isMobile) {
    return Obx(() {
      final filteredUsers = controller.filterUsers(
        _searchQuery,
        _selectedRole,
        _selectedStatus,
      );

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Users (${filteredUsers.length})',
                  style: AppTextStyles.heading5,
                ),
                const Spacer(),
                if (!isMobile) ...[
                  Text(
                    'Showing ${filteredUsers.length} of ${controller.users.length} users',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: filteredUsers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _buildUserCard(user, index, controller);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.users,
            size: 64.sp,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            'No users found',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search criteria',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
    Map<String, dynamic> user,
    int index,
    AdminController controller,
  ) {
    final isActive = user['status'] == 'Active';
    final role = user['role'] as String;

    Color getRoleColor() {
      switch (role) {
        case 'Admin':
          return AppColors.adminRole;
        case 'Staff':
          return AppColors.staffRole;
        default:
          return AppColors.studentRole;
      }
    }

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
            children: [
              Row(
                children: [
                  // User Avatar
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          getRoleColor(),
                          getRoleColor().withOpacity(0.7),
                        ],
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
                  ),
                  SizedBox(width: 16.w),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: getRoleColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                role,
                                style: AppTextStyles.caption.copyWith(
                                  color: getRoleColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          user['email'],
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (user['roomNumber'] != null) ...[
                          Text(
                            'Room: ${user['roomNumber']}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Status and Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          user['status'],
                          style: AppTextStyles.caption.copyWith(
                            color: isActive
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Last: ${user['lastLogin']}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 16.w),

                  // Action Menu
                  PopupMenuButton<String>(
                    icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 16.sp),
                    onSelected: (value) =>
                        _handleUserAction(value, user, controller),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit User'),
                      ),
                      if (isActive)
                        const PopupMenuItem(
                          value: 'suspend',
                          child: Text('Suspend'),
                        )
                      else
                        const PopupMenuItem(
                          value: 'activate',
                          child: Text('Activate'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3);
  }

  void _handleUserAction(
    String action,
    Map<String, dynamic> user,
    AdminController controller,
  ) {
    switch (action) {
      case 'view':
        // Show user details dialog
        break;
      case 'edit':
        // Show edit user dialog
        break;
      case 'suspend':
        controller.suspendUser(user['id']);
        break;
      case 'activate':
        controller.activateUser(user['id']);
        break;
      case 'delete':
        // Show confirmation dialog
        break;
    }
  }

  void _showAddUserDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add New User'),
        content: Container(
          width: 400.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableTextField(
                label: 'Full Name',
                hintText: 'Enter full name',
              ),
              SizedBox(height: 16.h),
              ReusableTextField(
                label: 'Email',
                type: TextFieldType.email,
                hintText: 'Enter email address',
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: ['Student', 'Staff'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16.h),
              ReusableTextField(
                label: 'Room Number (for students)',
                hintText: 'e.g., A-201',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Add User',
            type: ButtonType.primary,
            size: ButtonSize.small,
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'User added successfully');
            },
          ),
        ],
      ),
    );
  }
}
