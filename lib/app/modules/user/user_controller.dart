import 'package:get/get.dart';
import '../../data/models/auth_models.dart';
import '../../data/services/auth_service.dart';
import '../../../core/utils/toast_message.dart';

/// UserController for global user data management
/// Stores current user information and provides it to all parts of the application
class UserController extends GetxController {
  static UserController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Observable user data
  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  final Rx<StudentData?> currentStudentData = Rx<StudentData?>(null);
  final isLoading = false.obs;

  // Getters for easy access
  String get fullName => currentUser.value?.fullName ?? 'User';
  String get email => currentUser.value?.email ?? '';
  UserRole get userRole => currentUser.value?.role ?? UserRole.student;
  bool get hasUserData => currentUser.value != null;
  String get hostelName => currentStudentData.value?.hostel ?? '';
  String get roomNumber => currentStudentData.value?.roomNumber ?? '';
  bool get hasStudentData => currentStudentData.value != null;

  @override
  void onInit() {
    super.onInit();
    // UserController onInit() called
  }

  /// Fetch current user data from Firestore using Firebase Auth UID
  Future<void> fetchCurrentUserData() async {
    try {
      isLoading.value = true;
      // UserController - Fetching user data...

      final user = await _authService.currentUser;
      if (user != null) {
        // UserController - User found: ${user.email}
        currentUser.value = user;
        print(
          '✅ DEBUG: UserController - User data loaded: ${user.fullName} (${user.email})',
        );

        // If user is a student, fetch student data
        if (user.role == UserRole.student) {
          await _fetchStudentData(user.uid);
        }
      } else {
        print('❌ DEBUG: UserController - No user found');
        currentUser.value = null;
        currentStudentData.value = null;
      }
    } catch (e) {
      print('❌ DEBUG: UserController - Error fetching user data: $e');
      ToastMessage.error('Failed to load user data: ${e.toString()}');
      currentUser.value = null;
      currentStudentData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch student-specific data from students collection
  Future<void> _fetchStudentData(String uid) async {
    try {
      print('🔵 DEBUG: UserController - Fetching student data for UID: $uid');
      final studentData = await _authService.getStudentData(uid);
      if (studentData != null) {
        currentStudentData.value = studentData;
        print(
          '✅ DEBUG: UserController - Student data loaded: ${studentData.hostel} - Room ${studentData.roomNumber}',
        );
      } else {
        print('❌ DEBUG: UserController - No student data found for UID: $uid');
        currentStudentData.value = null;
      }
    } catch (e) {
      print('❌ DEBUG: UserController - Error fetching student data: $e');
      currentStudentData.value = null;
    }
  }

  /// Set user data directly (used after login)
  Future<void> setUserData(AppUser user) async {
    // UserController - Setting user data
    currentUser.value = user;

    // If user is a student, fetch student data
    if (user.role == UserRole.student) {
      await _fetchStudentData(user.uid);
    }
  }

  /// Clear user data (used on logout)
  void clearUserData() {
    print('🔵 DEBUG: UserController - Clearing user data');
    currentUser.value = null;
    currentStudentData.value = null;
  }

  /// Refresh user data from Firestore
  Future<void> refreshUserData() async {
    print('🔵 DEBUG: UserController - Refreshing user data...');
    await fetchCurrentUserData();
  }
}
