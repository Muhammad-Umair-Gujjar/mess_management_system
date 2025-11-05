import 'package:get/get.dart';
import '../../data/models/feedback.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var currentUser = Rxn<User>();
  
  void login(UserRole role, String name) {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      currentUser.value = User(
        id: '${role.name}_user',
        name: name,
        email: '${name.toLowerCase().replaceAll(' ', '.')}@university.edu',
        role: role,
      );
      
      isLoading.value = false;
      
      // Navigate based on role
      switch (role) {
        case UserRole.student:
          Get.offAllNamed('/student');
          break;
        case UserRole.staff:
          Get.offAllNamed('/staff');
          break;
        case UserRole.admin:
          Get.offAllNamed('/admin');
          break;
      }
      
      Get.snackbar(
        'Success',
        'Welcome back, ${name}!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    });
  }
  
  void logout() {
    currentUser.value = null;
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
  
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}