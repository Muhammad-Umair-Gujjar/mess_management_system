import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../user/user_controller.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/responsive_dashboard_layout.dart';
import 'staff_mark_attendance/staff_attendance_page.dart';
import 'student_report/staff_student_management_page.dart';
import 'staff_overviewPage/staff_overview_page.dart';
// import 'pages/staff_reports_page.dart'; // Commented out - can be enabled later
import '../staff_controller.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StaffController(), permanent: true);
    final authController = Get.find<AuthController>();
    final userController = Get.find<UserController>();

    return GetBuilder<StaffController>(
      builder: (controller) => Obx(
        () => ResponsiveDashboardLayout(
          title: 'Staff Dashboard',
          userRole: 'Staff',
          userName: userController.fullName,
          userEmail: userController.email,
          currentIndex: controller.currentPageIndex,
          onItemSelected: controller.changePage,
          menuItems: controller.navigationItems,
          header: _buildHeader(controller),
          onLogoutPressed: () async => await authController.logout(),
          child: GetBuilder<StaffController>(
            id: 'page_content',
            builder: (controller) =>
                _buildPageContent(controller.currentPageIndex.value),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(StaffController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isMobile(Get.context!)
            ? ResponsiveHelper.getSpacing(Get.context!, 'medium')
            : ResponsiveHelper.getSpacing(Get.context!, 'large'),
        vertical: ResponsiveHelper.getSpacing(Get.context!, 'medium'),
      ),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getCurrentPageTitle(),
                style: AppTextStyles.heading4.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(
                    Get.context!,
                    'heading4',
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(Get.context!, 'xs')),
              Text(
                controller.getCurrentPageSubtitle(),
                style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
          const Spacer(),
          // Quick Stats - Hidden on mobile
          if (!ResponsiveHelper.isMobile(Get.context!)) ...[
            () {
              final stats = controller.getTodayStats();
              return Row(
                children: [
                  _buildQuickStat(
                    'Students',
                    '${stats['totalStudents']}',
                    FontAwesomeIcons.users,
                    AppColors.primary,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(Get.context!, 'medium'),
                  ),
                  _buildQuickStat(
                    'Breakfast',
                    '${stats['breakfastPresent']}/${stats['totalStudents']}',
                    FontAwesomeIcons.sun,
                    AppColors.warning,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(Get.context!, 'medium'),
                  ),
                  _buildQuickStat(
                    'Dinner',
                    '${stats['dinnerPresent']}/${stats['totalStudents']}',
                    FontAwesomeIcons.moon,
                    AppColors.info,
                  ),
                ],
              );
            }(),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(Get.context!, 'medium'),
        vertical: ResponsiveHelper.getSpacing(Get.context!, 'small'),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(Get.context!, 'small'),
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getIconSize(Get.context!, 'tiny'),
            color: color,
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(Get.context!, 'xsmall')),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: color)),
              Text(
                value,
                style: AppTextStyles.subtitle1.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const StaffOverviewPage();
      case 1:
        return const StaffAttendancePage();
      case 2:
        return const StaffStudentManagementPage();
      // case 3:
      //   return const StaffReportsPage(); // Commented out - can be enabled later
      default:
        return const StaffOverviewPage();
    }
  }
}
