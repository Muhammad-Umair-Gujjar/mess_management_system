import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/user/user_controller.dart';
import 'package:mess_management/app/data/services/menu_service.dart';
import '../data/services/user_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());

    Get.put(UserController());

    // Register services for dependency injection
    Get.put(MenuService());
    Get.put(UserService());
  }
}
