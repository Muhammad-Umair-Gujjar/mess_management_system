enum MealType { breakfast, dinner }

class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final MealType mealType;
  final bool isPresent;
  final DateTime markedAt;
  final String markedBy;
  final String? menuItemId;
  final String? menuName;
  final double? menuPrice;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.mealType,
    required this.isPresent,
    required this.markedAt,
    required this.markedBy,
    this.menuItemId,
    this.menuName,
    this.menuPrice,
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
      'menuItemId': menuItemId,
      'menuName': menuName,
      'menuPrice': menuPrice,
    };
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['studentId'],
      date: DateTime.parse(json['date']),
      mealType: MealType.values.firstWhere((e) => e.name == json['mealType']),
      isPresent: json['isPresent'],
      markedAt: DateTime.parse(json['markedAt']),
      markedBy: json['markedBy'],
      menuItemId: json['menuItemId'],
      menuName: json['menuName'],
      menuPrice: json['menuPrice'] is num
          ? (json['menuPrice'] as num).toDouble()
          : double.tryParse(json['menuPrice']?.toString() ?? ''),
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
    String? menuItemId,
    String? menuName,
    double? menuPrice,
  }) {
    return Attendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      isPresent: isPresent ?? this.isPresent,
      markedAt: markedAt ?? this.markedAt,
      markedBy: markedBy ?? this.markedBy,
      menuItemId: menuItemId ?? this.menuItemId,
      menuName: menuName ?? this.menuName,
      menuPrice: menuPrice ?? this.menuPrice,
    );
  }
}
