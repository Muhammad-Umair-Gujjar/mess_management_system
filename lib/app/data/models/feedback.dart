import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  final String id;
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime submittedAt;
  final String category;
  final String status;
  final String? response;

  Feedback({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.submittedAt,
    required this.category,
    this.status = 'pending',
    this.response,
  });

  factory Feedback.fromFirestore(String id, Map<String, dynamic> data) {
    return Feedback(
      id: id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      rating: data['rating'] ?? 1,
      comment: data['comment'] ?? '',
      submittedAt: _parseDateTime(data['submittedAt']),
      category: data['category'] ?? 'Other',
      status: data['status'] ?? 'pending',
      response: data['response'],
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'rating': rating,
      'comment': comment,
      'submittedAt': submittedAt.toIso8601String(),
      'category': category,
      'status': status,
      'response': response,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'rating': rating,
      'comment': comment,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'category': category,
      'status': status,
      'response': response,
    };
  }

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      rating: json['rating'] ?? 1,
      comment: json['comment'] ?? '',
      submittedAt: _parseDateTime(json['submittedAt']),
      category: json['category'] ?? 'Other',
      status: json['status'] ?? 'pending',
      response: json['response'],
    );
  }

  Feedback copyWith({
    String? id,
    String? studentId,
    String? studentName,
    int? rating,
    String? comment,
    DateTime? submittedAt,
    String? category,
    String? status,
    String? response,
  }) {
    return Feedback(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      submittedAt: submittedAt ?? this.submittedAt,
      category: category ?? this.category,
      status: status ?? this.status,
      response: response ?? this.response,
    );
  }
}

enum UserRole { student, staff, admin }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String profileImage;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage = '',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'profileImage': profileImage,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      profileImage: json['profileImage'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? profileImage,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
    );
  }
}
