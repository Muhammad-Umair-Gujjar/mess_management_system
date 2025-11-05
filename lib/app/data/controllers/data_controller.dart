import 'package:get/get.dart';
import '../models/student.dart';
import '../models/menu.dart';
import '../models/attendance.dart';
import '../models/feedback.dart';

class DataController extends GetxController {
  // Observable data collections
  final RxList<Student> students = <Student>[].obs;
  final RxList<MenuItem> menuItems = <MenuItem>[].obs;
  final RxList<Attendance> attendanceRecords = <Attendance>[].obs;
  final RxList<Feedback> feedbackItems = <Feedback>[].obs;
  final RxList<MealRate> mealRates = <MealRate>[].obs;

  // Current user session
  final Rx<Student?> currentStudent = Rx<Student?>(null);
  final RxString currentUserRole = 'guest'.obs;

  // Dashboard statistics
  final RxInt totalStudents = 0.obs;
  final RxInt todayAttendance = 0.obs;
  final RxDouble monthlyRevenue = 0.0.obs;
  final RxDouble attendanceRate = 0.0.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // Initialize with dummy data
  void initializeData() {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      _generateDummyStudents();
      _generateDummyMenuItems();
      _generateDummyAttendance();
      _generateDummyFeedback();
      _generateDummyMealRates();
      _calculateStatistics();

      isLoading.value = false;
      isInitialized.value = true;
    });
  }

  // Student Management
  void _generateDummyStudents() {
    final dummyStudents = [
      Student(
        id: 'STU001',
        name: 'Ahmed Ali',
        email: 'ahmed.ali@university.edu',
        hostelName: 'Hostel A',
        roomNumber: 'A-101',
        joinDate: DateTime.now().subtract(const Duration(days: 30)),
        profileImage:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      ),
      Student(
        id: 'STU002',
        name: 'Sarah Johnson',
        email: 'sarah.j@university.edu',
        hostelName: 'Hostel B',
        roomNumber: 'B-205',
        joinDate: DateTime.now().subtract(const Duration(days: 25)),
        profileImage:
            'https://images.unsplash.com/photo-1494790108755-2616b612b976?w=150',
      ),
      Student(
        id: 'STU003',
        name: 'Michael Chen',
        email: 'michael.chen@university.edu',
        hostelName: 'Hostel A',
        roomNumber: 'A-302',
        joinDate: DateTime.now().subtract(const Duration(days: 20)),
        profileImage:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      ),
      Student(
        id: 'STU004',
        name: 'Priya Patel',
        email: 'priya.patel@university.edu',
        hostelName: 'Hostel C',
        roomNumber: 'C-150',
        joinDate: DateTime.now().subtract(const Duration(days: 15)),
        profileImage:
            'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=150',
      ),
      Student(
        id: 'STU005',
        name: 'David Rodriguez',
        email: 'david.r@university.edu',
        hostelName: 'Hostel B',
        roomNumber: 'B-401',
        joinDate: DateTime.now().subtract(const Duration(days: 10)),
        profileImage:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      ),
    ];

    students.assignAll(dummyStudents);
    totalStudents.value = students.length;
  }

  // Menu Management
  void _generateDummyMenuItems() {
    final today = DateTime.now();
    final menuItems = <MenuItem>[];

    // Generate menu for the next 7 days
    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i));

      // Breakfast items
      menuItems.add(
        MenuItem(
          id: 'MENU_B_${date.day}_${date.month}',
          name: _getBreakfastItem(i % 5),
          description: _getBreakfastDescription(i % 5),
          calories: 350 + (i * 25),
          mealType: MealType.breakfast,
          date: date,
          imageUrl:
              'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=300',
        ),
      );

      // Dinner items
      menuItems.add(
        MenuItem(
          id: 'MENU_D_${date.day}_${date.month}',
          name: _getDinnerItem(i % 5),
          description: _getDinnerDescription(i % 5),
          calories: 500 + (i * 30),
          mealType: MealType.dinner,
          date: date,
          imageUrl:
              'https://images.unsplash.com/photo-1546554137-f86b9593a222?w=300',
        ),
      );
    }

    this.menuItems.assignAll(menuItems);
  }

  // Attendance Management
  void _generateDummyAttendance() {
    final records = <Attendance>[];
    final today = DateTime.now();

    // Generate attendance for last 30 days
    for (int day = 0; day < 30; day++) {
      final date = today.subtract(Duration(days: day));

      for (final student in students) {
        // Breakfast attendance (80% probability)
        if (DateTime.now().millisecond % 10 < 8) {
          records.add(
            Attendance(
              id: 'ATT_${student.id}_B_${date.day}_${date.month}',
              studentId: student.id,
              mealType: MealType.breakfast,
              date: date,
              isPresent: true,
              markedAt: date.add(
                Duration(hours: 8, minutes: DateTime.now().millisecond % 30),
              ),
              markedBy: 'staff',
            ),
          );
        }

        // Dinner attendance (70% probability)
        if (DateTime.now().millisecond % 10 < 7) {
          records.add(
            Attendance(
              id: 'ATT_${student.id}_D_${date.day}_${date.month}',
              studentId: student.id,
              mealType: MealType.dinner,
              date: date,
              isPresent: true,
              markedAt: date.add(
                Duration(hours: 19, minutes: DateTime.now().millisecond % 30),
              ),
              markedBy: 'staff',
            ),
          );
        }
      }
    }

    attendanceRecords.assignAll(records);
    _calculateTodayAttendance();
  }

  // Feedback Management
  void _generateDummyFeedback() {
    final feedback = [
      Feedback(
        id: 'FB001',
        studentId: 'STU001',
        studentName: 'Ahmed Ali',
        rating: 4,
        comment: 'Great food quality and variety. Love the breakfast options!',
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'food_quality',
      ),
      Feedback(
        id: 'FB002',
        studentId: 'STU002',
        studentName: 'Sarah Johnson',
        rating: 5,
        comment: 'Excellent service and the new menu items are fantastic.',
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'service',
      ),
      Feedback(
        id: 'FB003',
        studentId: 'STU003',
        studentName: 'Michael Chen',
        rating: 3,
        comment: 'Food is okay but could use more vegetarian options.',
        submittedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: 'food_quality',
      ),
      Feedback(
        id: 'FB004',
        studentId: 'STU004',
        studentName: 'Priya Patel',
        rating: 4,
        comment: 'Clean dining area and friendly staff. Keep it up!',
        submittedAt: DateTime.now().subtract(const Duration(days: 4)),
        category: 'cleanliness',
      ),
    ];

    feedbackItems.assignAll(feedback);
  }

  // Meal Rate Management
  void _generateDummyMealRates() {
    final rates = [
      MealRate(
        id: 'RATE_B',
        mealType: MealType.breakfast,
        rate: 45.0,
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedBy: 'admin',
      ),
      MealRate(
        id: 'RATE_D',
        mealType: MealType.dinner,
        rate: 75.0,
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedBy: 'admin',
      ),
    ];

    mealRates.assignAll(rates);
  }

  // Statistics and Analytics
  void _calculateStatistics() {
    _calculateTodayAttendance();
    _calculateMonthlyRevenue();
    _calculateAttendanceRate();
  }

  void _calculateTodayAttendance() {
    final today = DateTime.now();
    final todayRecords = attendanceRecords
        .where(
          (record) =>
              record.date.year == today.year &&
              record.date.month == today.month &&
              record.date.day == today.day &&
              record.isPresent,
        )
        .length;

    todayAttendance.value = todayRecords;
  }

  void _calculateMonthlyRevenue() {
    final now = DateTime.now();
    final monthlyRecords = attendanceRecords.where(
      (record) =>
          record.date.year == now.year &&
          record.date.month == now.month &&
          record.isPresent,
    );

    double revenue = 0.0;
    for (final record in monthlyRecords) {
      final rate = mealRates.firstWhere((r) => r.mealType == record.mealType);
      revenue += rate.rate;
    }

    monthlyRevenue.value = revenue;
  }

  void _calculateAttendanceRate() {
    if (students.isEmpty) {
      attendanceRate.value = 0.0;
      return;
    }

    final now = DateTime.now();
    final monthlyPossibleMeals =
        students.length * DateTime.now().day * 2; // 2 meals per day
    final monthlyAttendedMeals = attendanceRecords
        .where(
          (record) =>
              record.date.year == now.year &&
              record.date.month == now.month &&
              record.isPresent,
        )
        .length;

    attendanceRate.value = monthlyPossibleMeals > 0
        ? (monthlyAttendedMeals / monthlyPossibleMeals) * 100
        : 0.0;
  }

  // Student Operations
  Student? getStudentById(String id) {
    try {
      return students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  void setCurrentStudent(String studentId) {
    currentStudent.value = getStudentById(studentId);
    currentUserRole.value = 'student';
  }

  void addStudent(Student student) {
    students.add(student);
    totalStudents.value = students.length;
  }

  void updateStudent(Student updatedStudent) {
    final index = students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      students[index] = updatedStudent;
    }
  }

  void removeStudent(String studentId) {
    students.removeWhere((s) => s.id == studentId);
    totalStudents.value = students.length;
  }

  // Attendance Operations
  List<Attendance> getStudentAttendance(String studentId) {
    return attendanceRecords
        .where((record) => record.studentId == studentId)
        .toList();
  }

  List<Attendance> getAttendanceByDate(DateTime date) {
    return attendanceRecords
        .where(
          (record) =>
              record.date.year == date.year &&
              record.date.month == date.month &&
              record.date.day == date.day,
        )
        .toList();
  }

  void markAttendance(String studentId, MealType mealType, DateTime date) {
    try {
      final existingRecord = attendanceRecords.firstWhere(
        (record) =>
            record.studentId == studentId &&
            record.mealType == mealType &&
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day,
      );

      final index = attendanceRecords.indexOf(existingRecord);
      attendanceRecords[index] = existingRecord.copyWith(
        isPresent: !existingRecord.isPresent,
        markedAt: DateTime.now(),
      );
    } catch (e) {
      final newRecord = Attendance(
        id: 'ATT_${studentId}_${mealType.name}_${date.day}_${date.month}_${date.year}',
        studentId: studentId,
        mealType: mealType,
        date: date,
        isPresent: true,
        markedAt: DateTime.now(),
        markedBy: currentUserRole.value,
      );
      attendanceRecords.add(newRecord);
    }

    _calculateStatistics();
  }

  // Menu Operations
  List<MenuItem> getMenuByDate(DateTime date) {
    return menuItems
        .where(
          (item) =>
              item.date.year == date.year &&
              item.date.month == date.month &&
              item.date.day == date.day,
        )
        .toList();
  }

  void addMenuItem(MenuItem item) {
    menuItems.add(item);
  }

  void updateMenuItem(MenuItem updatedItem) {
    final index = menuItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      menuItems[index] = updatedItem;
    }
  }

  void removeMenuItem(String itemId) {
    menuItems.removeWhere((item) => item.id == itemId);
  }

  // Billing Operations
  double calculateStudentBill(String studentId, int month, int year) {
    final studentAttendance = attendanceRecords.where(
      (record) =>
          record.studentId == studentId &&
          record.date.month == month &&
          record.date.year == year &&
          record.isPresent,
    );

    double totalBill = 0.0;
    for (final record in studentAttendance) {
      final rate = mealRates.firstWhere((r) => r.mealType == record.mealType);
      totalBill += rate.rate;
    }

    return totalBill;
  }

  Map<MealType, int> getStudentMealCount(
    String studentId,
    int month,
    int year,
  ) {
    final studentAttendance = attendanceRecords.where(
      (record) =>
          record.studentId == studentId &&
          record.date.month == month &&
          record.date.year == year &&
          record.isPresent,
    );

    final Map<MealType, int> mealCounts = {
      MealType.breakfast: 0,
      MealType.dinner: 0,
    };

    for (final record in studentAttendance) {
      mealCounts[record.mealType] = (mealCounts[record.mealType] ?? 0) + 1;
    }

    return mealCounts;
  }

  // Rate Management
  void updateMealRate(MealType mealType, double newRate) {
    final index = mealRates.indexWhere((rate) => rate.mealType == mealType);
    if (index != -1) {
      mealRates[index] = mealRates[index].copyWith(
        rate: newRate,
        updatedAt: DateTime.now(),
      );
    } else {
      mealRates.add(
        MealRate(
          id: 'RATE_${mealType.name.toUpperCase()}',
          mealType: mealType,
          rate: newRate,
          updatedAt: DateTime.now(),
          updatedBy: currentUserRole.value,
        ),
      );
    }

    _calculateStatistics();
  }

  double getMealRate(MealType mealType) {
    try {
      final rate = mealRates.firstWhere((r) => r.mealType == mealType);
      return rate.rate;
    } catch (e) {
      return mealType == MealType.breakfast ? 45.0 : 75.0; // Default rates
    }
  }

  // Feedback Operations
  void addFeedback(Feedback feedback) {
    feedbackItems.add(feedback);
  }

  List<Feedback> getStudentFeedback(String studentId) {
    return feedbackItems.where((fb) => fb.studentId == studentId).toList();
  }

  double getAverageRating() {
    if (feedbackItems.isEmpty) return 0.0;

    final totalRating = feedbackItems.fold<double>(
      0.0,
      (sum, item) => sum + item.rating,
    );
    return totalRating / feedbackItems.length;
  }

  // Helper methods for generating dummy data
  String _getBreakfastItem(int index) {
    const items = [
      'Paratha with Curry',
      'Pancakes & Syrup',
      'Toast & Eggs',
      'Cereal & Fruits',
      'Sandwich & Juice',
    ];
    return items[index];
  }

  String _getBreakfastDescription(int index) {
    const descriptions = [
      'Freshly made paratha with delicious curry',
      'Fluffy pancakes with maple syrup',
      'Whole grain toast with scrambled eggs',
      'Healthy cereal with fresh seasonal fruits',
      'Grilled sandwich with fresh orange juice',
    ];
    return descriptions[index];
  }

  String _getDinnerItem(int index) {
    const items = [
      'Chicken Biryani',
      'Pasta Marinara',
      'Grilled Fish & Rice',
      'Vegetable Curry',
      'Beef Steak & Mash',
    ];
    return items[index];
  }

  String _getDinnerDescription(int index) {
    const descriptions = [
      'Aromatic chicken biryani with raita',
      'Italian pasta with marinara sauce',
      'Grilled fish with steamed rice',
      'Mixed vegetable curry with naan',
      'Grilled beef steak with mashed potatoes',
    ];
    return descriptions[index];
  }

  // User Role Management
  void setUserRole(String role) {
    currentUserRole.value = role;
  }

  void logout() {
    currentStudent.value = null;
    currentUserRole.value = 'guest';
  }

  // Mock login method
  bool mockLogin(String email, String role) {
    if (role == 'student') {
      try {
        final student = students.firstWhere((s) => s.email == email);
        setCurrentStudent(student.id);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      // For staff and admin, just set the role
      currentUserRole.value = role;
      return true;
    }
  }
}
