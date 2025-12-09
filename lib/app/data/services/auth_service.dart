import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/auth_models.dart';

/// Exception class for authentication-related errors
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, [this.code]);

  @override
  String toString() => 'AuthException: $message';
}

/// Service class handling all Firebase Authentication and Firestore operations
/// for the three-tier authentication system (Student/Staff/Admin)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _usersCollection = 'users';
  static const String _studentRequestsCollection = 'student_requests';
  static const String _studentsCollection = 'students';
  static const String _staffCollection = 'staff';
  static const String _adminsCollection = 'admins';
  static const String _notificationsCollection = 'notifications';
  static const String _auditLogsCollection = 'audit_logs';

  /// Stream of authentication state changes
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  /// Get current Firebase user
  firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

  /// Get student data for a specific user ID
  Future<StudentData?> getStudentData(String uid) async {
    try {
      final doc = await _firestore
          .collection(_studentsCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return StudentData.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      // Error fetching student data: $e
      return null;
    }
  }

  /// Get current app user with role and status information
  Future<AppUser?> get currentUser async {
    final firebaseUser = currentFirebaseUser;
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) return null;

      return AppUser.fromFirestore(doc.data()!);
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  /// Check if current user is authenticated and approved
  Future<bool> get isAuthenticated async {
    final user = await currentUser;
    return user != null && user.isActive;
  }

  /// Student Signup - Creates request for admin approval
  Future<AuthResult> studentSignup(StudentSignupRequest request) async {
    try {
      // Check if email is already registered or has pending request
      final existingUser = await _getUserByEmail(request.email);
      if (existingUser != null) {
        return AuthResult.failure('Email already registered');
      }

      final existingRequest = await _getStudentRequestByEmail(request.email);
      if (existingRequest != null) {
        if (existingRequest.isPending) {
          return AuthResult.pending('Your request is pending admin approval');
        } else if (existingRequest.isRejected) {
          return AuthResult.failure(
            'Your previous request was rejected. Contact admin.',
          );
        }
      }

      // Check for duplicate roll number
      final duplicateRoll = await _getStudentRequestByRollNumber(
        request.rollNumber,
      );
      if (duplicateRoll != null) {
        return AuthResult.failure('Roll number already exists');
      }

      // Create student request
      final requestId = _firestore
          .collection(_studentRequestsCollection)
          .doc()
          .id;
      final studentRequest = StudentRequest(
        requestId: requestId,
        email: request.email,
        firstName: request.firstName,
        lastName: request.lastName,
        rollNumber: request.rollNumber,
        hostel: request.hostel,
        roomNumber: request.roomNumber,
        phoneNumber: request.phoneNumber,
        department: request.department,
        semester: request.semester,
        requestedAt: DateTime.now(),
        documents: request.documents,
      );

      await _firestore
          .collection(_studentRequestsCollection)
          .doc(requestId)
          .set(studentRequest.toFirestore());

      // Send notification to all admins
      await _notifyAdminsNewStudentRequest(studentRequest);

      // Log the request
      await _logActivity(
        action: 'student_signup_request',
        userId: null,
        details: {
          'email': request.email,
          'rollNumber': request.rollNumber,
          'requestId': requestId,
        },
      );

      return AuthResult.pending(
        'Signup request submitted successfully. You will be notified once approved.',
      );
    } catch (e) {
      return AuthResult.failure('Signup failed: ${e.toString()}');
    }
  }

  /// Staff/Admin Login - Direct authentication
  Future<AuthResult> staffAdminLogin(
    String email,
    String password,
    UserRole role,
  ) async {
    try {
      if (role == UserRole.student) {
        return AuthResult.failure('Students must use student login');
      }

      // Authenticate with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return AuthResult.failure('Authentication failed');
      }

      // Get user from Firestore
      final user = await _getUserById(credential.user!.uid);
      if (user == null) {
        await _auth.signOut(); // Sign out if user not found in database
        return AuthResult.failure('User not found. Contact administrator.');
      }

      // Verify role matches
      if (user.role != role) {
        await _auth.signOut();
        return AuthResult.failure('Invalid role selected');
      }

      // Check if user is active
      if (!user.isActive) {
        await _auth.signOut();
        return AuthResult.failure(
          'Account is inactive. Contact administrator.',
        );
      }

      // Update last login
      await _updateLastLogin(user.uid);

      // Log successful login
      await _logActivity(
        action: 'login_success',
        userId: user.uid,
        details: {'role': role.name, 'email': email},
      );

      return AuthResult.success(user, type: AuthResultType.success);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later.';
          break;
      }
      return AuthResult.failure(message, e.code);
    } catch (e) {
      return AuthResult.failure('Login failed: ${e.toString()}');
    }
  }

  /// Student Login - Check if approved and active
  Future<AuthResult> studentLogin(String email, String password) async {
    try {
      // First check if student is approved
      final user = await _getUserByEmail(email);
      if (user == null) {
        // Check if there's a pending request
        final request = await _getStudentRequestByEmail(email);
        if (request != null) {
          if (request.isPending) {
            return AuthResult.pending('Your account is pending approval');
          } else if (request.isRejected) {
            return AuthResult.failure('Your account request was rejected');
          }
        }
        return AuthResult.failure('Account not found. Please signup first.');
      }

      if (user.role != UserRole.student) {
        return AuthResult.failure('Please use staff/admin login');
      }

      if (!user.isActive) {
        return AuthResult.failure(
          'Account is not active. Contact administrator.',
        );
      }

      // Authenticate with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return AuthResult.failure('Authentication failed');
      }

      // Update last login
      await _updateLastLogin(user.uid);

      // Log successful login
      await _logActivity(
        action: 'login_success',
        userId: user.uid,
        details: {'role': UserRole.student.name, 'email': email},
      );

      return AuthResult.success(user, type: AuthResultType.success);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'Account not found. Please signup first.';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later.';
          break;
      }
      return AuthResult.failure(message, e.code);
    } catch (e) {
      return AuthResult.failure('Login failed: ${e.toString()}');
    }
  }

  /// Approve student request (Admin only)
  Future<bool> approveStudentRequest(
    String requestId,
    String adminId, {
    String? password,
  }) async {
    try {
      // Get the request
      final requestDoc = await _firestore
          .collection(_studentRequestsCollection)
          .doc(requestId)
          .get();

      if (!requestDoc.exists) {
        throw AuthException('Request not found');
      }

      final request = StudentRequest.fromFirestore(requestDoc.data()!);
      if (!request.isPending) {
        throw AuthException('Request already processed');
      }

      // Create Firebase user account
      final tempPassword = password ?? _generateTempPassword();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: request.email,
        password: tempPassword,
      );

      final uid = userCredential.user!.uid;

      // Create user record
      final user = AppUser(
        uid: uid,
        email: request.email,
        firstName: request.firstName,
        lastName: request.lastName,
        role: UserRole.student,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        isEmailVerified: false,
        createdBy: adminId,
      );

      // Create student details
      final studentDetails = StudentDetails(
        uid: uid,
        rollNumber: request.rollNumber,
        department: request.department,
        semester: request.semester,
        hostel: request.hostel,
        roomNumber: request.roomNumber,
        phoneNumber: '', // Use empty string since phone is not required
        batch: DateTime.now().year,
        approvedAt: DateTime.now(),
        approvedBy: adminId,
        academicInfo: AcademicInfo(
          fees: FeeInfo(total: 0, paid: 0, pending: 0),
        ),
      );

      // Batch write all records
      final batch = _firestore.batch();

      // Add user to users collection
      batch.set(
        _firestore.collection(_usersCollection).doc(uid),
        user.toFirestore(),
      );

      // Add student details
      batch.set(
        _firestore.collection(_studentsCollection).doc(uid),
        studentDetails.toFirestore(),
      );

      // Update request status
      batch.update(
        _firestore.collection(_studentRequestsCollection).doc(requestId),
        {
          'status': RequestStatus.approved.name,
          'processedAt': DateTime.now().toIso8601String(),
          'processedBy': adminId,
        },
      );

      await batch.commit();

      // Send approval notification to student
      await _sendNotification(
        userId: uid,
        type: 'account_approved',
        title: 'Account Approved!',
        message:
            'Your student account has been approved. You can now login with your email and the password sent to you.',
        data: {'requestId': requestId, 'tempPassword': tempPassword},
      );

      // Log the approval
      await _logActivity(
        action: 'student_request_approved',
        userId: adminId,
        details: {
          'requestId': requestId,
          'studentEmail': request.email,
          'studentUid': uid,
        },
      );


      return true;
    } catch (e) {
      throw AuthException('Failed to approve request: ${e.toString()}');
    }
  }

  /// Reject student request (Admin only)
  Future<bool> rejectStudentRequest(
    String requestId,
    String adminId,
    String reason,
  ) async {
    try {
      // Update request status
      await _firestore
          .collection(_studentRequestsCollection)
          .doc(requestId)
          .update({
            'status': RequestStatus.rejected.name,
            'processedAt': DateTime.now().toIso8601String(),
            'processedBy': adminId,
            'rejectionReason': reason,
          });

      // Get request details for notification
      final requestDoc = await _firestore
          .collection(_studentRequestsCollection)
          .doc(requestId)
          .get();

      if (requestDoc.exists) {
        final request = StudentRequest.fromFirestore(requestDoc.data()!);

        // Send rejection notification (external notification system)
        await _sendEmailNotification(
          email: request.email,
          subject: 'Student Account Request Rejected',
          message:
              'Your student account request has been rejected. Reason: $reason',
        );

        // Log the rejection
        await _logActivity(
          action: 'student_request_rejected',
          userId: adminId,
          details: {
            'requestId': requestId,
            'studentEmail': request.email,
            'reason': reason,
          },
        );
      }

      return true;
    } catch (e) {
      throw AuthException('Failed to reject request: ${e.toString()}');
    }
  }

  /// Get pending student requests (Admin only) - Alternative simple method
  Stream<List<StudentRequest>> getPendingStudentRequestsSimple() {
    // Using simple getPendingStudentRequestsSimple method...
    // Collection: $_studentRequestsCollection

    return _firestore.collection(_studentRequestsCollection).snapshots().map((
      snapshot,
    ) {
      // Simple method - Firestore snapshot received - ${snapshot.docs.length} total documents

      final allRequests = snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              // Document ID: ${doc.id}, Status: ${data['status']}
              return StudentRequest.fromFirestore(data);
            } catch (e) {
              // Error parsing document ${doc.id}: $e
              return null;
            }
          })
          .where((request) => request != null)
          .cast<StudentRequest>()
          .toList();

      // Filter for pending requests in code
      final pendingRequests = allRequests
          .where((request) => request.status == RequestStatus.pending)
          .toList();

      // Sort by requestedAt in code
      pendingRequests.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      // Filtered to ${pendingRequests.length} pending requests out of ${allRequests.length} total

      return pendingRequests;
    });
  }

  /// Get pending student requests (Admin only)
  /// Fixed: Removed orderBy to avoid Firestore composite index requirement
  Stream<List<StudentRequest>> getPendingStudentRequests() {
    // Setting up getPendingStudentRequests stream...
    // Collection: $_studentRequestsCollection
    // Looking for status: ${RequestStatus.pending.name}

    return _firestore
        .collection(_studentRequestsCollection)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .snapshots()
        .map((snapshot) {
          // Firestore snapshot received - ${snapshot.docs.length} documents

          for (var doc in snapshot.docs) {
            final data = doc.data();
            // Document ID: ${doc.id}
            // Document data: $data
            // Status field: ${data['status']}
          }

          final requests = snapshot.docs
              .map((doc) {
                try {
                  return StudentRequest.fromFirestore(doc.data());
                } catch (e) {
                  // Error parsing document ${doc.id}: $e
                  return null;
                }
              })
              .where((request) => request != null)
              .cast<StudentRequest>()
              .toList();

          // Sort by requestedAt in code instead of Firestore
          requests.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

          print(
            '🔵 DEBUG: Successfully parsed ${requests.length} StudentRequest objects',
          );
          return requests;
        });
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final user = await currentUser;
      if (user != null) {
        await _logActivity(
          action: 'logout',
          userId: user.uid,
          details: {'logoutTime': DateTime.now().toIso8601String()},
        );
      }
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthException('No account found with this email');
        case 'invalid-email':
          throw AuthException('Invalid email address');
        default:
          throw AuthException('Failed to send reset email: ${e.message}');
      }
    }
  }

  /// Create staff account (Super Admin only)
  Future<bool> createStaffAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String employeeId,
    required String department,
    required String position,
    String phoneNumber = '', // Make optional
    required String password,
    required String createdByAdminId,
    List<String> permissions = const [],
  }) async {
    try {
      // Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Create user record
      final user = AppUser(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: UserRole.staff,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        isEmailVerified: false,
        createdBy: createdByAdminId,
      );

      // Create staff details
      final staffDetails = StaffDetails(
        uid: uid,
        employeeId: employeeId,
        department: department,
        position: position,
        joiningDate: DateTime.now(),
        phoneNumber: phoneNumber,
        permissions: permissions,
      );

      // Batch write
      final batch = _firestore.batch();

      batch.set(
        _firestore.collection(_usersCollection).doc(uid),
        user.toFirestore(),
      );

      batch.set(
        _firestore.collection(_staffCollection).doc(uid),
        staffDetails.toFirestore(),
      );

      await batch.commit();

      await _logActivity(
        action: 'staff_account_created',
        userId: createdByAdminId,
        details: {
          'staffUid': uid,
          'staffEmail': email,
          'employeeId': employeeId,
        },
      );

      // Sign out the temp user
      await _auth.signOut();

      return true;
    } catch (e) {
      throw AuthException('Failed to create staff account: ${e.toString()}');
    }
  }

  /// Helper Methods

  Future<AppUser?> _getUserById(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    return doc.exists ? AppUser.fromFirestore(doc.data()!) : null;
  }

  Future<AppUser?> _getUserByEmail(String email) async {
    final query = await _firestore
        .collection(_usersCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return query.docs.isNotEmpty
        ? AppUser.fromFirestore(query.docs.first.data())
        : null;
  }

  Future<StudentRequest?> _getStudentRequestByEmail(String email) async {
    final query = await _firestore
        .collection(_studentRequestsCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return query.docs.isNotEmpty
        ? StudentRequest.fromFirestore(query.docs.first.data())
        : null;
  }

  Future<StudentRequest?> _getStudentRequestByRollNumber(
    String rollNumber,
  ) async {
    final query = await _firestore
        .collection(_studentRequestsCollection)
        .where('rollNumber', isEqualTo: rollNumber)
        .limit(1)
        .get();

    return query.docs.isNotEmpty
        ? StudentRequest.fromFirestore(query.docs.first.data())
        : null;
  }

  Future<void> _updateLastLogin(String uid) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'lastLoginAt': DateTime.now().toIso8601String(),
    });
  }

  String _generateTempPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(8, (index) => chars[random % chars.length]).join();
  }

  Future<void> _notifyAdminsNewStudentRequest(StudentRequest request) async {
    // Get all admins
    final adminsQuery = await _firestore
        .collection(_usersCollection)
        .where('role', isEqualTo: UserRole.admin.name)
        .where('status', isEqualTo: UserStatus.active.name)
        .get();

    final batch = _firestore.batch();

    for (final doc in adminsQuery.docs) {
      final notificationRef = _firestore
          .collection(_notificationsCollection)
          .doc();
      final notification = AppNotification(
        id: notificationRef.id,
        type: 'new_student_request',
        targetUserId: doc.id,
        title: 'New Student Request',
        message:
            '${request.fullName} (${request.rollNumber}) has requested an account',
        createdAt: DateTime.now(),
        data: {
          'requestId': request.requestId,
          'studentEmail': request.email,
          'rollNumber': request.rollNumber,
        },
      );

      batch.set(notificationRef, notification.toFirestore());
    }

    await batch.commit();
  }

  Future<void> _sendNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    final notificationRef = _firestore
        .collection(_notificationsCollection)
        .doc();
    final notification = AppNotification(
      id: notificationRef.id,
      type: type,
      targetUserId: userId,
      title: title,
      message: message,
      createdAt: DateTime.now(),
      data: data,
    );

    await notificationRef.set(notification.toFirestore());
  }

  Future<void> _sendEmailNotification({
    required String email,
    required String subject,
    required String message,
  }) async {
    // Implement external email service integration
    // This could use Firebase Cloud Functions, SendGrid, etc.
    // Email to $email: $subject - $message
  }

  Future<void> _logActivity({
    required String action,
    String? userId,
    Map<String, dynamic>? details,
  }) async {
    await _firestore.collection(_auditLogsCollection).add({
      'action': action,
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'details': details ?? {},
    });
  }

  /// Create default staff/admin account (for initial setup)
  Future<bool> createDefaultStaffAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String department,
  }) async {
    try {
      // Check if account already exists
      final existingUser = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .get();

      if (existingUser.docs.isNotEmpty) {
        // Default account $email already exists
        return true;
      }

      // Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Create user record
      final user = AppUser(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        isEmailVerified: true, // Default accounts are pre-verified
        createdBy: 'system',
      );

      // Save to users collection
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .set(user.toFirestore());

      // Create role-specific details
      if (role == UserRole.admin) {
        final adminDetails = AdminDetails(
          uid: uid,
          adminLevel: 'super',
          permissions: ['manage_users', 'manage_system', 'view_reports'],
          canApproveStudents: true,
          canManageStaff: true,
          lastActivity: DateTime.now(),
        );

        await _firestore
            .collection(_adminsCollection)
            .doc(uid)
            .set(adminDetails.toFirestore());
      } else if (role == UserRole.staff) {
        final staffDetails = StaffDetails(
          uid: uid,
          employeeId: 'STAFF001',
          department: department,
          position: 'Staff Member',
          joiningDate: DateTime.now(),
          permissions: ['manage_attendance', 'view_reports'],
          phoneNumber: '',
        );

        await _firestore
            .collection(_staffCollection)
            .doc(uid)
            .set(staffDetails.toFirestore());
      }

      await _logActivity(
        action: 'DEFAULT_ACCOUNT_CREATED',
        userId: uid,
        details: {
          'email': email,
          'role': role.name,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      print('✅ DEBUG: Default account created: $email');
      return true;
    } catch (e) {
      print('❌ DEBUG: Failed to create default account $email: $e');
      return false;
    }
  }

  /// Get total users count
  Future<int> getTotalUsersCount() async {
    try {
      final snapshot = await _firestore.collection(_usersCollection).get();
      return snapshot.docs.length;
    } catch (e) {
      print('❌ DEBUG: Error getting total users count: $e');
      return 0;
    }
  }

  /// Get total students count
  Future<int> getTotalStudentsCount() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'student')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('❌ DEBUG: Error getting total students count: $e');
      return 0;
    }
  }

  /// Get total staff count (including admins)
  Future<int> getTotalStaffCount() async {
    try {
      final staffSnapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'staff')
          .get();

      final adminSnapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'admin')
          .get();

      return staffSnapshot.docs.length + adminSnapshot.docs.length;
    } catch (e) {
      print('❌ DEBUG: Error getting total staff count: $e');
      return 0;
    }
  }
}
