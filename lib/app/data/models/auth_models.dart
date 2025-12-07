import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// Enhanced User Status Enum
enum UserStatus { pending, approved, active, suspended, rejected }

// User Role Enum (from your existing feedback.dart)
enum UserRole { student, staff, admin }

// Request Status for student applications
enum RequestStatus { pending, approved, rejected }

// Student Data Model for additional student information
class StudentData {
  final String uid;
  final String hostel;
  final String roomNumber;
  final String department;
  final String? parentContact;
  final String? phoneNumber;
  final String rollNumber;
  final int batch;
  final int semester;
  final DateTime approvedAt;
  final String approvedBy;
  final String? address;

  StudentData({
    required this.uid,
    required this.hostel,
    required this.roomNumber,
    required this.department,
    this.parentContact,
    this.phoneNumber,
    required this.rollNumber,
    required this.batch,
    required this.semester,
    required this.approvedAt,
    required this.approvedBy,
    this.address,
  });

  factory StudentData.fromFirestore(Map<String, dynamic> data) {
    return StudentData(
      uid: data['uid'] ?? '',
      hostel: data['hostel'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      department: data['department'] ?? '',
      parentContact: data['parentContact'],
      phoneNumber: data['phoneNumber'],
      rollNumber: data['rollNumber'] ?? '',
      batch: data['batch'] ?? 0,
      semester: data['semester'] ?? 1,
      approvedAt: DateTime.parse(
        data['approvedAt'] ?? DateTime.now().toIso8601String(),
      ),
      approvedBy: data['approvedBy'] ?? '',
      address: data['address'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'hostel': hostel,
      'roomNumber': roomNumber,
      'department': department,
      'parentContact': parentContact,
      'phoneNumber': phoneNumber,
      'rollNumber': rollNumber,
      'batch': batch,
      'semester': semester,
      'approvedAt': approvedAt.toIso8601String(),
      'approvedBy': approvedBy,
      'address': address,
    };
  }
}

// Enhanced App User Model
class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final UserStatus status;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final String? createdBy; // Admin who approved this user

  AppUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
    required this.isEmailVerified,
    this.createdBy,
  });

  String get fullName => '$firstName $lastName';
  String get displayEmail => email;
  bool get isActive => status == UserStatus.active;
  bool get isPending => status == UserStatus.pending;

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.name,
      'status': status.name,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'createdBy': createdBy,
    };
  }

  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.student,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => UserStatus.pending,
      ),
      profileImageUrl: data['profileImageUrl'],
      createdAt: DateTime.parse(
        data['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      lastLoginAt: data['lastLoginAt'] != null
          ? DateTime.parse(data['lastLoginAt'])
          : null,
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdBy: data['createdBy'],
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    UserStatus? status,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    String? createdBy,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

// Student Request Model (for signup approval)
class StudentRequest {
  final String requestId;
  final String email;
  final String firstName;
  final String lastName;
  final String rollNumber;
  final String hostel;
  final String roomNumber;
  final String phoneNumber; // Keep but make optional
  final String department;
  final int semester;
  final RequestStatus status;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? rejectionReason;
  final Map<String, String>? documents;

  StudentRequest({
    required this.requestId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.rollNumber,
    required this.hostel,
    required this.roomNumber,
    this.phoneNumber = '', // Default to empty string
    required this.department,
    required this.semester,
    this.status = RequestStatus.pending,
    required this.requestedAt,
    this.processedAt,
    this.processedBy,
    this.rejectionReason,
    this.documents,
  });

  String get fullName => '$firstName $lastName';
  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;

  Map<String, dynamic> toFirestore() {
    return {
      'requestId': requestId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'rollNumber': rollNumber,
      'hostel': hostel,
      'roomNumber': roomNumber,
      'phoneNumber': phoneNumber,
      'department': department,
      'semester': semester,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'processedBy': processedBy,
      'rejectionReason': rejectionReason,
      'documents': documents ?? {},
    };
  }

  factory StudentRequest.fromFirestore(Map<String, dynamic> data) {
    return StudentRequest(
      requestId: data['requestId'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      hostel: data['hostel'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? 1,
      status: RequestStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => RequestStatus.pending,
      ),
      requestedAt: DateTime.parse(
        data['requestedAt'] ?? DateTime.now().toIso8601String(),
      ),
      processedAt: data['processedAt'] != null
          ? DateTime.parse(data['processedAt'])
          : null,
      processedBy: data['processedBy'],
      rejectionReason: data['rejectionReason'],
      documents: Map<String, String>.from(data['documents'] ?? {}),
    );
  }

  StudentRequest copyWith({
    String? requestId,
    String? email,
    String? firstName,
    String? lastName,
    String? rollNumber,
    String? hostel,
    String? roomNumber,
    String? phoneNumber,
    String? department,
    int? semester,
    RequestStatus? status,
    DateTime? requestedAt,
    DateTime? processedAt,
    String? processedBy,
    String? rejectionReason,
    Map<String, String>? documents,
  }) {
    return StudentRequest(
      requestId: requestId ?? this.requestId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      rollNumber: rollNumber ?? this.rollNumber,
      hostel: hostel ?? this.hostel,
      roomNumber: roomNumber ?? this.roomNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      documents: documents ?? this.documents,
    );
  }
}

// Student Details (for approved students)
class StudentDetails {
  final String uid;
  final String rollNumber;
  final String department;
  final int semester;
  final String hostel;
  final String roomNumber;
  final String phoneNumber; // Keep but make optional
  final int batch;
  final String? parentContact;
  final String? address;
  final DateTime approvedAt;
  final String approvedBy;
  final AcademicInfo? academicInfo;

  StudentDetails({
    required this.uid,
    required this.rollNumber,
    required this.department,
    required this.semester,
    required this.hostel,
    required this.roomNumber,
    this.phoneNumber = '', // Default to empty string
    required this.batch,
    this.parentContact,
    this.address,
    required this.approvedAt,
    required this.approvedBy,
    this.academicInfo,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'rollNumber': rollNumber,
      'department': department,
      'semester': semester,
      'hostel': hostel,
      'roomNumber': roomNumber,
      'phoneNumber': phoneNumber,
      'batch': batch,
      'parentContact': parentContact,
      'address': address,
      'approvedAt': approvedAt.toIso8601String(),
      'approvedBy': approvedBy,
      'academicInfo': academicInfo?.toMap(),
    };
  }

  factory StudentDetails.fromFirestore(Map<String, dynamic> data) {
    return StudentDetails(
      uid: data['uid'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? 1,
      hostel: data['hostel'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      batch: data['batch'] ?? DateTime.now().year,
      parentContact: data['parentContact'],
      address: data['address'],
      approvedAt: DateTime.parse(
        data['approvedAt'] ?? DateTime.now().toIso8601String(),
      ),
      approvedBy: data['approvedBy'] ?? '',
      academicInfo: data['academicInfo'] != null
          ? AcademicInfo.fromMap(data['academicInfo'])
          : null,
    );
  }
}

// Academic Information
class AcademicInfo {
  final double? cgpa;
  final double? attendance;
  final FeeInfo fees;

  AcademicInfo({this.cgpa, this.attendance, required this.fees});

  Map<String, dynamic> toMap() {
    return {'cgpa': cgpa, 'attendance': attendance, 'fees': fees.toMap()};
  }

  factory AcademicInfo.fromMap(Map<String, dynamic> map) {
    return AcademicInfo(
      cgpa: map['cgpa']?.toDouble(),
      attendance: map['attendance']?.toDouble(),
      fees: FeeInfo.fromMap(map['fees'] ?? {}),
    );
  }
}

// Fee Information
class FeeInfo {
  final double total;
  final double paid;
  final double pending;

  FeeInfo({required this.total, required this.paid, required this.pending});

  Map<String, dynamic> toMap() {
    return {'total': total, 'paid': paid, 'pending': pending};
  }

  factory FeeInfo.fromMap(Map<String, dynamic> map) {
    return FeeInfo(
      total: (map['total'] ?? 0).toDouble(),
      paid: (map['paid'] ?? 0).toDouble(),
      pending: (map['pending'] ?? 0).toDouble(),
    );
  }
}

// Staff Details
class StaffDetails {
  final String uid;
  final String employeeId;
  final String department;
  final String position;
  final DateTime joiningDate;
  final double? salary;
  final String phoneNumber; // Keep but make optional
  final List<String> permissions;

  StaffDetails({
    required this.uid,
    required this.employeeId,
    required this.department,
    required this.position,
    required this.joiningDate,
    this.salary,
    this.phoneNumber = '', // Default to empty string
    this.permissions = const [],
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'employeeId': employeeId,
      'department': department,
      'position': position,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
      'phoneNumber': phoneNumber,
      'permissions': permissions,
    };
  }

  factory StaffDetails.fromFirestore(Map<String, dynamic> data) {
    return StaffDetails(
      uid: data['uid'] ?? '',
      employeeId: data['employeeId'] ?? '',
      department: data['department'] ?? '',
      position: data['position'] ?? '',
      joiningDate: DateTime.parse(
        data['joiningDate'] ?? DateTime.now().toIso8601String(),
      ),
      salary: data['salary']?.toDouble(),
      phoneNumber: data['phoneNumber'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
    );
  }
}

// Admin Details
class AdminDetails {
  final String uid;
  final String adminLevel; // 'super' or 'standard'
  final List<String> permissions;
  final bool canApproveStudents;
  final bool canManageStaff;
  final DateTime? lastActivity;

  AdminDetails({
    required this.uid,
    required this.adminLevel,
    this.permissions = const [],
    this.canApproveStudents = true,
    this.canManageStaff = true,
    this.lastActivity,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'adminLevel': adminLevel,
      'permissions': permissions,
      'canApproveStudents': canApproveStudents,
      'canManageStaff': canManageStaff,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  factory AdminDetails.fromFirestore(Map<String, dynamic> data) {
    return AdminDetails(
      uid: data['uid'] ?? '',
      adminLevel: data['adminLevel'] ?? 'standard',
      permissions: List<String>.from(data['permissions'] ?? []),
      canApproveStudents: data['canApproveStudents'] ?? true,
      canManageStaff: data['canManageStaff'] ?? true,
      lastActivity: data['lastActivity'] != null
          ? DateTime.parse(data['lastActivity'])
          : null,
    );
  }
}

// Notification Model
class AppNotification {
  final String id;
  final String type;
  final String targetUserId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.type,
    required this.targetUserId,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'targetUserId': targetUserId,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'data': data ?? {},
    };
  }

  factory AppNotification.fromFirestore(String id, Map<String, dynamic> data) {
    return AppNotification(
      id: id,
      type: data['type'] ?? '',
      targetUserId: data['targetUserId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.parse(
        data['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      data: Map<String, dynamic>.from(data['data'] ?? {}),
    );
  }
}

// Authentication Response Models
class AuthResult {
  final bool success;
  final AppUser? user;
  final String? errorMessage;
  final String? errorCode;
  final AuthResultType? type;

  AuthResult({
    required this.success,
    this.user,
    this.errorMessage,
    this.errorCode,
    this.type,
  });

  factory AuthResult.success(AppUser user, {AuthResultType? type}) {
    return AuthResult(success: true, user: user, type: type);
  }

  factory AuthResult.failure(String message, [String? code]) {
    return AuthResult(success: false, errorMessage: message, errorCode: code);
  }

  factory AuthResult.pending(String message) {
    return AuthResult(
      success: false,
      errorMessage: message,
      type: AuthResultType.pending,
    );
  }
}

enum AuthResultType { success, pending, rejected, inactive }

// Student Signup Request Model
class StudentSignupRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String rollNumber;
  final String hostel;
  final String roomNumber;
  final String phoneNumber; // Keep but make it optional
  final String department;
  final int semester;
  final Map<String, String>? documents;

  StudentSignupRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.rollNumber,
    required this.hostel,
    required this.roomNumber,
    this.phoneNumber = '', // Default to empty string
    required this.department,
    required this.semester,
    this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'rollNumber': rollNumber,
      'hostel': hostel,
      'roomNumber': roomNumber,
      'phoneNumber': phoneNumber,
      'department': department,
      'semester': semester,
      'documents': documents ?? {},
    };
  }
}

// Login Request Model
class LoginRequest {
  final String email;
  final String password;
  final UserRole role;

  LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'role': role.name};
  }
}
