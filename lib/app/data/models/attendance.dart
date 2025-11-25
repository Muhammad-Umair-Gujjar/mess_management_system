enum MealType { breakfast, dinner }

class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final MealType mealType;
  final bool isPresent;
  final DateTime markedAt;
  final String markedBy;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.mealType,
    required this.isPresent,
    required this.markedAt,
    required this.markedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'mealType': mealType.name,
      'isPresent': isPresent,
      'markedAt': markedAt.toIso8601String(),
      'markedBy': markedBy,
    };
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['studentId'],
      date: DateTime.parse(json['date']),
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['mealType'],
      ),
      isPresent: json['isPresent'],
      markedAt: DateTime.parse(json['markedAt']),
      markedBy: json['markedBy'],
    );
  }

  Attendance copyWith({
    String? id,
    String? studentId,
    DateTime? date,
    MealType? mealType,
    bool? isPresent,
    DateTime? markedAt,
    String? markedBy,
  }) {
    return Attendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      isPresent: isPresent ?? this.isPresent,
      markedAt: markedAt ?? this.markedAt,
      markedBy: markedBy ?? this.markedBy,
    );
  }
}



