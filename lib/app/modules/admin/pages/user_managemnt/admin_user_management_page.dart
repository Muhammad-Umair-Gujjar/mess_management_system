import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../admin_controller.dart';
import 'components/user_filters.dart';
import 'components/users_list.dart';
import 'components/add_user_dialog.dart';

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

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filters and Actions
          UserFilters(
            searchQuery: _searchQuery,
            selectedRole: _selectedRole,
            selectedStatus: _selectedStatus,
            onSearchChanged: (value) => setState(() => _searchQuery = value),
            onRoleChanged: (value) => setState(() => _selectedRole = value),
            onStatusChanged: (value) => setState(() => _selectedStatus = value),
            onAddUser: () => AddUserDialog.show(),
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

          // Users List
          Expanded(
            child: UsersList(
              controller: controller,
              searchQuery: _searchQuery,
              selectedRole: _selectedRole,
              selectedStatus: _selectedStatus,
              onUserAction: _handleUserAction,
            ),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    final controller = Get.find<AdminController>();

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
}
