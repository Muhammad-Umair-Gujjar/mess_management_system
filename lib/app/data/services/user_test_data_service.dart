import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_models.dart';

/// Test service to create sample user data for testing the user management system
class UserTestDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create test student data in Firebase
  static Future<void> createTestStudents() async {
    try {
      print('🧪 Creating test student data...');

      final testStudents = [
        {
          'uid': 'test_student_1',
          'email': 'john.doe@student.com',
          'firstName': 'John',
          'lastName': 'Doe',
          'role': 'student',
          'status': 'active',
          'profileImageUrl': null,
          'createdAt': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'lastLoginAt': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'isEmailVerified': true,
          'createdBy': 'admin',
        },
        {
          'uid': 'test_student_2',
          'email': 'jane.smith@student.com',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'role': 'student',
          'status': 'active',
          'profileImageUrl': null,
          'createdAt': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'lastLoginAt': DateTime.now()
              .subtract(const Duration(hours: 5))
              .toIso8601String(),
          'isEmailVerified': true,
          'createdBy': 'admin',
        },
        {
          'uid': 'test_student_3',
          'email': 'mike.wilson@student.com',
          'firstName': 'Mike',
          'lastName': 'Wilson',
          'role': 'student',
          'status': 'suspended',
          'profileImageUrl': null,
          'createdAt': DateTime.now()
              .subtract(const Duration(days: 60))
              .toIso8601String(),
          'lastLoginAt': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'isEmailVerified': true,
          'createdBy': 'admin',
        },
      ];

      // Create users in users collection
      for (final student in testStudents) {
        await _firestore
            .collection('users')
            .doc(student['uid'] as String)
            .set(student);

        // Create student-specific data
        await _firestore
            .collection('students')
            .doc(student['uid'] as String)
            .set({
              'uid': student['uid'],
              'hostel': 'Block A',
              'roomNumber': '${100 + testStudents.indexOf(student)}',
              'department': 'Computer Science',
              'parentContact': '+91-9876543210',
              'phoneNumber': '+91-9876543210',
              'rollNumber': 'CS${2020 + testStudents.indexOf(student)}001',
              'batch': 2020 + testStudents.indexOf(student),
              'semester': 6,
              'approvedAt': DateTime.now()
                  .subtract(const Duration(days: 30))
                  .toIso8601String(),
              'approvedBy': 'admin',
              'address': 'Student Address ${testStudents.indexOf(student) + 1}',
            });
      }

      print('✅ Test student data created successfully');
    } catch (e) {
      print('❌ Error creating test student data: $e');
    }
  }

  /// Create test staff data in Firebase
  static Future<void> createTestStaff() async {
    try {
      print('🧪 Creating test staff data...');

      final testStaff = [
        {
          'uid': 'test_staff_1',
          'email': 'sarah.johnson@staff.com',
          'firstName': 'Sarah',
          'lastName': 'Johnson',
          'role': 'staff',
          'status': 'active',
          'profileImageUrl': null,
          'createdAt': DateTime.now()
              .subtract(const Duration(days: 90))
              .toIso8601String(),
          'lastLoginAt': DateTime.now()
              .subtract(const Duration(minutes: 30))
              .toIso8601String(),
          'isEmailVerified': true,
          'createdBy': 'admin',
        },
        {
          'uid': 'test_staff_2',
          'email': 'david.brown@staff.com',
          'firstName': 'David',
          'lastName': 'Brown',
          'role': 'staff',
          'status': 'active',
          'profileImageUrl': null,
          'createdAt': DateTime.now()
              .subtract(const Duration(days: 120))
              .toIso8601String(),
          'lastLoginAt': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
          'isEmailVerified': true,
          'createdBy': 'admin',
        },
      ];

      // Create users in users collection
      for (final staff in testStaff) {
        await _firestore
            .collection('users')
            .doc(staff['uid'] as String)
            .set(staff);

        // Create staff-specific data
        final staffIndex = testStaff.indexOf(staff);
        await _firestore.collection('staff').doc(staff['uid'] as String).set({
          'uid': staff['uid'],
          'employeeId': 'EMP${1000 + staffIndex}',
          'department': staffIndex == 0
              ? 'Mess Management'
              : 'Kitchen Operations',
          'position': staffIndex == 0 ? 'Manager' : 'Assistant',
          'joiningDate': DateTime.now()
              .subtract(Duration(days: 90 + staffIndex * 30))
              .toIso8601String(),
          'salary': staffIndex == 0 ? 35000.0 : 25000.0,
          'phoneNumber': '+91-9876543${210 + staffIndex}',
          'permissions': ['read', 'write'],
        });
      }

      print('✅ Test staff data created successfully');
    } catch (e) {
      print('❌ Error creating test staff data: $e');
    }
  }

  /// Create all test data
  static Future<void> createAllTestData() async {
    await createTestStudents();
    await createTestStaff();
    print('🎉 All test user data created successfully!');
  }

  /// Delete all test data
  static Future<void> deleteAllTestData() async {
    try {
      print('🧹 Deleting test user data...');

      final testIds = [
        'test_student_1',
        'test_student_2',
        'test_student_3',
        'test_staff_1',
        'test_staff_2',
      ];

      for (final id in testIds) {
        await _firestore.collection('users').doc(id).delete();
        await _firestore.collection('students').doc(id).delete();
        await _firestore.collection('staff').doc(id).delete();
      }

      print('✅ Test data deleted successfully');
    } catch (e) {
      print('❌ Error deleting test data: $e');
    }
  }
}
