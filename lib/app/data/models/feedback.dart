class Feedback {
  final String id;
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime submittedAt;
  final String category;

  Feedback({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.submittedAt,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'rating': rating,
      'comment': comment,
      'submittedAt': submittedAt.toIso8601String(),
      'category': category,
    };
  }

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      rating: json['rating'],
      comment: json['comment'],
      submittedAt: DateTime.parse(json['submittedAt']),
      category: json['category'],
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
  }) {
    return Feedback(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      submittedAt: submittedAt ?? this.submittedAt,
      category: category ?? this.category,
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
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
      ),
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



