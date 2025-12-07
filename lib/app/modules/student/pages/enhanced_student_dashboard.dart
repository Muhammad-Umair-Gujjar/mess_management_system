import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/responsive_dashboard_layout.dart';
import '../../auth/auth_controller.dart';
import '../../user/user_controller.dart';
import '../student_controller.dart';
import 'student_home_page/student_home_page.dart';
import 'student_view_attendance/student_attendance_page.dart';
import 'student_biling_page/student_billing_page.dart';
import 'student_view_menu/student_menu_page.dart';
import 'feedback_page/student_feedback_page.dart';

class EnhancedStudentDashboard extends StatelessWidget {
  const EnhancedStudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController(), permanent: true);
    final authController = Get.find<AuthController>();
    final userController = Get.find<UserController>();

    return Obx(
      () => ResponsiveDashboardLayout(
        title: 'Student Dashboard',
        userRole: 'Student',
        userName: userController.fullName,
        userEmail: userController.email,
        currentIndex: controller.currentPageIndex,
        onItemSelected: controller.changePage,
        menuItems: controller.navigationItems,
        header: _buildTopAppBar(context, controller),
        onLogoutPressed: () async => await authController.logout(),
        child: Obx(() {
          final currentIndex = controller.currentPageIndex.value;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: _getCurrentPage(currentIndex),
          );
        }),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context, StudentController controller) {
    return Container(
      height: ResponsiveHelper.getValue<double>(
        context,
        mobile: 55,
        tablet: 60,
        desktop: 65,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: ResponsiveHelper.getSpacing(context, 'large'),
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          child: Row(
            children: [
              // Page Title
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.getCurrentPageTitle(),
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.getCurrentPageSubtitle(),
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const StudentHomePage();
      case 1:
        return const StudentAttendancePage();
      case 2:
        return const StudentBillingPage();
      case 3:
        return const StudentMenuPage();
      case 4:
        return const StudentFeedbackPage();
      default:
        return _buildPlaceholderPage(
          'Dashboard',
          FontAwesomeIcons.house,
          AppColors.studentRole,
        );
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        return Container(
          padding: ResponsiveHelper.getPadding(context, 'padding'),
          child: Center(
            child: Container(
              padding: ResponsiveHelper.getValue<EdgeInsets>(
                context,
                mobile: const EdgeInsets.all(32),
                tablet: const EdgeInsets.all(40),
                desktop: const EdgeInsets.all(48),
              ),
              decoration: AppDecorations.glassmorphicContainer(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: ResponsiveHelper.getValue<EdgeInsets>(
                      context,
                      mobile: const EdgeInsets.all(32),
                      tablet: const EdgeInsets.all(28),
                      desktop: const EdgeInsets.all(24),
                    ),
                    decoration: AppDecorations.gradientContainer(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: ResponsiveHelper.getIconSize(context, 'xlarge'),
                      color: Colors.white,
                    ),
                  ).animate().scale(duration: 300.ms),

                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'xlarge'),
                  ),

                  Text(
                    title,
                    style: AppTextStyles.heading2.copyWith(
                      color: color,
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        'heading2',
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),

                  Text(
                    'Coming Soon!',
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        'subtitle1',
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'xlarge'),
                  ),

                  Container(
                    padding: ResponsiveHelper.getValue<EdgeInsets>(
                      context,
                      mobile: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      tablet: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      desktop: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getSpacing(context, 'large'),
                      ),
                    ),
                    child: Text(
                      'Advanced features are under development',
                      style: AppTextStyles.body2.copyWith(
                        color: color,
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          'body2',
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
