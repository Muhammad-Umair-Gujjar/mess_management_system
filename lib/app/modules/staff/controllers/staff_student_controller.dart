import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/auth_models.dart';
import '../../../../core/utils/toast_message.dart';

/// Controller for managing student data in staff module
class StaffStudentController extends GetxController {
  // User service for real data
  final UserService _userService = Get.find<UserService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable lists
  final RxList<AppUser> allStudents = <AppUser>[].obs;
  final RxList<AppUser> filteredStudents = <AppUser>[].obs;
  final RxMap<String, Map<String, dynamic>> studentDetails =
      RxMap<String, Map<String, dynamic>>();
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  /// Load real student data from Firebase
  Future<void> loadStudents() async {
    try {
      isLoading.value = true;

      // Get all users and filter students
      final users = await _userService.getAllUsers();
      final students = users
          .where((user) => user.role == UserRole.student)
          .toList();

      allStudents.value = students;
      filteredStudents.value = students;

      // Load student details from students collection
      await _loadStudentDetails(students);
    } catch (e) {
      ToastMessage.error('Failed to load students: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load student details from students collection
  Future<void> _loadStudentDetails(List<AppUser> students) async {
    try {
      final QuerySnapshot studentSnapshot = await _firestore
          .collection('students')
          .get();

      final Map<String, Map<String, dynamic>> details = {};

      for (final doc in studentSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final uid = data['uid'] as String?;
        if (uid != null) {
          details[uid] = {
            'rollNumber': data['rollNumber'] ?? 'N/A',
            'roomNumber': data['roomNumber'] ?? 'N/A',
          };
        }
      }

      studentDetails.value = details;
      print(
        '✅ StaffStudentController: Loaded details for ${details.length} students',
      );
    } catch (e) {
      print('❌ StaffStudentController: Error loading student details: $e');
    }
  }

  /// Search and filter students
  void filterStudents(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  /// Filter students by status
  void filterByStatus(String status) {
    statusFilter.value = status;
    _applyFilters();
  }

  /// Apply search and status filters
  void _applyFilters() {
    var filtered = allStudents.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((student) {
        final name = student.fullName.toLowerCase();
        final email = student.email.toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    // Apply status filter
    if (statusFilter.value != 'All') {
      if (statusFilter.value == 'Active') {
        filtered = filtered
            .where((student) => student.status == UserStatus.active)
            .toList();
      } else if (statusFilter.value == 'Pending') {
        filtered = filtered
            .where((student) => student.status == UserStatus.pending)
            .toList();
      }
    }

    filteredStudents.value = filtered;
  }

  /// Convert AppUser to Map format for compatibility with existing UI components
  List<Map<String, dynamic>> get studentsAsMap {
    return filteredStudents.map((student) {
      final details = studentDetails[student.uid] ?? {};
      return {
        'id': details['rollNumber'] ?? 'N/A',
        'name': student.fullName,
        'email': student.email,
        'room': details['roomNumber'] ?? 'N/A',
        'isApproved': student.status == UserStatus.active,
      };
    }).toList();
  }

  /// Get total student count
  int get totalStudentCount => allStudents.length;

  /// Get active student count
  int get activeStudentCount => allStudents
      .where((student) => student.status == UserStatus.active)
      .length;

  /// Get pending student count
  int get pendingStudentCount => allStudents
      .where((student) => student.status == UserStatus.pending)
      .length;

  /// Refresh student data
  Future<void> refreshStudents() async {
    await loadStudents();
  }
}
