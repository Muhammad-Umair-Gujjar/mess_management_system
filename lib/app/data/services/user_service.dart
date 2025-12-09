import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/auth_models.dart';

/// Service class for managing user data operations with Firebase Firestore
class UserService extends GetxService {
  static UserService get instance => Get.find<UserService>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String staffCollection = 'staff';

  /// Fetch all users (students and staff only) from Firebase
  Future<List<AppUser>> getAllUsers() async {
    try {
      // UserService: Fetching all users from Firebase...

      // First try the whereIn query
      try {
        final QuerySnapshot usersSnapshot = await _firestore
            .collection(usersCollection)
            .where('role', whereIn: ['student', 'staff'])
            .get();

        return _processUserQuerySnapshot(usersSnapshot);
      } catch (e) {
        print(
          '⚠️ UserService: whereIn query failed, trying separate queries: $e',
        );

        // Fallback: Use separate queries for students and staff
        final List<AppUser> allUsers = [];

        // Query students
        final studentsSnapshot = await _firestore
            .collection(usersCollection)
            .where('role', isEqualTo: 'student')
            .get();

        allUsers.addAll(_processUserQuerySnapshot(studentsSnapshot));

        // Query staff
        final staffSnapshot = await _firestore
            .collection(usersCollection)
            .where('role', isEqualTo: 'staff')
            .get();

        allUsers.addAll(_processUserQuerySnapshot(staffSnapshot));

        // Sort by createdAt on the client side
        allUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        print(
          '✅ UserService: Successfully loaded ${allUsers.length} users using fallback method',
        );
        return allUsers;
      }
    } catch (e) {
      print('❌ UserService: Error fetching users: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }

  /// Helper method to process user query snapshots
  List<AppUser> _processUserQuerySnapshot(QuerySnapshot snapshot) {
    final List<AppUser> users = [];

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>;
        final user = AppUser.fromFirestore(data);
        users.add(user);
        // UserService: Loaded user: ${user.fullName} (${user.role.name})
      } catch (e) {
        print('❌ UserService: Error parsing user data for doc ${doc.id}: $e');
      }
    }

    return users;
  }

  /// Fetch users by role (student or staff)
  Future<List<AppUser>> getUsersByRole(UserRole role) async {
    try {
      // UserService: Fetching ${role.name} users...

      if (role == UserRole.admin) {
        print(
          '⚠️ UserService: Admin users are not displayed in user management',
        );
        return [];
      }

      // Use simple query without orderBy to avoid index requirement
      final QuerySnapshot snapshot = await _firestore
          .collection(usersCollection)
          .where('role', isEqualTo: role.name)
          .get();

      final List<AppUser> users = [];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final user = AppUser.fromFirestore(data);
          users.add(user);
        } catch (e) {
          print(
            '❌ UserService: Error parsing ${role.name} data for doc ${doc.id}: $e',
          );
        }
      }

      // Sort by createdAt on the client side
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print(
        '✅ UserService: Successfully loaded ${users.length} ${role.name} users',
      );
      return users;
    } catch (e) {
      print('❌ UserService: Error fetching ${role.name} users: $e');
      throw Exception('Failed to fetch ${role.name} users: $e');
    }
  }

  /// Get student-specific data for a user
  Future<StudentData?> getStudentData(String uid) async {
    try {
      // UserService: Fetching student data for uid: $uid

      final DocumentSnapshot doc = await _firestore
          .collection(studentsCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        print('⚠️ UserService: No student data found for uid: $uid');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final studentData = StudentData.fromFirestore(data);

      print(
        '✅ UserService: Successfully loaded student data for: ${studentData.rollNumber}',
      );
      return studentData;
    } catch (e) {
      print('❌ UserService: Error fetching student data for uid $uid: $e');
      return null;
    }
  }

  /// Get staff-specific data for a user
  Future<StaffDetails?> getStaffData(String uid) async {
    try {
      // UserService: Fetching staff data for uid: $uid

      final DocumentSnapshot doc = await _firestore
          .collection(staffCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        print('⚠️ UserService: No staff data found for uid: $uid');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final staffData = StaffDetails.fromFirestore(data);

      print(
        '✅ UserService: Successfully loaded staff data for: ${staffData.employeeId}',
      );
      return staffData;
    } catch (e) {
      print('❌ UserService: Error fetching staff data for uid $uid: $e');
      return null;
    }
  }

  /// Update user status (activate/suspend)
  Future<bool> updateUserStatus(String uid, UserStatus status) async {
    try {
      print(
        '🔄 UserService: Updating user status to ${status.name} for uid: $uid',
      );

      await _firestore.collection(usersCollection).doc(uid).update({
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      print('✅ UserService: Successfully updated user status');
      return true;
    } catch (e) {
      print('❌ UserService: Error updating user status: $e');
      return false;
    }
  }

  /// Delete user from Firebase (soft delete by changing status)
  Future<bool> deleteUser(String uid) async {
    try {
      print('🗑️ UserService: Soft deleting user with uid: $uid');

      await _firestore.collection(usersCollection).doc(uid).update({
        'status': UserStatus.suspended.name,
        'deletedAt': DateTime.now().toIso8601String(),
      });

      print('✅ UserService: Successfully soft deleted user');
      return true;
    } catch (e) {
      print('❌ UserService: Error deleting user: $e');
      return false;
    }
  }

  /// Search users by name, email, or roll number
  Future<List<AppUser>> searchUsers(String query) async {
    try {
      print('🔍 UserService: Searching users with query: $query');

      if (query.isEmpty) {
        return await getAllUsers();
      }

      final String lowerQuery = query.toLowerCase();

      // Get all users first, then filter locally (Firebase doesn't support complex text search)
      final List<AppUser> allUsers = await getAllUsers();

      final filteredUsers = allUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email.toLowerCase();

        return fullName.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();

      print(
        '✅ UserService: Found ${filteredUsers.length} users matching query',
      );
      return filteredUsers;
    } catch (e) {
      print('❌ UserService: Error searching users: $e');
      throw Exception('Failed to search users: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, int>> getUserStats() async {
    try {
      // UserService: Calculating user statistics...

      final List<AppUser> allUsers = await getAllUsers();

      final stats = {
        'totalUsers': allUsers.length,
        'activeStudents': allUsers
            .where((u) => u.role == UserRole.student && u.isActive)
            .length,
        'activeStaff': allUsers
            .where((u) => u.role == UserRole.staff && u.isActive)
            .length,
        'suspendedUsers': allUsers
            .where((u) => u.status == UserStatus.suspended)
            .length,
        'pendingUsers': allUsers
            .where((u) => u.status == UserStatus.pending)
            .length,
      };

      // UserService: Statistics calculated
      return stats;
    } catch (e) {
      print('❌ UserService: Error calculating statistics: $e');
      return {
        'totalUsers': 0,
        'activeStudents': 0,
        'activeStaff': 0,
        'suspendedUsers': 0,
        'pendingUsers': 0,
      };
    }
  }

  /// Get users with real-time updates
  Stream<List<AppUser>> getUsersStream() {
    try {
      print('🔄 UserService: Starting real-time user stream...');

      // Use simple query without orderBy to avoid index requirement
      // If this fails, the app will fall back to one-time queries
      return _firestore
          .collection(usersCollection)
          .where(
            'role',
            isEqualTo: 'student',
          ) // Start with just students to avoid whereIn
          .snapshots()
          .map((snapshot) {
            final List<AppUser> users = _processUserQuerySnapshot(snapshot);

            // Sort by createdAt on the client side
            users.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            print(
              '🔄 UserService: Stream updated with ${users.length} student users',
            );
            return users;
          });
    } catch (e) {
      print('❌ UserService: Error creating user stream: $e');
      return const Stream.empty();
    }
  }
}
