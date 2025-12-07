import 'package:get/get.dart';
import '../modules/auth/auth_controller.dart';
import '../modules/user/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print('🔵 DEBUG: InitialBinding - Creating AuthController...');
    Get.put(AuthController(), permanent: true);
    print('✅ DEBUG: InitialBinding - AuthController created successfully');

    print('🔵 DEBUG: InitialBinding - Creating UserController...');
    Get.put(UserController(), permanent: true);
    print('✅ DEBUG: InitialBinding - UserController created successfully');
  }
}
