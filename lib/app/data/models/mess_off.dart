import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a "mess off" period for a student, during which they are not
/// eating in the mess. When a student is mess-off on a given date, the staff
/// attendance page should NOT show the Present/Absent toggle for that student.
class MessOff {
  final String id;
  final String studentUid;
  final DateTime startDate;
  final DateTime endDate;
  final String? setByUid;
  final DateTime createdAt;

  /// Specific meals this mess-off applies to.
  /// Empty list means all meals (breakfast, lunch, dinner).
  final List<String> meals;

  MessOff({
    required this.id,
    required this.studentUid,
    required this.startDate,
    required this.endDate,
    this.setByUid,
    required this.createdAt,
    this.meals = const [],
  });

  factory MessOff.fromFirestore(Map<String, dynamic> data, String id) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return MessOff(
      id: id,
      studentUid: data['studentUid'] as String? ?? '',
      startDate: parseDate(data['startDate']),
      endDate: parseDate(data['endDate']),
      setByUid: data['setByUid'] as String?,
      createdAt: parseDate(data['createdAt']),
      meals: List<String>.from(data['meals'] as List? ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentUid': studentUid,
      'startDate': Timestamp.fromDate(
        DateTime(startDate.year, startDate.month, startDate.day),
      ),
      'endDate': Timestamp.fromDate(
        DateTime(endDate.year, endDate.month, endDate.day),
      ),
      if (setByUid != null) 'setByUid': setByUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'meals': meals,
    };
  }

  /// Returns true if this mess-off period covers [date].
  bool isActiveOnDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  /// Returns true if this mess-off covers [date] AND applies to [meal].
  /// If [meals] is empty, it applies to all meals.
  bool isActiveForMeal(DateTime date, String meal) {
    if (!isActiveOnDate(date)) return false;
    if (meals.isEmpty) return true;
    return meals.contains(meal.toLowerCase());
  }
}
