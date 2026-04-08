import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/student.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/models/attendance.dart';
import '../../data/models/menu.dart';
import '../../data/services/dummy_data_service.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/user_service.dart';
import '../../data/models/auth_models.dart';
import '../user/user_controller.dart';
import '../../widgets/dashboard_navigation.dart';
import 'controllers/staff_student_controller.dart';

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

  // Attendance cache: studentId_roll + day + meal -> status
  final RxMap<String, bool?> _attendanceStatusCache = <String, bool?>{}.obs;

  // Mapping from roll number shown in UI to actual user uid in students/users data
  final RxMap<String, String> _rollToUid = <String, String>{}.obs;

  final Set<String> _loadedAttendanceMonths = <String>{};
  final Set<String> _loadingAttendanceMonths = <String>{};
  Worker? _studentFilterWorker;
  Worker? _authUserWorker;
  String _loadedForStaffUid = '';
  bool _isLoadingStaffData = false;

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

  // User service for real data
  final UserService _userService = Get.find<UserService>();
  final MenuService _menuService = Get.find<MenuService>();

  // Student controller for managing student data
  late StaffStudentController _studentController;

  @override
  void onInit() {
    super.onInit();
    // Initialize student controller
    _studentController = Get.put(StaffStudentController());

    _studentFilterWorker = ever(_studentController.filteredStudents, (_) {
      allStudents.value = _studentsAsMapFromAppUsers(
        _studentController.allStudents,
      );
      _rebuildRollToUidMap();
      _applyFilters();
    });

    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      _authUserWorker = ever<AppUser?>(userController.currentUser, (user) {
        if (user == null || user.role != UserRole.staff) {
          _loadedForStaffUid = '';
          _clearAttendanceState();
          return;
        }

        if (_loadedForStaffUid != user.uid) {
          _loadedForStaffUid = user.uid;
          loadStaffData(forceReloadAttendance: true);
        }
      });
    }

    loadStaffData(forceReloadAttendance: true);
  }

  @override
  void onClose() {
    _studentFilterWorker?.dispose();
    _authUserWorker?.dispose();
    super.onClose();
  }

  Future<void> loadStaffData({bool forceReloadAttendance = false}) async {
    if (_isLoadingStaffData) {
      return;
    }

    _isLoadingStaffData = true;
    isLoading.value = true;

    try {
      // Load real student data from Firebase via student controller
      await _studentController.loadStudents();

      // Initial load
      allStudents.value = _studentsAsMapFromAppUsers(
        _studentController.allStudents,
      );
      _rebuildRollToUidMap();

      _clearAttendanceState();

      // Preload current month attendance for all loaded students
      await ensureMonthlyAttendanceLoaded(
        DateTime.now(),
        forceReload: forceReloadAttendance,
      );

      // Load menu items
      menuItems.value = DummyDataService.getWeeklyMenu();

      // Load meal rates
      mealRates.value = DummyDataService.getMealRates();

      _applyFilters();
    } finally {
      isLoading.value = false;
      _isLoadingStaffData = false;
    }
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
    var students = List<Map<String, dynamic>>.from(allStudents);

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      students = students.where((student) {
        final name = student['name']?.toString().toLowerCase() ?? '';
        final id = student['id']?.toString().toLowerCase() ?? '';
        final email = student['email']?.toString().toLowerCase() ?? '';
        return name.contains(query) ||
            id.contains(query) ||
            email.contains(query);
      }).toList();
    }

    final selectedStatus = statusFilter.value;

    if (selectedStatus != 'All') {
      final date = selectedDate.value;
      final mealType = selectedMealType.value == MealType.breakfast
          ? 'breakfast'
          : 'dinner';

      students = students.where((student) {
        final status = isStudentPresent(
          student['id'].toString(),
          mealType,
          date,
        );
        if (selectedStatus == 'Present') {
          return status == true;
        }
        if (selectedStatus == 'Absent') {
          return status == false;
        }
        if (selectedStatus == 'Not Marked') {
          return status == null;
        }
        return true;
      }).toList();
    }

    filteredStudents.value = students;
  }

  void setAttendanceContext({DateTime? date, String? mealType}) {
    if (date != null) {
      selectedDate.value = date;
    }
    if (mealType != null) {
      selectedMealType.value = _mealTypeFromString(mealType);
    }
    _applyFilters();
  }

  // Attendance management methods
  bool? isStudentPresent(String studentId, String mealType, DateTime date) {
    final monthKey = _monthKey(date);
    if (!_loadedAttendanceMonths.contains(monthKey) &&
        !_loadingAttendanceMonths.contains(monthKey)) {
      // Lazy-load month attendance when card first asks for this date.
      ensureMonthlyAttendanceLoaded(date);
    }

    final key = _attendanceKey(studentId, date, mealType);
    return _attendanceStatusCache[key];
  }

  Future<bool> markAttendance(
    String studentId,
    String mealType,
    DateTime date,
    bool isPresent, {
    bool showToast = true,
  }) async {
    final key = _attendanceKey(studentId, date, mealType);
    final previousValue = _attendanceStatusCache[key];

    // Optimistic update so UI toggles instantly.
    _attendanceStatusCache[key] = isPresent;
    _applyFilters();

    final studentUid = _rollToUid[studentId];
    if (studentUid == null || studentUid.isEmpty) {
      if (previousValue == null) {
        _attendanceStatusCache.remove(key);
      } else {
        _attendanceStatusCache[key] = previousValue;
      }
      _applyFilters();
      ToastMessage.error(
        'Could not resolve user for ${_getStudentName(studentId)}',
      );
      return false;
    }

    try {
      final mealSnapshot = await _resolveMealSnapshotForDate(date, mealType);

      await _userService.markStudentMealAttendance(
        userUid: studentUid,
        date: date,
        mealType: mealType,
        isPresent: isPresent,
        markedBy: _currentStaffId(),
        menuItemId: mealSnapshot['menuItemId'] as String?,
        menuName: mealSnapshot['menuName'] as String?,
        menuPrice: mealSnapshot['menuPrice'] as double?,
      );
      _upsertAttendanceRecord(
        studentId,
        mealType,
        date,
        isPresent,
        menuItemId: mealSnapshot['menuItemId'] as String?,
        menuName: mealSnapshot['menuName'] as String?,
        menuPrice: mealSnapshot['menuPrice'] as double?,
      );

      if (showToast) {
        ToastMessage.success(
          'Attendance marked for ${_getStudentName(studentId)}',
        );
      }
      _applyFilters();
      return true;
    } catch (e) {
      if (previousValue == null) {
        _attendanceStatusCache.remove(key);
      } else {
        _attendanceStatusCache[key] = previousValue;
      }
      _applyFilters();
      ToastMessage.error(
        'Failed to mark attendance for ${_getStudentName(studentId)}',
      );
      return false;
    }
  }

  Future<void> markAllAttendance(
    String mealType,
    DateTime date,
    bool isPresent,
  ) async {
    // Mark all students as present/absent for specific meal and date
    int failed = 0;
    for (final student in filteredStudents) {
      final success = await markAttendance(
        student['id'],
        mealType,
        date,
        isPresent,
        showToast: false,
      );
      if (!success) {
        failed++;
      }
    }

    if (failed > 0) {
      ToastMessage.error('Could not mark $failed student records');
    }
  }

  List<dynamic> getEventsForDay(DateTime day) {
    final hasAnyMarked = _rollToUid.keys.any((studentId) {
      final breakfast =
          _attendanceStatusCache[_attendanceKey(studentId, day, 'breakfast')];
      final dinner =
          _attendanceStatusCache[_attendanceKey(studentId, day, 'dinner')];
      return breakfast != null || dinner != null;
    });

    return hasAnyMarked ? ['attendance_marked'] : [];
  }

  Future<void> ensureMonthlyAttendanceLoaded(
    DateTime date, {
    bool forceReload = false,
  }) async {
    final month = _monthKey(date);

    if (forceReload) {
      _loadedAttendanceMonths.remove(month);
    }

    if (_loadedAttendanceMonths.contains(month) ||
        _loadingAttendanceMonths.contains(month)) {
      return;
    }

    if (_rollToUid.isEmpty) {
      _rebuildRollToUidMap();
    }

    if (_rollToUid.isEmpty) {
      return;
    }

    _loadingAttendanceMonths.add(month);
    try {
      final entries = _rollToUid.entries.toList();
      await Future.wait(
        entries.map((entry) async {
          final dailyData = await _userService.getStudentMonthlyAttendance(
            userUid: entry.value,
            month: date,
          );
          _applyMonthlyAttendanceToCache(entry.key, date, dailyData);
        }),
      );

      _loadedAttendanceMonths.add(month);
      _applyFilters();
    } catch (_) {
    } finally {
      _loadingAttendanceMonths.remove(month);
    }
  }

  void _clearAttendanceState() {
    _attendanceStatusCache.clear();
    _loadedAttendanceMonths.clear();
    _loadingAttendanceMonths.clear();
    attendanceList.clear();
  }

  String _getStudentName(String studentId) {
    final student = allStudents.firstWhere(
      (s) => s['id'] == studentId,
      orElse: () => {'name': 'Unknown'},
    );
    return student['name'];
  }

  void _rebuildRollToUidMap() {
    final map = <String, String>{};

    for (final student in _studentController.allStudents) {
      final details = _studentController.studentDetails[student.uid];
      final rollNumber = details?['rollNumber']?.toString() ?? '';
      if (rollNumber.isNotEmpty && rollNumber != 'N/A') {
        map[rollNumber] = student.uid;
      }
    }

    _rollToUid.value = map;
  }

  List<Map<String, dynamic>> _studentsAsMapFromAppUsers(List<AppUser> users) {
    return users.map((student) {
      final details = _studentController.studentDetails[student.uid] ?? {};
      return {
        'id': details['rollNumber'] ?? 'N/A',
        'name': student.fullName,
        'email': student.email,
        'room': details['roomNumber'] ?? 'N/A',
        'isApproved': student.status == UserStatus.active,
      };
    }).toList();
  }

  String _currentStaffId() {
    if (Get.isRegistered<UserController>()) {
      final user = Get.find<UserController>().currentUser.value;
      if (user != null && user.uid.isNotEmpty) {
        return user.uid;
      }
    }
    return 'staff';
  }

  Future<Map<String, dynamic>> _resolveMealSnapshotForDate(
    DateTime date,
    String mealType,
  ) async {
    final normalizedMeal = _normalizeMealType(mealType);
    final weekday = _weekdayKey(date);

    try {
      final weeklyMenu = await _menuService.getWeeklyMenu(_startOfWeek(date));
      final menuItem = weeklyMenu[weekday]?[normalizedMeal];

      if (menuItem != null) {
        return {
          'menuItemId': menuItem.id,
          'menuName': menuItem.name,
          'menuPrice': menuItem.price,
        };
      }

      final currentRate = await _menuService.getCurrentRate(normalizedMeal);
      return {
        'menuItemId': null,
        'menuName': _displayMealName(normalizedMeal),
        'menuPrice': currentRate?.rate,
      };
    } catch (_) {
      return {
        'menuItemId': null,
        'menuName': _displayMealName(normalizedMeal),
        'menuPrice': null,
      };
    }
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  String _weekdayKey(DateTime date) {
    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  String _displayMealName(String normalizedMeal) {
    return normalizedMeal == 'breakfast' ? 'Breakfast' : 'Dinner';
  }

  void _applyMonthlyAttendanceToCache(
    String studentId,
    DateTime monthDate,
    Map<String, dynamic> dailyData,
  ) {
    for (final dayEntry in dailyData.entries) {
      final dayRaw = dayEntry.key;
      final dayNumber = int.tryParse(dayRaw);
      if (dayNumber == null) {
        continue;
      }

      final dayValue = dayEntry.value;
      if (dayValue is! Map) {
        continue;
      }

      final dayMap = Map<String, dynamic>.from(dayValue);
      final date = DateTime(monthDate.year, monthDate.month, dayNumber);

      _setMealFromDayMap(studentId, date, dayMap, 'breakfast');
      _setMealFromDayMap(studentId, date, dayMap, 'dinner');
    }
  }

  void _setMealFromDayMap(
    String studentId,
    DateTime date,
    Map<String, dynamic> dayMap,
    String mealType,
  ) {
    final mealRaw = dayMap[mealType];
    bool? isPresent;
    String? menuItemId;
    String? menuName;
    double? menuPrice;

    if (mealRaw is bool) {
      isPresent = mealRaw;
    } else if (mealRaw is Map) {
      final mealMap = Map<String, dynamic>.from(mealRaw);
      final rawPresence = mealMap['isPresent'];
      if (rawPresence is bool) {
        isPresent = rawPresence;
      }
      final rawMenuItemId = mealMap['menuItemId'];
      final rawMenuName = mealMap['menuName'];
      if (rawMenuItemId is String && rawMenuItemId.trim().isNotEmpty) {
        menuItemId = rawMenuItemId;
      }
      if (rawMenuName is String && rawMenuName.trim().isNotEmpty) {
        menuName = rawMenuName;
      }
      menuPrice = _toDouble(mealMap['menuPrice']);
    }

    if (isPresent != null) {
      _attendanceStatusCache[_attendanceKey(studentId, date, mealType)] =
          isPresent;
      _upsertAttendanceRecord(
        studentId,
        mealType,
        date,
        isPresent,
        menuItemId: menuItemId,
        menuName: menuName,
        menuPrice: menuPrice,
      );
    }
  }

  void _upsertAttendanceRecord(
    String studentId,
    String mealType,
    DateTime date,
    bool isPresent, {
    String? menuItemId,
    String? menuName,
    double? menuPrice,
  }) {
    final mealTypeEnum = _mealTypeFromString(mealType);

    attendanceList.removeWhere(
      (a) =>
          a.studentId == studentId &&
          a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day &&
          a.mealType == mealTypeEnum,
    );

    attendanceList.add(
      Attendance(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        date: date,
        mealType: mealTypeEnum,
        isPresent: isPresent,
        markedAt: DateTime.now(),
        markedBy: _currentStaffId(),
        menuItemId: menuItemId,
        menuName: menuName,
        menuPrice: menuPrice,
      ),
    );
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  MealType _mealTypeFromString(String mealType) {
    return _normalizeMealType(mealType) == 'breakfast'
        ? MealType.breakfast
        : MealType.dinner;
  }

  String _normalizeMealType(String mealType) {
    final normalized = mealType.trim().toLowerCase();
    return normalized == 'breakfast' ? 'breakfast' : 'dinner';
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _monthKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }

  String _attendanceKey(String studentId, DateTime date, String mealType) {
    return '${studentId}_${_dateKey(date)}_${_normalizeMealType(mealType)}';
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
    final today = selectedDate.value;
    final todayAttendance = attendanceList
        .where(
          (a) =>
              a.date.year == today.year &&
              a.date.month == today.month &&
              a.date.day == today.day,
        )
        .toList();

    // Use real student data from student controller
    final totalStudents = _studentController.activeStudentCount;
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
          ? (breakfastPresent / 100)
          : 0.0,
      'dinnerAttendanceRate': totalStudents > 0 ? (dinnerPresent / 100) : 0.0,
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

    final totalStudents = _studentController.activeStudentCount;
    final totalPossibleMeals = totalStudents * 7 * 2; // 7 days, 2 meals per day
    final totalPresent = weeklyAttendance.where((a) => a.isPresent).length;

    return {
      'totalPossibleMeals': totalPossibleMeals,
      'totalPresent': totalPresent,
      'totalAbsent': totalPossibleMeals - totalPresent,
      'weeklyAttendanceRate': totalPossibleMeals > 0
          ? (totalPresent / 100)
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
      final totalPossible = _studentController.activeStudentCount * 2;

      return {
        'date': day,
        'present': present,
        'total': totalPossible,
        'percentage': totalPossible > 0 ? (present / 100) : 0.0,
      };
    }).toList();
  }

  // Student management methods
  List<dynamic> getPendingApprovals() {
    return _studentController.allStudents
        .where((student) => student.status == UserStatus.pending)
        .map(
          (student) => {
            'id': student.uid,
            'name': student.fullName,
            'email': student.email,
            'isApproved': false,
          },
        )
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
        return 'Welcome to Hostel Mess Management Staff Panel';
    }
  }
}
