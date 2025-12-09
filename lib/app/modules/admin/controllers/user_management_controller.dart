import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/user_test_data_service.dart';
import '../../../data/models/auth_models.dart';
import '../../../../core/utils/toast_message.dart';

/// Controller for managing user data in the admin panel
class UserManagementController extends GetxController {
  static UserManagementController get instance =>
      Get.find<UserManagementController>();

  final UserService _userService = Get.find<UserService>();

  // Observables
  final RxList<AppUser> allUsers = <AppUser>[].obs;
  final RxList<AppUser> filteredUsers = <AppUser>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedRole = 'all'.obs;
  final RxString selectedStatus = 'all'.obs;
  final RxMap<String, int> userStats = <String, int>{}.obs;

  // Additional user data
  final RxMap<String, StudentData> studentDataMap = <String, StudentData>{}.obs;
  final RxMap<String, StaffDetails> staffDataMap = <String, StaffDetails>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // UserManagementController: Initializing...

    // Initialize user service if not already done
    _ensureServiceInitialized();

    // Load initial data
    loadUsers();

    // Set up reactive filters
    _setupReactiveFilters();

    // UserManagementController: Initialization complete
  }

  void _ensureServiceInitialized() {
    try {
      Get.find<UserService>();
      print('✅ UserService already initialized');
    } catch (e) {
      print('⚠️ UserService not found, initializing...');
      Get.put(UserService());
    }
  }

  void _setupReactiveFilters() {
    // React to changes in search and filter parameters
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedRole, (_) => _applyFilters());
    ever(selectedStatus, (_) => _applyFilters());

    print('🔄 Reactive filters setup complete');
  }

  /// Load all users from Firebase
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      // UserManagementController: Loading users from Firebase...

      final users = await _userService.getAllUsers();
      allUsers.value = users;

      // Load additional data for users
      await _loadAdditionalUserData(users);

      // Load user statistics
      await _loadUserStats();

      // Apply current filters
      _applyFilters();

      print(
        '✅ UserManagementController: Successfully loaded ${users.length} users',
      );
      ToastMessage.success('Users loaded successfully');
    } catch (e) {
      print('❌ UserManagementController: Error loading users: $e');
      ToastMessage.error('Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh users data
  Future<void> refreshUsers() async {
    try {
      isRefreshing.value = true;
      print('🔄 UserManagementController: Refreshing users...');

      await loadUsers();

      print('✅ UserManagementController: Users refreshed successfully');
    } catch (e) {
      print('❌ UserManagementController: Error refreshing users: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Load additional data for students and staff
  Future<void> _loadAdditionalUserData(List<AppUser> users) async {
    // Loading additional user data...

    for (final user in users) {
      if (user.role == UserRole.student) {
        final studentData = await _userService.getStudentData(user.uid);
        if (studentData != null) {
          studentDataMap[user.uid] = studentData;
        }
      } else if (user.role == UserRole.staff) {
        final staffData = await _userService.getStaffData(user.uid);
        if (staffData != null) {
          staffDataMap[user.uid] = staffData;
        }
      }
    }

    // Additional user data loaded
  }

  /// Load user statistics
  Future<void> _loadUserStats() async {
    try {
      final stats = await _userService.getUserStats();
      userStats.value = stats;
      // User stats loaded
    } catch (e) {
      print('❌ Error loading user stats: $e');
    }
  }

  /// Apply filters to user list
  void _applyFilters() {
    print(
      '🔍 Applying filters - Query: "${searchQuery.value}", Role: "${selectedRole.value}", Status: "${selectedStatus.value}"',
    );

    List<AppUser> filtered = allUsers.toList();

    // Apply search query filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email.toLowerCase();

        // Check additional fields based on role
        String additionalInfo = '';
        if (user.role == UserRole.student) {
          final studentData = studentDataMap[user.uid];
          additionalInfo = studentData?.rollNumber.toLowerCase() ?? '';
        } else if (user.role == UserRole.staff) {
          final staffData = staffDataMap[user.uid];
          additionalInfo =
              '${staffData?.employeeId ?? ''} ${staffData?.department ?? ''}'
                  .toLowerCase();
        }

        return fullName.contains(query) ||
            email.contains(query) ||
            additionalInfo.contains(query);
      }).toList();
    }

    // Apply role filter
    if (selectedRole.value != 'all') {
      final roleFilter = selectedRole.value.toLowerCase();
      filtered = filtered
          .where((user) => user.role.name.toLowerCase() == roleFilter)
          .toList();
    }

    // Apply status filter
    if (selectedStatus.value != 'all') {
      final statusFilter = selectedStatus.value.toLowerCase();
      filtered = filtered.where((user) {
        if (statusFilter == 'active') {
          return user.status == UserStatus.active;
        } else if (statusFilter == 'inactive' || statusFilter == 'suspended') {
          return user.status == UserStatus.suspended;
        } else if (statusFilter == 'pending') {
          return user.status == UserStatus.pending;
        }
        return true;
      }).toList();
    }

    filteredUsers.value = filtered;
    // Filter applied: ${filtered.length} users match criteria
  }

  /// Update search query
  void updateSearchQuery(String query) {
    print('🔍 Search query updated: "$query"');
    searchQuery.value = query;
  }

  /// Update role filter
  void updateRoleFilter(String role) {
    print('🏷️ Role filter updated: "$role"');
    selectedRole.value = role;
  }

  /// Update status filter
  void updateStatusFilter(String status) {
    print('📊 Status filter updated: "$status"');
    selectedStatus.value = status;
  }

  /// Suspend user
  Future<void> suspendUser(String userId) async {
    try {
      print('⚠️ Suspending user: $userId');

      final success = await _userService.updateUserStatus(
        userId,
        UserStatus.suspended,
      );

      if (success) {
        // Update local data
        final userIndex = allUsers.indexWhere((user) => user.uid == userId);
        if (userIndex != -1) {
          final updatedUser = allUsers[userIndex];
          allUsers[userIndex] = AppUser(
            uid: updatedUser.uid,
            email: updatedUser.email,
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
            role: updatedUser.role,
            status: UserStatus.suspended,
            profileImageUrl: updatedUser.profileImageUrl,
            createdAt: updatedUser.createdAt,
            lastLoginAt: updatedUser.lastLoginAt,
            isEmailVerified: updatedUser.isEmailVerified,
            createdBy: updatedUser.createdBy,
          );
        }

        _applyFilters();
        await _loadUserStats();
        ToastMessage.success('User suspended successfully');
      } else {
        ToastMessage.error('Failed to suspend user');
      }
    } catch (e) {
      print('❌ Error suspending user: $e');
      ToastMessage.error('Error suspending user: $e');
    }
  }

  /// Activate user
  Future<void> activateUser(String userId) async {
    try {
      print('✅ Activating user: $userId');

      final success = await _userService.updateUserStatus(
        userId,
        UserStatus.active,
      );

      if (success) {
        // Update local data
        final userIndex = allUsers.indexWhere((user) => user.uid == userId);
        if (userIndex != -1) {
          final updatedUser = allUsers[userIndex];
          allUsers[userIndex] = AppUser(
            uid: updatedUser.uid,
            email: updatedUser.email,
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
            role: updatedUser.role,
            status: UserStatus.active,
            profileImageUrl: updatedUser.profileImageUrl,
            createdAt: updatedUser.createdAt,
            lastLoginAt: updatedUser.lastLoginAt,
            isEmailVerified: updatedUser.isEmailVerified,
            createdBy: updatedUser.createdBy,
          );
        }

        _applyFilters();
        await _loadUserStats();
        ToastMessage.success('User activated successfully');
      } else {
        ToastMessage.error('Failed to activate user');
      }
    } catch (e) {
      print('❌ Error activating user: $e');
      ToastMessage.error('Error activating user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      print('🗑️ Deleting user: $userId');

      final success = await _userService.deleteUser(userId);

      if (success) {
        // Remove from local data
        allUsers.removeWhere((user) => user.uid == userId);
        studentDataMap.remove(userId);
        staffDataMap.remove(userId);

        _applyFilters();
        await _loadUserStats();
        Get.snackbar(
          'Success',
          'User deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete user',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error deleting user: $e');
      Get.snackbar(
        'Error',
        'Error deleting user: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Get user by ID
  AppUser? getUserById(String userId) {
    return allUsers.firstWhereOrNull((user) => user.uid == userId);
  }

  /// Get student data for a user
  StudentData? getStudentData(String userId) {
    return studentDataMap[userId];
  }

  /// Get staff data for a user
  StaffDetails? getStaffData(String userId) {
    return staffDataMap[userId];
  }

  /// Get formatted user data for display
  Map<String, dynamic> getFormattedUserData(AppUser user) {
    final Map<String, dynamic> userData = {
      'id': user.uid,
      'name': user.fullName,
      'email': user.email,
      'role': user.role.name.toUpperCase(),
      'status': user.isActive
          ? 'Active'
          : user.status == UserStatus.suspended
          ? 'Suspended'
          : user.status == UserStatus.pending
          ? 'Pending'
          : 'Inactive',
      'lastLogin': _formatLastLogin(user.lastLoginAt),
      'joinDate': _formatDate(user.createdAt),
    };

    // Add role-specific data
    if (user.role == UserRole.student) {
      final studentData = getStudentData(user.uid);
      if (studentData != null) {
        userData['rollNumber'] = studentData.rollNumber;
        userData['roomNumber'] =
            '${studentData.hostel}-${studentData.roomNumber}';
        userData['department'] = studentData.department;
        userData['semester'] = 'Semester ${studentData.semester}';
      }
    } else if (user.role == UserRole.staff) {
      final staffData = getStaffData(user.uid);
      if (staffData != null) {
        userData['employeeId'] = staffData.employeeId;
        userData['department'] = staffData.department;
        userData['position'] = staffData.position;
      }
    }

    return userData;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatLastLogin(DateTime? lastLogin) {
    if (lastLogin == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get available roles for filtering
  List<Map<String, String>> get availableRoles => [
    {'value': 'all', 'label': 'All Roles'},
    {'value': 'student', 'label': 'Student'},
    {'value': 'staff', 'label': 'Staff'},
  ];

  /// Get available statuses for filtering
  List<Map<String, String>> get availableStatuses => [
    {'value': 'all', 'label': 'All Status'},
    {'value': 'active', 'label': 'Active'},
    {'value': 'suspended', 'label': 'Suspended'},
    {'value': 'pending', 'label': 'Pending'},
  ];

  /// Legacy method to maintain compatibility with existing UI
  List<Map<String, dynamic>> filterUsers(
    String searchQuery,
    String selectedRole,
    String selectedStatus,
  ) {
    // Update filters
    this.searchQuery.value = searchQuery;
    this.selectedRole.value = selectedRole;
    this.selectedStatus.value = selectedStatus;

    // Return formatted filtered users
    return filteredUsers.map((user) => getFormattedUserData(user)).toList();
  }

  /// Create test data for development/testing purposes
  Future<void> createTestData() async {
    try {
      print('🧪 Creating test user data...');
      ToastMessage.info('Creating test data...');

      await UserTestDataService.createAllTestData();

      // Reload users after creating test data
      await loadUsers();

      ToastMessage.success(
        'Test data created successfully! Refresh the page to see users.',
      );
    } catch (e) {
      print('❌ Error creating test data: $e');
      ToastMessage.error('Failed to create test data: $e');
    }
  }

  /// Delete test data
  Future<void> deleteTestData() async {
    try {
      print('🧹 Deleting test user data...');
      ToastMessage.info('Deleting test data...');

      await UserTestDataService.deleteAllTestData();

      // Reload users after deleting test data
      await loadUsers();

      ToastMessage.success('Test data deleted successfully!');
    } catch (e) {
      print('❌ Error deleting test data: $e');
      ToastMessage.error('Failed to delete test data: $e');
    }
  }

  /// Debug method to print current state
  void debugPrintState() {
    print('=== USER MANAGEMENT CONTROLLER STATE ===');
    print('Total users loaded: ${allUsers.length}');
    print('Filtered users: ${filteredUsers.length}');
    print('Search query: "${searchQuery.value}"');
    print('Selected role: "${selectedRole.value}"');
    print('Selected status: "${selectedStatus.value}"');
    print('User stats: $userStats');
    print('Students with data: ${studentDataMap.length}');
    print('Staff with data: ${staffDataMap.length}');
    print('Is loading: ${isLoading.value}');

    if (allUsers.isNotEmpty) {
      print('\nSample users:');
      for (int i = 0; i < allUsers.length && i < 3; i++) {
        final user = allUsers[i];
        print(
          '- ${user.fullName} (${user.email}) - ${user.role.name} - ${user.status.name}',
        );
      }
    }
    print('==========================================');
  }

  @override
  void onClose() {
    print('🔴 UserManagementController: Disposing...');
    super.onClose();
  }
}
