import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../controllers/user_management_controller.dart';
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

  late UserManagementController _userController;

  @override
  void initState() {
    super.initState();

    // Initialize UserManagementController
    try {
      _userController = Get.find<UserManagementController>();
    } catch (e) {
      _userController = Get.put(UserManagementController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.backgroundGradient(),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filters and Actions
            UserFilters(
              searchQuery: _searchQuery,
              selectedRole: _selectedRole,
              selectedStatus: _selectedStatus,
              onSearchChanged: (value) {
                setState(() => _searchQuery = value);
                _userController.updateSearchQuery(value);
              },
              onRoleChanged: (value) {
                setState(() => _selectedRole = value);
                _userController.updateRoleFilter(value);
              },
              onStatusChanged: (value) {
                setState(() => _selectedStatus = value);
                _userController.updateStatusFilter(value);
              },
              onAddUser: () => AddUserDialog.show(),
            ),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Users List
            Expanded(
              child: UsersList(
                controller: _userController,
                searchQuery: _searchQuery,
                selectedRole: _selectedRole,
                selectedStatus: _selectedStatus,
                onUserAction: _handleUserAction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        // Show user details dialog
        _showUserDetailsDialog(user);
        break;
      case 'edit':
        // Show edit user dialog
        _showEditUserDialog(user);
        break;
      case 'suspend':
        _userController.suspendUser(user['id']);
        break;
      case 'activate':
        _userController.activateUser(user['id']);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(user);
        break;
    }
  }

  void _showUserDetailsDialog(Map<String, dynamic> user) {
    // TODO: Implement user details dialog
    Get.snackbar(
      'User Details',
      'Viewing details for ${user['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    // TODO: Implement edit user dialog
    Get.snackbar(
      'Edit User',
      'Editing user ${user['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete user ${user['name']}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _userController.deleteUser(user['id']);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
