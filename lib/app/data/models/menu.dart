import 'package:cloud_firestore/cloud_firestore.dart';
import 'attendance.dart';

enum SpiceLevel { mild, medium, spicy }

// Nutritional Information Model
class NutritionalInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sodium;

  const NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sodium,
  });

  double get totalMacros => protein + carbs + fat;

  String get healthScore {
    // Simple health scoring algorithm
    double score = 0;
    if (protein >= 15) score += 25;
    if (carbs <= 60) score += 25;
    if (fat <= 30) score += 25;
    if (sodium <= 2300) score += 25;

    if (score >= 75) return 'Excellent';
    if (score >= 50) return 'Good';
    if (score >= 25) return 'Fair';
    return 'Poor';
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sodium': sodium,
    };
  }

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sodium: (json['sodium'] ?? 0).toDouble(),
    );
  }
}

// Enhanced MenuItem Model
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // breakfast, lunch, dinner
  final String weekday; // monday, tuesday, wednesday, etc.
  final NutritionalInfo nutritionalInfo;
  final String preparationTime;
  final SpiceLevel spiceLevel;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final MealType mealType; // For backward compatibility

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl = '',
    required this.category,
    required this.weekday,
    required this.nutritionalInfo,
    this.preparationTime = '15 mins',
    this.spiceLevel = SpiceLevel.mild,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isActive = true,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.mealType,
  });

  // Factory methods for Firestore
  factory MenuItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MenuItem.fromJson(data..['id'] = doc.id);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'breakfast',
      weekday: json['weekday'] ?? 'monday',
      nutritionalInfo: NutritionalInfo.fromJson(json['nutritionalInfo'] ?? {}),
      preparationTime: json['preparationTime'] ?? '15 mins',
      spiceLevel: SpiceLevel.values.firstWhere(
        (e) => e.name == (json['spiceLevel'] ?? 'mild'),
        orElse: () => SpiceLevel.mild,
      ),
      allergens: List<String>.from(json['allergens'] ?? []),
      isVegetarian: json['isVegetarian'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => MealType.breakfast,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'weekday': weekday,
      'nutritionalInfo': nutritionalInfo.toJson(),
      'preparationTime': preparationTime,
      'spiceLevel': spiceLevel.name,
      'allergens': allergens,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'weekday': weekday,
      'nutritionalInfo': nutritionalInfo.toJson(),
      'preparationTime': preparationTime,
      'spiceLevel': spiceLevel.name,
      'allergens': allergens,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt.toIso8601String(),
      'updatedBy': updatedBy,
      'mealType': mealType.name,
    };
  }

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? weekday,
    NutritionalInfo? nutritionalInfo,
    String? preparationTime,
    SpiceLevel? spiceLevel,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    MealType? mealType,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      weekday: weekday ?? this.weekday,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      preparationTime: preparationTime ?? this.preparationTime,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      mealType: mealType ?? this.mealType,
    );
  }
}

// Menu Template Model
class MenuItemTemplate {
  final String itemId;
  final String customName;
  final String customDescription;

  const MenuItemTemplate({
    required this.itemId,
    this.customName = '',
    this.customDescription = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'customName': customName,
      'customDescription': customDescription,
    };
  }

  factory MenuItemTemplate.fromJson(Map<String, dynamic> json) {
    return MenuItemTemplate(
      itemId: json['itemId'] ?? '',
      customName: json['customName'] ?? '',
      customDescription: json['customDescription'] ?? '',
    );
  }
}

class DayMenu {
  final MenuItemTemplate? breakfast;
  final MenuItemTemplate? lunch;
  final MenuItemTemplate? dinner;

  const DayMenu({this.breakfast, this.lunch, this.dinner});

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.toJson(),
      'lunch': lunch?.toJson(),
      'dinner': dinner?.toJson(),
    };
  }

  factory DayMenu.fromJson(Map<String, dynamic> json) {
    return DayMenu(
      breakfast: json['breakfast'] != null
          ? MenuItemTemplate.fromJson(json['breakfast'])
          : null,
      lunch: json['lunch'] != null
          ? MenuItemTemplate.fromJson(json['lunch'])
          : null,
      dinner: json['dinner'] != null
          ? MenuItemTemplate.fromJson(json['dinner'])
          : null,
    );
  }
}

