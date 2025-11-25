import 'attendance.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double calories;
  final String imageUrl;
  final MealType mealType;
  final DateTime date;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    this.imageUrl = '',
    required this.mealType,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
      'imageUrl': imageUrl,
      'mealType': mealType.name,
      'date': date.toIso8601String(),
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      calories: json['calories'].toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['mealType'],
      ),
      date: DateTime.parse(json['date']),
    );
  }

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? calories,
    String? imageUrl,
    MealType? mealType,
    DateTime? date,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      imageUrl: imageUrl ?? this.imageUrl,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
    );
  }
}

class MealRate {
  final String id;
  final MealType mealType;
  final double rate;
  final DateTime updatedAt;
  final String updatedBy;

  MealRate({
    required this.id,
    required this.mealType,
    required this.rate,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealType': mealType.name,
      'rate': rate,
      'updatedAt': updatedAt.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }

  factory MealRate.fromJson(Map<String, dynamic> json) {
    return MealRate(
      id: json['id'],
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['mealType'],
      ),
      rate: json['rate'].toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
      updatedBy: json['updatedBy'],
    );
  }

  MealRate copyWith({
    String? id,
    MealType? mealType,
    double? rate,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return MealRate(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      rate: rate ?? this.rate,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}



