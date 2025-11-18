import 'package:get/get.dart';
import '../modules/auth/splash_screen.dart';
import '../modules/auth/landing_page.dart';
import '../modules/auth/simple_login_page.dart';
import '../modules/student/pages/enhanced_student_dashboard.dart';
import '../modules/staff/pages/staff_dashboard.dart';
import '../modules/admin/pages/admin_dashboard.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: '/landing',
      page: () => const LandingPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: '/login',
      page: () => const SimpleLoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/student',
      page: () => const EnhancedStudentDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: '/staff',
      page: () => const StaffDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: '/admin',
      page: () => const AdminDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