class MenuTemplate {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final Map<String, DayMenu> meals; // monday, tuesday, etc.

  MenuTemplate({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.meals,
  });

  factory MenuTemplate.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MenuTemplate.fromJson(data..['id'] = doc.id);
  }

  factory MenuTemplate.fromJson(Map<String, dynamic> json) {
    final mealsData = json['meals'] as Map<String, dynamic>? ?? {};
    final meals = <String, DayMenu>{};

    for (final entry in mealsData.entries) {
      meals[entry.key] = DayMenu.fromJson(entry.value);
    }

    return MenuTemplate(
      id: json['id'],
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      meals: meals,
    );
  }

  Map<String, dynamic> toFirestore() {
    final mealsData = <String, dynamic>{};
    for (final entry in meals.entries) {
      mealsData[entry.key] = entry.value.toJson();
    }

    return {
      'name': name,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'meals': mealsData,
    };
  }
}

// Menu Override Model
class MenuOverride {
  final String itemId;
  final String customName;
  final String customDescription;
  final String reason;
  final String updatedBy;
  final DateTime updatedAt;

  MenuOverride({
    required this.itemId,
    required this.customName,
    required this.customDescription,
    required this.reason,
    required this.updatedBy,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'customName': customName,
      'customDescription': customDescription,
      'reason': reason,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MenuOverride.fromJson(Map<String, dynamic> json) {
    return MenuOverride(
      itemId: json['itemId'] ?? '',
      customName: json['customName'] ?? '',
      customDescription: json['customDescription'] ?? '',
      reason: json['reason'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// Active Menu Schedule Model
class ActiveMenuSchedule {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String templateId;
  final int weekNumber;
  final bool isActive;
  final Map<String, Map<String, MenuOverride>> overrides;
  final DateTime createdAt;
  final String createdBy;

  ActiveMenuSchedule({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.templateId,
    required this.weekNumber,
    required this.isActive,
    required this.overrides,
    required this.createdAt,
    required this.createdBy,
  });

  factory ActiveMenuSchedule.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ActiveMenuSchedule.fromJson(data..['id'] = doc.id);
  }

  factory ActiveMenuSchedule.fromJson(Map<String, dynamic> json) {
    final overridesData = json['overrides'] as Map<String, dynamic>? ?? {};
    final overrides = <String, Map<String, MenuOverride>>{};

    for (final dateEntry in overridesData.entries) {
      final mealOverrides = <String, MenuOverride>{};
      final mealData = dateEntry.value as Map<String, dynamic>? ?? {};

      for (final mealEntry in mealData.entries) {
        mealOverrides[mealEntry.key] = MenuOverride.fromJson(mealEntry.value);
      }

      overrides[dateEntry.key] = mealOverrides;
    }

    return ActiveMenuSchedule(
      id: json['id'],
      startDate: json['startDate'] is Timestamp
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: json['endDate'] is Timestamp
          ? (json['endDate'] as Timestamp).toDate()
          : DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      templateId: json['templateId'] ?? '',
      weekNumber: json['weekNumber'] ?? 1,
      isActive: json['isActive'] ?? true,
      overrides: overrides,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    final overridesData = <String, dynamic>{};
    for (final dateEntry in overrides.entries) {
      final mealData = <String, dynamic>{};
      for (final mealEntry in dateEntry.value.entries) {
        mealData[mealEntry.key] = mealEntry.value.toJson();
      }
      overridesData[dateEntry.key] = mealData;
    }

    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'templateId': templateId,
      'weekNumber': weekNumber,
      'isActive': isActive,
      'overrides': overridesData,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  // Helper methods
  MenuItem? getMenuForDate(
    DateTime date,
    String mealType,
    List<MenuItem> menuItems,
  ) {
    final dayKey = _formatDateKey(date);
    final override = overrides[dayKey]?[mealType];

    if (override != null) {
      return menuItems.firstWhere(
        (item) => item.id == override.itemId,
        orElse: () => menuItems.first,
      );
    }

    return null;
  }

  bool hasOverride(DateTime date, String mealType) {
    final dayKey = _formatDateKey(date);
    return overrides[dayKey]?.containsKey(mealType) ?? false;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Enhanced MealRate Model
class MealRate {
  final String id;
  final String category;
  final double rate;
  final DateTime effectiveFrom;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final String notes;
  final MealType mealType; // For backward compatibility

  MealRate({
    required this.id,
    required this.category,
    required this.rate,
    required this.effectiveFrom,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.notes,
    required this.mealType,
    required String updatedBy,
    required DateTime updatedAt,
  });

  factory MealRate.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MealRate.fromJson(data..['id'] = doc.id);
  }

  factory MealRate.fromJson(Map<String, dynamic> json) {
    return MealRate(
      id: json['id'],
      category: json['category'] ?? 'breakfast',
      rate: (json['rate'] ?? 0).toDouble(),
      effectiveFrom: json['effectiveFrom'] is Timestamp
          ? (json['effectiveFrom'] as Timestamp).toDate()
          : DateTime.tryParse(json['effectiveFrom'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
      notes: json['notes'] ?? '',
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => MealType.breakfast,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'rate': rate,
      'effectiveFrom': Timestamp.fromDate(effectiveFrom),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'notes': notes,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'rate': rate,
      'effectiveFrom': effectiveFrom.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'notes': notes,
      'mealType': mealType.name,
    };
  }

  MealRate copyWith({
    String? id,
    String? category,
    double? rate,
    DateTime? effectiveFrom,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    String? notes,
    MealType? mealType,
  }) {
    return MealRate(
      id: id ?? this.id,
      category: category ?? this.category,
      rate: rate ?? this.rate,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? DateTime.now(), // Always set to now when copying
      updatedBy: updatedBy ?? 'system', // Default value for system updates
      notes: notes ?? this.notes,
      mealType: mealType ?? this.mealType,
    );
  }

  // Helper method
  static MealRate? getCurrentRate(String category, List<MealRate> rates) {
    return rates
        .where((rate) => rate.category == category && rate.isActive)
        .fold<MealRate?>(null, (current, rate) {
          if (current == null ||
              rate.effectiveFrom.isAfter(current.effectiveFrom)) {
            return rate;
          }
          return current;
        });
  }
}

// Meal Category Model
class MealCategory {
  final String id;
  final String name;
  final int displayOrder;
  final bool isActive;
  final double defaultRate;
  final DateTime updatedAt;

  MealCategory({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.isActive,
    required this.defaultRate,
    required this.updatedAt,
  });

  factory MealCategory.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MealCategory.fromJson(data..['id'] = doc.id);
  }

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['id'],
      name: json['name'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      isActive: json['isActive'] ?? true,
      defaultRate: (json['defaultRate'] ?? 0).toDouble(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'defaultRate': defaultRate,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

// Menu Feedback Model
class MenuFeedback {
  final String id;
  final String studentId;
  final String menuItemId;
  final DateTime mealDate;
  final String mealType;
  final int rating; // 1-5 stars
  final String comment;
  final List<String> tags; // ["too_spicy", "loved_it", etc.]
  final DateTime submittedAt;

  MenuFeedback({
    required this.id,
    required this.studentId,
    required this.menuItemId,
    required this.mealDate,
    required this.mealType,
    required this.rating,
    required this.comment,
    required this.tags,
    required this.submittedAt,
  });

  factory MenuFeedback.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MenuFeedback.fromJson(data..['id'] = doc.id);
  }

  factory MenuFeedback.fromJson(Map<String, dynamic> json) {
    return MenuFeedback(
      id: json['id'],
      studentId: json['studentId'] ?? '',
      menuItemId: json['menuItemId'] ?? '',
      mealDate: json['mealDate'] is Timestamp
          ? (json['mealDate'] as Timestamp).toDate()
          : DateTime.tryParse(json['mealDate'] ?? '') ?? DateTime.now(),
      mealType: json['mealType'] ?? '',
      rating: json['rating'] ?? 1,
      comment: json['comment'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      submittedAt: json['submittedAt'] is Timestamp
          ? (json['submittedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['submittedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'menuItemId': menuItemId,
      'mealDate': Timestamp.fromDate(mealDate),
      'mealType': mealType,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}
