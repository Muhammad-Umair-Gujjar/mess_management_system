import 'package:get/get.dart';
import '../modules/auth/splash_screen.dart';
import '../modules/auth/landing_page.dart';
import '../modules/auth/enhanced_login_page.dart';
import '../modules/auth/signup_page.dart';
import '../modules/auth/password_reset_page.dart';
import '../modules/student/pages/enhanced_student_dashboard.dart';
import '../modules/staff/pages/staff_dashboard.dart';
import '../modules/admin/pages/admin_dashboard.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/login',
      page: () => const EnhancedLoginPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/landing',
      page: () => const LandingPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // 
    GetPage(
      name: '/signup',
      page: () => const SignupPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/password-reset',
      page: () => const PasswordResetPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/student',
      page: () => const EnhancedStudentDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/staff',
      page: () => const StaffDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/admin',
      page: () => const AdminDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
