import 'package:get/get.dart';
import '../../../core/utils/toast_message.dart';

class LoginController extends GetxController {
  // Observable variables
  var selectedRole = ''.obs;
  var isLoading = false.obs;

  // Role selection
  void selectRole(String role) {
    selectedRole.value = role;
    navigateToRoleDashboard(role);
  }

  // Navigate to appropriate dashboard
  void navigateToRoleDashboard(String role) {
    isLoading.value = true;

    // Simulate loading delay for smooth transition
    Future.delayed(const  Duration(milliseconds: 300) , () {
      isLoading.value = false;

      switch (role.toLowerCase()) {
        case 'student':
          Get.offNamed('/student');
          break;
        case 'staff':
          Get.offNamed('/staff');
          break;
        case 'admin':
          Get.offNamed('/admin');
          break;
        default:
          ToastMessage.error('Invalid role selected');
      }
    });
  }

  // Quick login methods for demo purposes
  void quickLoginAsStudent() {
    selectedRole.value = 'student';
    navigateToRoleDashboard('student');
  }

  void quickLoginAsStaff() {
    selectedRole.value = 'staff';
    navigateToRoleDashboard('staff');
  }

  void quickLoginAsAdmin() {
    selectedRole.value = 'admin';
    navigateToRoleDashboard('admin');
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize any required data
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }
}




