import 'package:cloud_firestore/cloud_firestore.dart';

class BillLineItem {
  final DateTime date;
  final String mealType;
  final String? menuItemId;
  final String menuName;
  final double unitPrice;
  final String pricingSource;

  BillLineItem({
    required this.date,
    required this.mealType,
    this.menuItemId,
    required this.menuName,
    required this.unitPrice,
    required this.pricingSource,
  });

  factory BillLineItem.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'];
    final parsedDate = rawDate is Timestamp
        ? rawDate.toDate()
        : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();

    return BillLineItem(
      date: parsedDate,
      mealType: json['mealType'] ?? '',
      menuItemId: json['menuItemId'],
      menuName: json['menuName'] ?? 'Meal',
      unitPrice: (json['unitPrice'] is num)
          ? (json['unitPrice'] as num).toDouble()
          : double.tryParse(json['unitPrice']?.toString() ?? '') ?? 0,
      pricingSource: json['pricingSource'] ?? 'rate',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'mealType': mealType,
      'menuItemId': menuItemId,
      'menuName': menuName,
      'unitPrice': unitPrice,
      'pricingSource': pricingSource,
    };
  }
}

class MonthlyBillRecord {
  final String id;
  final String monthId;
  final String studentUid;
  final String studentName;
  final String studentEmail;
  final String rollNumber;
  final String hostel;
  final String roomNumber;
  final int presentMeals;
  final int breakfastCount;
  final int dinnerCount;
  final double totalAmount;
  final String status;
  final DateTime generatedAt;
  final DateTime updatedAt;
  final List<BillLineItem> items;

  MonthlyBillRecord({
    required this.id,
    required this.monthId,
    required this.studentUid,
    required this.studentName,
    required this.studentEmail,
    required this.rollNumber,
    required this.hostel,
    required this.roomNumber,
    required this.presentMeals,
    required this.breakfastCount,
    required this.dinnerCount,
    required this.totalAmount,
    required this.status,
    required this.generatedAt,
    required this.updatedAt,
    required this.items,
  });

  factory MonthlyBillRecord.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    final rawItems = data['items'];
    final parsedItems = <BillLineItem>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map) {
          parsedItems.add(
            BillLineItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return MonthlyBillRecord(
      id: id,
      monthId: data['monthId'] ?? '',
      studentUid: data['studentUid'] ?? '',
      studentName: data['studentName'] ?? '',
      studentEmail: data['studentEmail'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      hostel: data['hostel'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      presentMeals: data['presentMeals'] ?? 0,
      breakfastCount: data['breakfastCount'] ?? 0,
      dinnerCount: data['dinnerCount'] ?? 0,
      totalAmount: (data['totalAmount'] is num)
          ? (data['totalAmount'] as num).toDouble()
          : double.tryParse(data['totalAmount']?.toString() ?? '') ?? 0,
      status: data['status'] ?? 'generated',
      generatedAt: parseDate(data['generatedAt']),
      updatedAt: parseDate(data['updatedAt']),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'monthId': monthId,
      'studentUid': studentUid,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'rollNumber': rollNumber,
      'hostel': hostel,
      'roomNumber': roomNumber,
      'presentMeals': presentMeals,
      'breakfastCount': breakfastCount,
      'dinnerCount': dinnerCount,
      'totalAmount': totalAmount,
      'status': status,
      'generatedAt': Timestamp.fromDate(generatedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'items': items.map((item) => item.toFirestore()).toList(),
    };
  }
}
