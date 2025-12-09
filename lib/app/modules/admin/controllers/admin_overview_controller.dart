import 'package:get/get.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../../core/utils/toast_message.dart';

/// Controller for Admin Overview Page
/// Handles pending student requests, system stats, and approval/rejection actions
class AdminOverviewController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = Get.find<UserService>();

  // Observable variables
  final isLoading = false.obs;
  final isProcessingRequest = false.obs;
  final pendingStudentRequests = <StudentRequest>[].obs;
  final systemStats = <String, dynamic>{}.obs;
  final recentActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Initialize all data for admin overview
  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadPendingStudentRequests(),
        _loadSystemStats(),
        _loadRecentActivities(),
      ]);
    } catch (e) {
      ToastMessage.error('Failed to load admin data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load pending student requests from Firestore
  /// Updated to show real-time pending requests count
  Future<void> _loadPendingStudentRequests() async {
    try {
      // Setting up pending student requests listener...

      // Use simple method to avoid index issues
      _authService.getPendingStudentRequestsSimple().listen(
        (requests) {
          print(
            '🔵 DEBUG: AdminOverviewController received ${requests.length} pending requests',
          );
          pendingStudentRequests.value = requests;

          // Update system stats with pending count
          final currentCount = requests.length;
          systemStats['pendingApprovals'] = currentCount;
          print(
            '🔵 DEBUG: Updated systemStats pendingApprovals to: $currentCount',
          );
          // Current systemStats: $systemStats

          for (var request in requests) {
            print(
              '  - ${request.firstName} ${request.lastName} (${request.email}) - Status: ${request.status.name}',
            );
          }

          // Force update the observable
          systemStats.refresh();
        },
        onError: (error) {
          // Error in AdminOverviewController stream: $error
        },
      );
    } catch (e) {
      print('❌ DEBUG: Error setting up pending requests listener: $e');
      throw e;
    }
  }

  /// Load system statistics
  Future<void> _loadSystemStats() async {
    try {
      // Loading system stats...

      // Get all users from UserService
      final users = await _userService.getAllUsers();

      // Exclude admin users from total count to match user management display
      final nonAdminUsers = users
          .where((user) => user.role != UserRole.admin)
          .toList();
      final totalUsers = nonAdminUsers.length;
      final totalStudents = users
          .where((user) => user.role == UserRole.student)
          .length;
      final totalStaff = users
          .where((user) => user.role == UserRole.staff)
          .length;

      systemStats.addAll({
        'totalUsers': totalUsers,
        'totalStudents': totalStudents,
        'totalStaff': totalStaff,
        'pendingApprovals': pendingStudentRequests.length,
        'activeMenuItems': 45, // TODO: Get from menu service
        'monthlyRevenue':
            totalStudents * 2500, // Estimated: students * average monthly cost
        'systemUptime': 99, // TODO: Get from system monitoring
        'activeConnections': totalUsers, // Approximate active connections
      });

      // System stats loaded
    } catch (e) {
      print('❌ DEBUG: Error loading system stats: $e');
      // Set default values on error
      systemStats.addAll({
        'totalUsers': 0,
        'totalStudents': 0,
        'totalStaff': 0,
        'pendingApprovals': 0,
        'activeMenuItems': 0,
        'monthlyRevenue': 0,
        'systemUptime': 0,
        'activeConnections': 0,
      });
    }
  }

  /// Load recent activities (placeholder for now)
  Future<void> _loadRecentActivities() async {
    try {
      // Loading recent activities...

      // TODO: Implement real activity logging
      recentActivities.value = [
        {
          'id': '1',
          'action': 'Student Registration',
          'description': 'New student signup request received',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          'type': 'signup',
        },
        {
          'id': '2',
          'action': 'Menu Updated',
          'description': 'Dinner menu items updated',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'type': 'menu',
        },
        {
          'id': '3',
          'action': 'Staff Login',
          'description': 'Kitchen staff logged in',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'type': 'auth',
        },
      ];

      // Recent activities loaded
    } catch (e) {
      print('❌ DEBUG: Error loading recent activities: $e');
    }
  }

  /// Refresh all dashboard data manually
  Future<void> refreshDashboard() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadPendingStudentRequests(),
        _loadSystemStats(),
        _loadRecentActivities(),
      ]);
      ToastMessage.success('Dashboard refreshed with latest data');
      print('✅ DEBUG: Dashboard data refreshed successfully');
    } catch (e) {
      print('❌ DEBUG: Error refreshing dashboard: $e');
      ToastMessage.error('Failed to refresh dashboard: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve a student request
  Future<void> approveStudentRequest(StudentRequest request) async {
    // Approving student request for ${request.email}

    if (isProcessingRequest.value) {
      print('⚠️ DEBUG: Already processing a request, please wait');
      return;
    }

    isProcessingRequest.value = true;

    try {
      final success = await _authService.approveStudentRequest(
        request.requestId,
        'current_admin_id', // TODO: Get current admin ID
      );

      if (success) {
        ToastMessage.success(
          'Student ${request.firstName} ${request.lastName} has been approved',
        );

        // Refresh data to update the dashboard
        await _loadSystemStats();
      } else {
        print('❌ DEBUG: Failed to approve student request');
        ToastMessage.error('Failed to approve request');
      }
    } catch (e) {
      print('❌ DEBUG: Error approving student request: $e');
      ToastMessage.error('Failed to approve request: ${e.toString()}');
    } finally {
      isProcessingRequest.value = false;
    }
  }

  /// Reject a student request
  Future<void> rejectStudentRequest(
    StudentRequest request,
    String reason,
  ) async {
    print('🔵 DEBUG: Rejecting student request for ${request.email}');

    if (isProcessingRequest.value) {
      print('⚠️ DEBUG: Already processing a request, please wait');
      return;
    }

    isProcessingRequest.value = true;

    try {
      final success = await _authService.rejectStudentRequest(
        request.requestId,
        'current_admin_id', // TODO: Get current admin ID
        reason,
      );

      if (success) {
        print('✅ DEBUG: Student request rejected successfully');

        ToastMessage.warning(
          'Student ${request.firstName} ${request.lastName} request has been rejected',
        );

        // Refresh data
        await _loadSystemStats();
      } else {
        print('❌ DEBUG: Failed to reject student request');
        ToastMessage.error('Failed to reject request');
      }
    } catch (e) {
      print('❌ DEBUG: Error rejecting student request: $e');
      ToastMessage.error('Failed to reject request: ${e.toString()}');
    } finally {
      isProcessingRequest.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    print('🔵 DEBUG: Refreshing admin overview data...');
    await _initializeData();
  }

  /// Get formatted system stats for display
  Map<String, dynamic> getFormattedStats() {
    return {
      'Total Users': systemStats['totalUsers'] ?? 0,
      'Students': systemStats['totalStudents'] ?? 0,
      'Staff': systemStats['totalStaff'] ?? 0,
      'Pending Approvals': systemStats['pendingApprovals'] ?? 0,
      'Active Menu Items': systemStats['activeMenuItems'] ?? 0,
      'Monthly Revenue': '₹${systemStats['monthlyRevenue'] ?? 0}',
      'System Uptime': '${systemStats['systemUptime'] ?? 0}%',
      'Active Sessions': systemStats['activeConnections'] ?? 0,
    };
  }
}
