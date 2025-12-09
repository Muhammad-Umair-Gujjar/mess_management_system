import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../../widgets/dashboard_navigation.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/services/user_service.dart';
import '../../data/models/auth_models.dart';

class AdminController extends GetxController {
  // Current page index
  final RxInt currentPageIndex = 0.obs;

  // User service for real data
  final UserService _userService = Get.find<UserService>();

  // Real-time user stats
  final RxMap<String, int> realUserStats = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadRealUserStats();
  }

  /// Load real user statistics from UserService
  Future<void> loadRealUserStats() async {
    try {
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
      final pendingApprovals = users
          .where((user) => user.status == UserStatus.pending)
          .length;

      realUserStats.value = {
        'totalUsers': totalUsers,
        'totalStudents': totalStudents,
        'totalStaff': totalStaff,
        'pendingApprovals': pendingApprovals,
        'activeMenuItems':
            45, // Keep static for now until menu service integration
        'monthlyRevenue':
            totalStudents * 2500, // Estimated: students * average monthly cost
        'systemUptime': 99, // Keep static system metric
        'activeConnections': totalUsers, // Approximate active connections
      };
    } catch (e) {
      // Fall back to default values if error
      realUserStats.value = {
        'totalUsers': 0,
        'totalStudents': 0,
        'totalStaff': 0,
        'pendingApprovals': 0,
        'activeMenuItems': 45,
        'monthlyRevenue': 0,
        'systemUptime': 99,
        'activeConnections': 0,
      };
    }
  }

  // Navigation items for admin dashboard
  final List<NavigationItem> navigationItems = [
    const NavigationItem(
      icon: FontAwesomeIcons.chartPie,
      title: 'Dashboard',
      route: '/admin/dashboard',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.users,
      title: 'User Management',
      route: '/admin/users',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.utensils,
      title: 'Menu Management',
      route: '/admin/menu',
    ),
  ];

  // User management data
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'role': 'Student',
      'status': 'Active',
      'lastLogin': '2024-01-15 10:30 AM',
      'roomNumber': 'A-201',
      'joinDate': '2024-01-01',
      'avatar': null,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'role': 'Staff',
      'status': 'Active',
      'lastLogin': '2024-01-15 09:15 AM',
      'department': 'Mess Management',
      'joinDate': '2023-08-15',
      'avatar': null,
    },
    {
      'id': '3',
      'name': 'Mike Wilson',
      'email': 'mike.w@email.com',
      'role': 'Student',
      'status': 'Inactive',
      'lastLogin': '2024-01-10 02:45 PM',
      'roomNumber': 'B-105',
      'joinDate': '2023-12-01',
      'avatar': null,
    },
  ].obs;

  // Pending approvals
  final RxList<Map<String, dynamic>> pendingApprovals = <Map<String, dynamic>>[
    {
      'id': '1',
      'type': 'New Registration',
      'name': 'Alice Brown',
      'email': 'alice.brown@email.com',
      'role': 'Student',
      'roomNumber': 'C-301',
      'submittedDate': '2024-01-14',
      'documents': ['ID Card', 'Admission Letter'],
    },
    {
      'id': '2',
      'type': 'Rate Change Request',
      'name': 'Kitchen Staff',
      'description': 'Request to increase breakfast rate by Rs5',
      'currentRate': 40,
      'requestedRate': 45,
      'submittedDate': '2024-01-13',
      'reason': 'Increased ingredient costs',
    },
  ].obs;

  // Menu categories and items
  final RxList<Map<String, dynamic>> menuCategories = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Main Course',
      'itemCount': 15,
      'icon': FontAwesomeIcons.utensils,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Rice & Bread',
      'itemCount': 8,
      'icon': FontAwesomeIcons.bowlRice,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'Vegetables',
      'itemCount': 12,
      'icon': FontAwesomeIcons.carrot,
      'isActive': true,
    },
    {
      'id': '4',
      'name': 'Beverages',
      'itemCount': 6,
      'icon': FontAwesomeIcons.mugHot,
      'isActive': true,
    },
  ].obs;

  // Rate configuration
  final RxMap<String, double> currentRates = <String, double>{
    'breakfast': 40.0,
    'dinner': 80.0,
    'specialMeal': 120.0,
    'guestMeal': 150.0,
  }.obs;

  // Analytics data
  final RxMap<String, dynamic> analyticsData = <String, dynamic>{
    'dailyAttendance': [85, 92, 78, 95, 88, 90, 87],
    'weeklyRevenue': [12000, 15000, 13500, 16000, 14500, 17000, 15500],
    'monthlyStats': {
      'totalMeals': 15400,
      'averageAttendance': 89,
      'revenue': 245600,
      'expenses': 180000,
    },
    'popularMenuItems': [
      {'name': 'Chicken Biryani', 'orders': 1250},
      {'name': 'Dal Tadka', 'orders': 980},
      {'name': 'Mixed Vegetables', 'orders': 875},
    ],
  }.obs;

  // Notification settings
  final RxBool emailNotifications = true.obs;
  final RxBool pushNotifications = true.obs;
  final RxBool smsNotifications = false.obs;

  // Change current page
  void changePage(int index) {
    currentPageIndex.value = index;
  }

  // Get current page title
  String getCurrentPageTitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Admin Dashboard';
      case 1:
        return 'User Management';
      case 2:
        return 'Menu Management';
      default:
        return 'Admin Dashboard';
    }
  }

  // Get current page subtitle
  String getCurrentPageSubtitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'System overview and quick actions';
      case 1:
        return 'Manage users, staff, and permissions';
      case 2:
        return 'Configure menu items and categories';
      default:
        return 'System overview and quick actions';
    }
  }

  // Get system overview stats (reactive)
  Map<String, dynamic> get getSystemOverview {
    return {
      'totalUsers': realUserStats['totalUsers'] ?? 0,
      'totalStudents': realUserStats['totalStudents'] ?? 0,
      'totalStaff': realUserStats['totalStaff'] ?? 0,
      'pendingApprovals': realUserStats['pendingApprovals'] ?? 0,
      'monthlyRevenue': realUserStats['monthlyRevenue'] ?? 0,
      'systemUptime': realUserStats['systemUptime'] ?? 99,
      'recentActivity': [
        {'action': 'User statistics updated', 'time': '5 minutes ago'},
        {'action': 'System synchronized with Firebase', 'time': '1 hour ago'},
        {'action': 'Dashboard refreshed', 'time': '2 hours ago'},
      ],
    };
  }

  /// Refresh dashboard statistics
  Future<void> refreshDashboard() async {
    await loadRealUserStats();
    ToastMessage.success('Dashboard refreshed with latest data');
  }

  // User management functions
  void approveUser(String userId) {
    // Implementation for approving user
    ToastMessage.success('User approved successfully');
  }

  void rejectUser(String userId) {
    // Implementation for rejecting user
    ToastMessage.warning('User rejected');
  }

  void suspendUser(String userId) {
    final userIndex = users.indexWhere((user) => user['id'] == userId);
    if (userIndex != -1) {
      users[userIndex]['status'] = 'Suspended';
      ToastMessage.warning('User suspended');
    }
  }

  void activateUser(String userId) {
    final userIndex = users.indexWhere((user) => user['id'] == userId);
    if (userIndex != -1) {
      users[userIndex]['status'] = 'Active';
      ToastMessage.success('User activated');
    }
  }

  // Menu management functions
  void addMenuCategory(String name, IconData icon) {
    menuCategories.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'itemCount': 0,
      'icon': icon,
      'isActive': true,
    });
    ToastMessage.success('Category added successfully');
  }

  void updateMenuCategory(String categoryId, Map<String, dynamic> updates) {
    final categoryIndex = menuCategories.indexWhere(
      (cat) => cat['id'] == categoryId,
    );
    if (categoryIndex != -1) {
      menuCategories[categoryIndex] = {
        ...menuCategories[categoryIndex],
        ...updates,
      };
      ToastMessage.success('Category updated successfully');
    }
  }

  void deleteMenuCategory(String categoryId) {
    menuCategories.removeWhere((cat) => cat['id'] == categoryId);
    ToastMessage.success('Category deleted successfully');
  }

  // Rate configuration functions
  void updateRate(String mealType, double newRate) {
    currentRates[mealType] = newRate;
    ToastMessage.success('Rate updated successfully');
  }

  // Analytics functions
  Map<String, dynamic> getAnalyticsData() {
    return analyticsData;
  }

  // Notification functions
  void toggleEmailNotifications() {
    emailNotifications.value = !emailNotifications.value;
  }

  void togglePushNotifications() {
    pushNotifications.value = !pushNotifications.value;
  }

  void toggleSmsNotifications() {
    smsNotifications.value = !smsNotifications.value;
  }

  void sendBulkNotification(
    String title,
    String message,
    List<String> recipients,
  ) {
    // Implementation for sending bulk notifications
    ToastMessage.success('Notification sent to ${recipients.length} users');
  }

  // Filter functions
  List<Map<String, dynamic>> filterUsers(
    String query,
    String role,
    String status,
  ) {
    return users.where((user) {
      final matchesQuery =
          query.isEmpty ||
          user['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
          user['email'].toString().toLowerCase().contains(query.toLowerCase());

      final matchesRole = role.isEmpty || user['role'] == role;
      final matchesStatus = status.isEmpty || user['status'] == status;

      return matchesQuery && matchesRole && matchesStatus;
    }).toList();
  }
}
