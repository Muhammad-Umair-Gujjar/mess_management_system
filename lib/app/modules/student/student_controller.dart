import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../data/models/student.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/models/attendance.dart';
import '../../data/models/menu.dart';
import '../../data/services/dummy_data_service.dart';
import '../../data/services/menu_service.dart';
import '../../widgets/dashboard_navigation.dart';

class StudentController extends GetxController {
  final MenuService _menuService = Get.find<MenuService>();

  var isLoading = false.obs;
  var isLoadingMenu = false.obs;
  var currentStudent = Rxn<Student>();
  var attendanceList = <Attendance>[].obs;
  var menuItems = <MenuItem>[].obs;
  var mealRates = <MealRate>[].obs;
  var monthlyBilling = 0.0.obs;
  var attendanceRate = 0.0.obs;
  var currentPageIndex = 0.obs;

  // Enhanced menu data
  var currentWeekMenu = <String, Map<String, MenuItem?>>{}.obs;
  var activeMenuSchedule = Rxn<ActiveMenuSchedule>();
  var selectedWeekDate = DateTime.now().obs;

  // Navigation menu items
  List<NavigationItem> get navigationItems => [
    const NavigationItem(
      icon: FontAwesomeIcons.house,
      title: 'Dashboard',
      route: '/student/home',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.calendarCheck,
      title: 'Attendance',
      route: '/student/attendance',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.receipt,
      title: 'Billing',
      route: '/student/billing',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.utensils,
      title: 'Menu',
      route: '/student/menu',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.comment,
      title: 'Feedback',
      route: '/student/feedback',
      badge: 2,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    selectedWeekDate.value = _getStartOfWeek(DateTime.now());
    loadStudentData();
    _setupRealTimeListeners();
  }

  void loadStudentData() {
    // StudentController - loadStudentData called
    isLoading.value = true;

    // Load current student (Ali Ahmed) - using dummy data for now
    final students = DummyDataService.getStudents();
    currentStudent.value = students.firstWhere(
      (s) => s.id == '1',
      orElse: () => students.first,
    );
    print(
      '✅ DEBUG: StudentController - Loaded student: ${currentStudent.value?.name}',
    );

    // Load attendance for current student - using dummy data for now
    final allAttendance = DummyDataService.getAttendance();
    attendanceList.value = allAttendance
        .where((a) => a.studentId == currentStudent.value!.id)
        .toList();
    print(
      '✅ DEBUG: StudentController - Loaded ${attendanceList.length} attendance records',
    );

    // Load Firebase menu data
    _loadFirebaseMenuData();

    // Calculate billing and attendance rate
    _calculateMonthlyBilling();
    _calculateAttendanceRate();

    // StudentController - Student data loaded successfully
    isLoading.value = false;
  }

  /// Load menu data from Firebase
  Future<void> _loadFirebaseMenuData() async {
    try {
      // Load current week menu
      await loadCurrentWeekMenu();

      // Load meal rates
      await loadMealRates();

      // Load active schedule
      await _loadActiveSchedule();
    } catch (e) {
      print('Error loading Firebase menu data: $e');
      ToastMessage.error('Failed to load menu data');
    }
  }

  /// Load current week menu from Firebase
  Future<void> loadCurrentWeekMenu() async {
    print('🔵 DEBUG: StudentController - loadCurrentWeekMenu called');
    isLoadingMenu.value = true;
    try {
      final startOfWeek = selectedWeekDate.value;
      print(
        '   Week start date: ${DateFormat('yyyy-MM-dd').format(startOfWeek)}',
      );

      final weeklyMenu = await _menuService.getWeeklyMenu(startOfWeek);
      currentWeekMenu.value = weeklyMenu;

      print(
        '✅ DEBUG: StudentController - Loaded weekly menu for ${DateFormat('yyyy-MM-dd').format(startOfWeek)}',
      );
      print('   Menu days: ${weeklyMenu.keys.length}');
    } catch (e) {
      print('❌ DEBUG: StudentController - Error loading current week menu: $e');
      print('   Stack trace: ${StackTrace.current}');
      ToastMessage.error('Failed to load menu: ${e.toString()}');
    } finally {
      isLoadingMenu.value = false;
    }
  }

  /// Load meal rates from Firebase
  Future<void> loadMealRates() async {
    try {
      final rates = await _menuService.getAllMealRates();
      mealRates.value = rates;
      print('Loaded ${rates.length} meal rates');
    } catch (e) {
      print('Error loading meal rates: $e');
      // Fallback to dummy data if Firebase fails
      mealRates.value = DummyDataService.getMealRates();
    }
  }

  /// Load active menu schedule
  Future<void> _loadActiveSchedule() async {
    try {
      final schedule = await _menuService.getCurrentActiveSchedule();
      activeMenuSchedule.value = schedule;
      // Active schedule loaded: ${schedule?.templateId ?? 'none'}
    } catch (e) {
      print('Error loading active schedule: $e');
    }
  }

  /// Setup real-time listeners for menu updates
  void _setupRealTimeListeners() {
    // Listen to active schedule changes
    _menuService.activeMenuScheduleStream.listen(
      (schedule) {
        activeMenuSchedule.value = schedule;
        // Reload menu when schedule changes
        if (schedule != null) {
          loadCurrentWeekMenu();
        }
        print('Real-time update: Active schedule changed');
      },
      onError: (error) {
        print('Error in active schedule stream: $error');
      },
    );

    // Listen to meal rates changes
    _menuService.mealRatesStream.listen(
      (rates) {
        mealRates.value = rates;
        _calculateMonthlyBilling(); // Recalculate billing when rates change
        print('Real-time update: ${rates.length} meal rates');
      },
      onError: (error) {
        print('Error in meal rates stream: $error');
      },
    );
  }

  void _calculateMonthlyBilling() {
    if (mealRates.isEmpty) return;

    final breakfastRate = mealRates
        .firstWhere((r) => r.mealType == MealType.breakfast)
        .rate;
    final dinnerRate = mealRates
        .firstWhere((r) => r.mealType == MealType.dinner)
        .rate;

    final now = DateTime.now();
    final currentMonthAttendance = attendanceList
        .where(
          (a) =>
              a.date.month == now.month &&
              a.date.year == now.year &&
              a.isPresent,
        )
        .toList();

    final breakfastCount = currentMonthAttendance
        .where((a) => a.mealType == MealType.breakfast)
        .length;
    final dinnerCount = currentMonthAttendance
        .where((a) => a.mealType == MealType.dinner)
        .length;

    monthlyBilling.value =
        (breakfastCount * breakfastRate) + (dinnerCount * dinnerRate);
  }

  void _calculateAttendanceRate() {
    if (attendanceList.isEmpty) return;

    final presentCount = attendanceList.where((a) => a.isPresent).length;
    attendanceRate.value = (presentCount / attendanceList.length) * 100;
  }

  List<Attendance> getAttendanceForDate(DateTime date) {
    return attendanceList
        .where(
          (a) =>
              a.date.day == date.day &&
              a.date.month == date.month &&
              a.date.year == date.year,
        )
        .toList();
  }

  /// Get menu for specific date and meal type from Firebase data
  MenuItem? getMenuForDate(DateTime date, MealType mealType) {
    final dayKey = DateFormat(
      'EEEE',
    ).format(date).toLowerCase(); // monday, tuesday, etc.
    final mealTypeStr = mealType.name; // 'breakfast' or 'dinner'

    return currentWeekMenu[dayKey]?[mealTypeStr];
  }

  /// Get meal rate for specific meal type
  MealRate? getRateForMealType(String mealType) {
    return mealRates.firstWhereOrNull(
      (rate) => rate.category == mealType && rate.isActive,
    );
  }

  /// Navigate to different week
  Future<void> navigateToWeek(DateTime weekStart) async {
    selectedWeekDate.value = _getStartOfWeek(weekStart);
    await loadCurrentWeekMenu();
  }

  /// Get current week dates
  List<DateTime> getCurrentWeekDates() {
    final startOfWeek = selectedWeekDate.value;
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  /// Get start of week (Monday)
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Navigate to previous week
  Future<void> navigateToPreviousWeek() async {
    final previousWeek = selectedWeekDate.value.subtract(
      const Duration(days: 7),
    );
    await navigateToWeek(previousWeek);
  }

  /// Navigate to next week
  Future<void> navigateToNextWeek() async {
    final nextWeek = selectedWeekDate.value.add(const Duration(days: 7));
    await navigateToWeek(nextWeek);
  }

  /// Navigate to current week
  Future<void> navigateToCurrentWeek() async {
    await navigateToWeek(DateTime.now());
  }

  /// Get week display string
  String getWeekDisplayString() {
    final startOfWeek = selectedWeekDate.value;
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startFormat = DateFormat('MMM dd');
    final endFormat = DateFormat('MMM dd, yyyy');

    return '${startFormat.format(startOfWeek)} - ${endFormat.format(endOfWeek)}';
  }

  /// Check if current week is selected
  bool isCurrentWeekSelected() {
    final now = DateTime.now();
    final currentWeekStart = _getStartOfWeek(now);
    return selectedWeekDate.value.difference(currentWeekStart).inDays == 0;
  }

  /// Submit feedback for a menu item using Firebase
  Future<void> submitFeedback({
    required int rating,
    required String comment,
    required String category,
    String menuItemId = '',
    DateTime? mealDate,
    List<String> tags = const [],
  }) async {
    isLoading.value = true;

    try {
      final studentId = currentStudent.value?.id ?? '';
      final feedbackMealDate = mealDate ?? DateTime.now();

      final feedback = MenuFeedback(
        id: '', // Will be set by Firestore
        studentId: studentId,
        menuItemId: menuItemId,
        mealDate: feedbackMealDate,
        mealType: category,
        rating: rating,
        comment: comment,
        tags: tags,
        submittedAt: DateTime.now(),
      );

      final success = await _menuService.submitMenuFeedback(feedback);

      if (success) {
        ToastMessage.success('Thank you for your feedback!');
      } else {
        ToastMessage.error('Failed to submit feedback. Please try again.');
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      ToastMessage.error('Failed to submit feedback: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, int> getTodaysStats() {
    final today = DateTime.now();
    final todayAttendance = getAttendanceForDate(today);

    return {
      'breakfastAttended': todayAttendance
          .where((a) => a.mealType == MealType.breakfast && a.isPresent)
          .length,
      'dinnerAttended': todayAttendance
          .where((a) => a.mealType == MealType.dinner && a.isPresent)
          .length,
    };
  }

  Map<String, int> getMonthlyStats() {
    final now = DateTime.now();
    final monthlyAttendance = attendanceList
        .where((a) => a.date.month == now.month && a.date.year == now.year)
        .toList();

    final presentCount = monthlyAttendance.where((a) => a.isPresent).length;
    final breakfastCount = monthlyAttendance
        .where((a) => a.mealType == MealType.breakfast && a.isPresent)
        .length;
    final dinnerCount = monthlyAttendance
        .where((a) => a.mealType == MealType.dinner && a.isPresent)
        .length;
    final totalDays = DateTime.now().day;
    final possibleMeals = totalDays * 2; // 2 meals per day

    return {
      'attendedMeals': presentCount,
      'breakfastCount': breakfastCount,
      'dinnerCount': dinnerCount,
      'totalPossible': possibleMeals,
      'missedMeals': possibleMeals - presentCount,
    };
  }

  Map<String, dynamic> getStudentStats() {
    final monthlyStats = getMonthlyStats();

    return {
      'currentBill': monthlyBilling.value.toInt(),
      'attendancePercentage': attendanceRate.value.toInt(),
      'pendingDues': 150, // Mock value
      'daysRemaining': 15, // Mock value
    };
  }

  Map<String, Map<String, dynamic>> getTodaysMenu() {
    // Mock today's menu data
    return {
      'Breakfast': {
        'items': ['Idli', 'Sambhar', 'Chutney', 'Tea'],
      },
      'Dinner': {
        'items': ['Rice', 'Dal', 'Sabji', 'Roti'],
      },
    };
  }

  List<Map<String, dynamic>> getRecentActivities() {
    // Mock recent activities data
    return [
      {
        'title': 'Breakfast Attendance Marked',
        'description': 'You attended breakfast today',
        'time': '2h ago',
        'type': 'attendance',
      },
      {
        'title': 'Bill Payment Due',
        'description': 'Monthly bill payment is due',
        'time': '1d ago',
        'type': 'payment',
      },
      {
        'title': 'Menu Updated',
        'description': 'This week\'s menu has been updated',
        'time': '2d ago',
        'type': 'meal',
      },
      {
        'title': 'Feedback Submitted',
        'description': 'Your feedback has been received',
        'time': '3d ago',
        'type': 'complaint',
      },
    ];
  }

  // Navigation methods
  void changePage(int index) {
    currentPageIndex.value = index;
  }

  String getCurrentPageTitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Attendance';
      case 2:
        return 'Billing';
      case 3:
        return 'Menu';
      case 4:
        return 'Feedback';
      default:
        return 'Dashboard';
    }
  }

  String getCurrentPageSubtitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Your meal management overview';
      case 1:
        return 'Track your meal attendance';
      case 2:
        return 'View your monthly billing';
      case 3:
        return 'Weekly meal menu';
      case 4:
        return 'Share your feedback';
      default:
        return 'Welcome to Hostel Mess Management';
    }
  }
}
