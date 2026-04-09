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
  bool _isFormView = false;
  Map<String, dynamic>? _editingUser;

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
        child: _isFormView
            ? AddEditUserView(
                isEditMode: _editingUser != null,
                initialUser: _editingUser,
                onSubmit: _handleSaveUser,
                onBack: _closeFormView,
              )
            : Column(
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
                    onAddUser: _openAddUserView,
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
        _openEditUserView(user);
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
    final details = <MapEntry<String, dynamic>>[
      MapEntry('Name', user['name'] ?? 'N/A'),
      MapEntry('Email', user['email'] ?? 'N/A'),
      MapEntry('Role', user['role'] ?? 'N/A'),
      MapEntry('Status', user['status'] ?? 'N/A'),
      MapEntry('Joined', user['joinDate'] ?? 'N/A'),
      MapEntry('Last Login', user['lastLogin'] ?? 'Never'),
      if (user['rollNumber'] != null)
        MapEntry('Roll Number', user['rollNumber']),
      if (user['roomNumber'] != null)
        MapEntry('Room', user['roomNumber']),
      if (user['department'] != null)
        MapEntry('Department', user['department']),
      if (user['semester'] != null)
        MapEntry('Semester', user['semester']),
      if (user['employeeId'] != null)
        MapEntry('Employee ID', user['employeeId']),
      if (user['position'] != null)
        MapEntry('Position', user['position']),
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 420,
          height: 420,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'User Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: details
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      item.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const Text(': '),
                                  Expanded(
                                    child: Text(item.value?.toString() ?? 'N/A'),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    _openEditUserView(user);
  }

  void _openAddUserView() {
    setState(() {
      _editingUser = null;
      _isFormView = true;
    });
  }

  void _openEditUserView(Map<String, dynamic> user) {
    setState(() {
      _editingUser = user;
      _isFormView = true;
    });
  }

  void _closeFormView() {
    setState(() {
      _editingUser = null;
      _isFormView = false;
    });
  }

  Future<bool> _handleSaveUser(Map<String, dynamic> data) async {
    if (_editingUser == null) {
      final success = await _userController.addUser(
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        role: data['role'] ?? 'Student',
        rollNumber: data['rollNumber'] ?? '',
        hostel: data['hostel'] ?? '',
        roomNumber: data['roomNumber'] ?? '',
        department: data['department'] ?? '',
        semester: data['semester'] ?? 1,
        employeeId: data['employeeId'] ?? '',
        position: data['position'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
      );

      if (success) {
        _closeFormView();
      }
      return success;
    }

    final success = await _userController.updateUserDetails(
      uid: (_editingUser!['id'] ?? '').toString(),
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? 'Student',
      email: data['email'],
      rollNumber: data['rollNumber'] ?? '',
      hostel: data['hostel'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? 1,
      employeeId: data['employeeId'] ?? '',
      position: data['position'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );

    if (success) {
      _closeFormView();
    }
    return success;
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
