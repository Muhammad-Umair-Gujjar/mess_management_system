import 'package:get/get.dart';
import '../modules/auth/auth_controller.dart';
import '../modules/user/user_controller.dart';
import 'package:mess_management/app/data/services/menu_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print('🔵 DEBUG: InitialBinding - Creating AuthController...');
    Get.put(AuthController());
    print('✅ DEBUG: InitialBinding - AuthController created successfully');

    print('🔵 DEBUG: InitialBinding - Creating UserController...');
    Get.put(UserController());
    print('✅ DEBUG: InitialBinding - UserController created successfully');
    // Register MenuService for dependency injection
    Get.put(MenuService());
  }
}
