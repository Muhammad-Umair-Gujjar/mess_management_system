import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/student.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/models/attendance.dart';
import '../../data/models/menu.dart';
import '../../data/services/dummy_data_service.dart';
import '../../widgets/dashboard_navigation.dart';

class StaffController extends GetxController {
  // Observable properties
  var isLoading = false.obs;
  var currentPageIndex = 0.obs;
  var allStudents = <dynamic>[].obs;
  var filteredStudents = <dynamic>[].obs;
  var attendanceList = <Attendance>[].obs;
  var menuItems = <MenuItem>[].obs;
  var mealRates = <MealRate>[].obs;
  var selectedDate = DateTime.now().obs;
  var selectedMealType = MealType.breakfast.obs;
  var searchQuery = ''.obs;
  var statusFilter = 'All'.obs;

  // Staff navigation items
  final List<NavigationItem> navigationItems = [
    const NavigationItem(
      icon: FontAwesomeIcons.house,
      title: 'Dashboard',
      route: '/staff/dashboard',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.calendarCheck,
      title: 'Attendance',
      route: '/staff/attendance',
      badge: 5,
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.users,
      title: 'Students',
      route: '/staff/students',
    ),
    // Commented out - can be enabled later
    // const NavigationItem(
    //   icon: FontAwesomeIcons.chartLine,
    //   title: 'Reports',
    //   route: '/staff/reports',
    // ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadStaffData();
  }

  void loadStaffData() {
    isLoading.value = true;

    // Load all students - using dummy data as maps
    allStudents.value = [
      {
        'id': 'S001',
        'name': 'Ali Ahmed',
        'room': 'B-101',
        'email': 'ali@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S002',
        'name': 'Sara Khan',
        'room': 'A-205',
        'email': 'sara@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S003',
        'name': 'Ahmed Hassan',
        'room': 'C-304',
        'email': 'ahmed@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S004',
        'name': 'Fatima Ali',
        'room': 'B-203',
        'email': 'fatima@university.edu',
        'isApproved': false,
      },
      {
        'id': 'S005',
        'name': 'Omar Abdullah',
        'room': 'A-156',
        'email': 'omar@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S006',
        'name': 'Maryam Saleh',
        'room': 'C-409',
        'email': 'maryam@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S007',
        'name': 'Hassan Mohammad',
        'room': 'B-302',
        'email': 'hassan@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S008',
        'name': 'Noor Fatima',
        'room': 'A-178',
        'email': 'noor@university.edu',
        'isApproved': false,
      },
      {
        'id': 'S009',
        'name': 'Yusuf Ibrahim',
        'room': 'C-255',
        'email': 'yusuf@university.edu',
        'isApproved': true,
      },
      {
        'id': 'S010',
        'name': 'Aisha Mahmood',
        'room': 'B-447',
        'email': 'aisha@university.edu',
        'isApproved': false,
      },
    ];
    filteredStudents.value = allStudents.toList();

    // Load attendance records
    attendanceList.value = DummyDataService.getAttendance();

    // Load menu items
    menuItems.value = DummyDataService.getWeeklyMenu();

    // Load meal rates
    mealRates.value = DummyDataService.getMealRates();

    isLoading.value = false;
  }

  // Navigation methods
  void changePage(int index) {
    currentPageIndex.value = index;
    update(['page_content']); // Trigger rebuild for the page content
  }

