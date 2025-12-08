import '../models/student.dart';
import '../models/attendance.dart';
import '../models/menu.dart';
import '../models/feedback.dart';

class DummyDataService {
  static List<Student> getStudents() {
    return [
      Student(
        id: '1',
        name: 'Ali Ahmed',
        email: 'ali.ahmed@university.edu',
        hostelName: 'Blue Hostel',
        roomNumber: 'B-101',
        joinDate: DateTime(2024, 8, 15),
        isApproved: true,
      ),
      Student(
        id: '2',
        name: 'Sara Khan',
        email: 'sara.khan@university.edu',
        hostelName: 'Green Hostel',
        roomNumber: 'G-205',
        joinDate: DateTime(2024, 8, 20),
        isApproved: true,
      ),
      Student(
        id: '3',
        name: 'Ahmed Hassan',
        email: 'ahmed.hassan@university.edu',
        hostelName: 'Blue Hostel',
        roomNumber: 'B-303',
        joinDate: DateTime(2024, 8, 25),
        isApproved: false,
      ),
      Student(
        id: '4',
        name: 'Fatima Ali',
        email: 'fatima.ali@university.edu',
        hostelName: 'Red Hostel',
        roomNumber: 'R-150',
        joinDate: DateTime(2024, 9, 1),
        isApproved: true,
      ),
      Student(
        id: '5',
        name: 'Omar Sheikh',
        email: 'omar.sheikh@university.edu',
        hostelName: 'Blue Hostel',
        roomNumber: 'B-220',
        joinDate: DateTime(2024, 9, 5),
        isApproved: false,
      ),
    ];
  }

  static List<Attendance> getAttendance() {
    final students = getStudents();
    final attendanceList = <Attendance>[];
    final now = DateTime.now();

    for (int day = 0; day < 30; day++) {
      final date = now.subtract(Duration(days: day));

      for (final student in students) {
        if (!student.isApproved) continue;

        // Breakfast attendance (80% probability)
        if (DateTime.now().millisecond % 100 < 80) {
          attendanceList.add(
            Attendance(
              id: '${student.id}_${date.day}_breakfast',
              studentId: student.id,
              date: date,
              mealType: MealType.breakfast,
              isPresent: true,
              markedAt: DateTime(date.year, date.month, date.day, 8, 0),
              markedBy: 'staff1',
            ),
          );
        }

        // Dinner attendance (90% probability)
        if (DateTime.now().millisecond % 100 < 90) {
          attendanceList.add(
            Attendance(
              id: '${student.id}_${date.day}_dinner',
              studentId: student.id,
              date: date,
              mealType: MealType.dinner,
              isPresent: true,
              markedAt: DateTime(date.year, date.month, date.day, 20, 0),
              markedBy: 'staff1',
            ),
          );
        }
      }
    }

    return attendanceList;
  }

  static List<MenuItem> getWeeklyMenu() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final breakfastItems = [
      'Paratha with Omelet',
      'Toast with Jam',
      'Pancakes with Syrup',
      'Cereal with Milk',
      'French Toast',
      'Sandwich',
      'Oatmeal with Fruits',
    ];

    final dinnerItems = [
      'Chicken Biryani',
      'Dal Rice with Vegetables',
      'Pasta with Sauce',
      'Fried Rice with Chicken',
      'Beef Curry with Rice',
      'Fish with Bread',
      'Pizza with Salad',
    ];

    final menuItems = <MenuItem>[];

