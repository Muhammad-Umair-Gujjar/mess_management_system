import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../../widgets/dashboard_navigation.dart';
import '../../../core/utils/toast_message.dart';

class AdminController extends GetxController {
  // Current page index
  final RxInt currentPageIndex = 0.obs;

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

  // System stats
  final RxMap<String, int> systemStats = <String, int>{
    'totalUsers': 347,
    'totalStudents': 234,
    'totalStaff': 12,
    'pendingApprovals': 23,
    'activeMenuItems': 45,
    'monthlyRevenue': 245600,
    'systemUptime': 99,
    'activeConnections': 156,
  }.obs;

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

  // Get system overview stats
  Map<String, dynamic> getSystemOverview() {
    return {
      'totalUsers': systemStats['totalUsers'] ?? 0,
      'totalStudents': systemStats['totalStudents'] ?? 0,
      'totalStaff': systemStats['totalStaff'] ?? 0,
      'pendingApprovals': systemStats['pendingApprovals'] ?? 0,
      'monthlyRevenue': systemStats['monthlyRevenue'] ?? 0,
      'systemUptime': systemStats['systemUptime'] ?? 0,
      'recentActivity': [
        {'action': 'New user registered', 'time': '5 minutes ago'},
        {'action': 'Menu updated', 'time': '1 hour ago'},
        {'action': 'Rate changed', 'time': '2 hours ago'},
      ],
    };
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

  @override
  void onInit() {
    super.onInit();
    // Initialize any required data
  }

  @override
  void onClose() {
    super.onClose();
  }
}