  // Search and filter methods
  void filterStudents(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByStatus(String status) {
    statusFilter.value = status;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = allStudents.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((student) {
        final name = student['name'].toString().toLowerCase();
        final id = student['id'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || id.contains(query);
      }).toList();
    }

    // Apply status filter (if needed for attendance status)
    // This can be expanded based on attendance marking requirements

    filteredStudents.value = filtered;
  }

  // Attendance management methods
  bool? isStudentPresent(String studentId, String mealType, DateTime date) {
    // Check if student has attendance marked for this meal and date
    // Return true if present, false if absent, null if not marked
    // This would typically check a database or local storage
    // For demo purposes, return null (not marked)
    return null;
  }

  void markAttendance(
    String studentId,
    String mealType,
    DateTime date,
    bool isPresent,
  ) {
    // Mark attendance for a student for specific meal and date
    print(
      'Marking $studentId as ${isPresent ? 'present' : 'absent'} for $mealType on $date',
    );

    // Update UI to reflect changes
    filteredStudents.refresh();

    // Show success message
    ToastMessage.success('Attendance marked for ${_getStudentName(studentId)}');
  }

  void markAllAttendance(String mealType, DateTime date, bool isPresent) {
    // Mark all students as present/absent for specific meal and date
    for (final student in filteredStudents) {
      markAttendance(student['id'], mealType, date, isPresent);
    }
  }

  List<dynamic> getEventsForDay(DateTime day) {
    // Return events (attendance data) for calendar view
    // This would typically fetch from attendance records
    return [];
  }

  String _getStudentName(String studentId) {
    final student = allStudents.firstWhere(
      (s) => s['id'] == studentId,
      orElse: () => {'name': 'Unknown'},
    );
    return student['name'];
  }

  void markAttendanceOld(String studentId, MealType mealType, bool isPresent) {
    final attendanceId = 'att_${DateTime.now().millisecondsSinceEpoch}';
    final newAttendance = Attendance(
      id: attendanceId,
      studentId: studentId,
      date: selectedDate.value,
      mealType: mealType,
      isPresent: isPresent,
      markedAt: DateTime.now(),
      markedBy: 'staff1', // Current staff ID
    );

    // Remove any existing attendance for this student, date, and meal type
    attendanceList.removeWhere(
      (a) =>
          a.studentId == studentId &&
          a.date.year == selectedDate.value.year &&
          a.date.month == selectedDate.value.month &&
          a.date.day == selectedDate.value.day &&
          a.mealType == mealType,
    );

    // Add new attendance record
    attendanceList.add(newAttendance);
  }

  bool isStudentPresentOld(String studentId, MealType mealType) {
    final attendance = attendanceList
        .where(
          (a) =>
              a.studentId == studentId &&
              a.date.year == selectedDate.value.year &&
              a.date.month == selectedDate.value.month &&
              a.date.day == selectedDate.value.day &&
              a.mealType == mealType,
        )
        .firstOrNull;

    return attendance?.isPresent ?? false;
  }

  // Statistics methods
  Map<String, dynamic> getTodayStats() {
    final today = DateTime.now();
    final todayAttendance = attendanceList
        .where(
          (a) =>
              a.date.year == today.year &&
              a.date.month == today.month &&
              a.date.day == today.day,
        )
        .toList();

    final totalStudents = allStudents
        .where((s) => s['isApproved'] == true)
        .length;
    final breakfastPresent = todayAttendance
        .where((a) => a.mealType == MealType.breakfast && a.isPresent)
        .length;
    final dinnerPresent = todayAttendance
        .where((a) => a.mealType == MealType.dinner && a.isPresent)
        .length;

    return {
      'totalStudents': totalStudents,
      'breakfastPresent': breakfastPresent,
      'dinnerPresent': dinnerPresent,
      'breakfastAbsent': totalStudents - breakfastPresent,
      'dinnerAbsent': totalStudents - dinnerPresent,
      'breakfastAttendanceRate': totalStudents > 0
          ? (breakfastPresent /  100 )
          : 0.0,
      'dinnerAttendanceRate': totalStudents > 0
          ? (dinnerPresent /  100 )
          : 0.0,
    };
  }

  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weeklyAttendance = attendanceList
        .where(
          (a) =>
              a.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              a.date.isBefore(startOfWeek.add(const Duration(days: 7))),
        )
        .toList();

    final totalStudents = allStudents
        .where((s) => s['isApproved'] == true)
        .length;
    final totalPossibleMeals = totalStudents * 7 * 2; // 7 days, 2 meals per day
    final totalPresent = weeklyAttendance.where((a) => a.isPresent).length;

    return {
      'totalPossibleMeals': totalPossibleMeals,
      'totalPresent': totalPresent,
      'totalAbsent': totalPossibleMeals - totalPresent,
      'weeklyAttendanceRate': totalPossibleMeals > 0
          ? (totalPresent /  100 )
          : 0.0,
    };
  }

  List<Map<String, dynamic>> getAttendanceByDay() {
    final now = DateTime.now();
    final last7Days = List.generate(
      7,
      (index) => now.subtract(Duration(days: 6 - index)),
    );

    return last7Days.map((day) {
      final dayAttendance = attendanceList
          .where(
            (a) =>
                a.date.year == day.year &&
                a.date.month == day.month &&
                a.date.day == day.day,
          )
          .toList();

      final present = dayAttendance.where((a) => a.isPresent).length;
      final totalPossible =
          allStudents.where((s) => s['isApproved'] == true).length * 2;

      return {
        'date': day,
        'present': present,
        'total': totalPossible,
        'percentage': totalPossible > 0 ? (present /  100 ) : 0.0,
      };
    }).toList();
  }

  // Student management methods
  List<dynamic> getPendingApprovals() {
    return allStudents
        .where((student) => student['isApproved'] != true)
        .toList();
  }

  void approveStudent(String studentId) {
    final studentIndex = allStudents.indexWhere((s) => s.id == studentId);
    if (studentIndex != -1) {
      allStudents[studentIndex] = Student(
        id: allStudents[studentIndex].id,
        name: allStudents[studentIndex].name,
        email: allStudents[studentIndex].email,
        hostelName: allStudents[studentIndex].hostelName,
        roomNumber: allStudents[studentIndex].roomNumber,
        joinDate: allStudents[studentIndex].joinDate,
        isApproved: true,
      );
      allStudents.refresh();
    }
  }

  void rejectStudent(String studentId) {
    allStudents.removeWhere((student) => student.id == studentId);
  }

  // Menu management methods
  void addMenuItem(MenuItem item) {
    menuItems.add(item);
  }

  void updateMenuItem(String itemId, MenuItem updatedItem) {
    final index = menuItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      menuItems[index] = updatedItem;
      menuItems.refresh();
    }
  }

  void removeMenuItem(String itemId) {
    menuItems.removeWhere((item) => item.id == itemId);
  }

  // Utility methods
  String getCurrentPageTitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Staff Dashboard';
      case 1:
        return 'Attendance Management';
      case 2:
        return 'Student Management';
      // case 3:
      //   return 'Reports & Analytics'; // Commented out - can be enabled later
      default:
        return 'Staff Dashboard';
    }
  }

  String getCurrentPageSubtitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Manage mess operations efficiently';
      case 1:
        return 'Mark daily meal attendance';
      case 2:
        return 'Manage student accounts';
      // case 3:
      //   return 'View detailed analytics'; // Commented out - can be enabled later
      default:
        return 'Welcome to MessMaster Staff Panel';
    }
  }
}




