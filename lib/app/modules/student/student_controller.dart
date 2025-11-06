import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/student.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/models/attendance.dart';
import '../../data/models/menu.dart';
import '../../data/services/dummy_data_service.dart';
import '../../widgets/dashboard_navigation.dart';

class StudentController extends GetxController {
  var isLoading = false.obs;
  var currentStudent = Rxn<Student>();
  var attendanceList = <Attendance>[].obs;
  var menuItems = <MenuItem>[].obs;
  var mealRates = <MealRate>[].obs;
  var monthlyBilling = 0.0.obs;
  var attendanceRate = 0.0.obs;
  var currentPageIndex = 0.obs;

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
    loadStudentData();
  }

  void loadStudentData() {
    isLoading.value = true;

    // Load current student (Ali Ahmed)
    final students = DummyDataService.getStudents();
    currentStudent.value = students.firstWhere(
      (s) => s.id == '1',
      orElse: () => students.first,
    );

    // Load attendance for current student
    final allAttendance = DummyDataService.getAttendance();
    attendanceList.value = allAttendance
        .where((a) => a.studentId == currentStudent.value!.id)
        .toList();

    // Load menu items
    menuItems.value = DummyDataService.getWeeklyMenu();

    // Load meal rates
    mealRates.value = DummyDataService.getMealRates();

    // Calculate billing
    _calculateMonthlyBilling();
    _calculateAttendanceRate();

    isLoading.value = false;
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

  MenuItem? getMenuForDate(DateTime date, MealType mealType) {
    return menuItems.cast<MenuItem?>().firstWhere(
      (m) =>
          m != null &&
          m.date.day == date.day &&
          m.date.month == date.month &&
          m.date.year == date.year &&
          m.mealType == mealType,
      orElse: () => null,
    );
  }

  void submitFeedback({
    required int rating,
    required String comment,
    required String category,
  }) {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      ToastMessage.success('Thank you for your feedback!');
    });
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
        return 'Welcome to MessMaster';
    }
  }
}