    for (int day = 0; day < 7; day++) {
      final date = startOfWeek.add(Duration(days: day));

      // Breakfast
      menuItems.add(
        MenuItem(
          id: 'breakfast_$day',
          name: breakfastItems[day],
          description: 'Fresh and nutritious breakfast meal',
          price: 25.0 + (day * 2.0),
          category: 'breakfast',
          weekday: _getWeekdayName(day),
          nutritionalInfo: NutritionalInfo(
            calories: 350 + (day * 10).toDouble(),
            protein: 15.0,
            carbs: 45.0,
            fat: 8.0,
            fiber: 3.0,
            sodium: 300.0,
          ),
          mealType: MealType.breakfast,
          createdAt: date,
          createdBy: 'system',
          updatedAt: date,
          updatedBy: 'system',
        ),
      );

      // Dinner
      menuItems.add(
        MenuItem(
          id: 'dinner_$day',
          name: dinnerItems[day],
          description: 'Delicious and filling dinner meal',
          price: 45.0 + (day * 3.0),
          category: 'dinner',
          weekday: _getWeekdayName(day),
          nutritionalInfo: NutritionalInfo(
            calories: 500 + (day * 15).toDouble(),
            protein: 25.0,
            carbs: 60.0,
            fat: 12.0,
            fiber: 5.0,
            sodium: 450.0,
          ),
          mealType: MealType.dinner,
          createdAt: date,
          createdBy: 'system',
          updatedAt: date,
          updatedBy: 'system',
        ),
      );
    }

    return menuItems;
  }

  static List<MealRate> getMealRates() {
    return [
      MealRate(
        id: 'breakfast_rate',
        category: 'breakfast',
        rate: 25.0,
        effectiveFrom: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        createdBy: 'admin1',
        updatedAt: DateTime.now(),
        updatedBy: 'admin1',
        notes: 'Standard breakfast rate',
        mealType: MealType.breakfast,
      ),
      MealRate(
        id: 'dinner_rate',
        category: 'dinner',
        rate: 40.0,
        effectiveFrom: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        createdBy: 'admin1',
        updatedAt: DateTime.now(),
        updatedBy: 'admin1',
        notes: 'Standard dinner rate',
        mealType: MealType.dinner,
      ),
    ];
  }

  static List<Feedback> getFeedbacks() {
    return [
      Feedback(
        id: '1',
        studentId: '1',
        studentName: 'Ali Ahmed',
        rating: 4,
        comment: 'Great food quality and variety!',
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Food Quality',
      ),
      Feedback(
        id: '2',
        studentId: '2',
        studentName: 'Sara Khan',
        rating: 5,
        comment: 'Excellent service and clean environment.',
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Service',
      ),
      Feedback(
        id: '3',
        studentId: '4',
        studentName: 'Fatima Ali',
        rating: 3,
        comment: 'Food is okay but could be improved.',
        submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
        category: 'Food Quality',
      ),
    ];
  }

  static List<User> getUsers() {
    return [
      User(
        id: 'student1',
        name: 'Ali Ahmed',
        email: 'ali.ahmed@university.edu',
        role: UserRole.student,
      ),
      User(
        id: 'staff1',
        name: 'Muhammad Usman',
        email: 'usman@university.edu',
        role: UserRole.staff,
      ),
      User(
        id: 'admin1',
        name: 'Dr. Hassan Ali',
        email: 'hassan.ali@university.edu',
        role: UserRole.admin,
      ),
    ];
  }

  static Map<String, dynamic> getDashboardStats() {
    final students = getStudents();
    final attendance = getAttendance();
    final approvedStudents = students.where((s) => s.isApproved).length;
    final pendingApprovals = students.where((s) => !s.isApproved).length;

    final today = DateTime.now();
    final todayAttendance = attendance
        .where(
          (a) =>
              a.date.day == today.day &&
              a.date.month == today.month &&
              a.date.year == today.year,
        )
        .length;

    final monthlyRevenue = attendance.length * 32.5; // Average meal cost
    final attendanceRate = attendance.isEmpty
        ? 0.0
        : (attendance.where((a) => a.isPresent).length / attendance.length);

    return {
      'totalStudents': approvedStudents,
      'pendingApprovals': pendingApprovals,
      'todayAttendance': todayAttendance,
      'monthlyRevenue': monthlyRevenue,
      'attendanceRate': attendanceRate,
    };
  }

  /// Helper method to get weekday name from day index
  static String _getWeekdayName(int day) {
    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return weekdays[day % 7];
  }
}
