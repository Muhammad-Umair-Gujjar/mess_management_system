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
import '../admin_controller.dart';
import 'admin_overview_page/admin_overview_page.dart';
import 'user_managemnt/admin_user_management_page.dart';
import 'menu_management/admin_menu_management_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController(), permanent: true);
    final authController = Get.find<AuthController>();
    final userController = Get.find<UserController>();

    return Obx(
      () => ResponsiveDashboardLayout(
        title: 'Admin Dashboard',
        userRole: 'Admin',
        userName: userController.fullName,
        userEmail: userController.email,
        currentIndex: controller.currentPageIndex,
        onItemSelected: controller.changePage,
        menuItems: controller.navigationItems,
        header: _buildHeader(controller),
        onLogoutPressed: () async => await authController.logout(),
        child: Obx(() => _buildPageContent(controller.currentPageIndex.value)),
      ),
    );
  }

  Widget _buildHeader(AdminController controller) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        Get.context!,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        desktop: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      ),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.getCurrentPageTitle(),
                  style: AppTextStyles.heading4.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      Get.context!,
                      mobile: 20,
                      tablet: 25,
                      desktop: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(Get.context!, 'xs')),
              Obx(
                () => Text(
                  controller.getCurrentPageSubtitle(),
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // System Stats - Only show on tablet/desktop
          if (!ResponsiveHelper.isMobile(Get.context!))
            Obx(() {
              final stats = controller.getSystemOverview;
              final isMobile = false;
              return Row(
                children: [
                  _buildQuickStat(
                    'Total Users',
                    '${stats['totalUsers']}',
                    FontAwesomeIcons.users,
                    AppColors.adminRole,
                    isMobile: isMobile,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(Get.context!, 'small'),
                  ),
                  _buildQuickStat(
                    'Pending',
                    '${stats['pendingApprovals']}',
                    FontAwesomeIcons.clock,
                    AppColors.warning,
                    isMobile: isMobile,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(Get.context!, 'small'),
                  ),
                  // Only show uptime on tablet and desktop
                  _buildQuickStat(
                    'Revenue',
                    '${(stats['monthlyRevenue'] / 1000).toStringAsFixed(0)}K Rs',
                    FontAwesomeIcons.chartLine,
                    AppColors.success,
                    isMobile: isMobile,
                  ),
                ],
              );
            }),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isMobile = false,
  }) {
    return Container(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 100, minHeight: 50)
          : null,
      padding: ResponsiveHelper.getResponsivePadding(
        Get.context!,
        mobile: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(
            Get.context!,
            isMobile ? 'small' : 'medium',
          ),
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(Get.context!, 'tiny'),
                  color: color,
                ),
                SizedBox(
                  height: ResponsiveHelper.getSpacing(Get.context!, 'xs'),
                ),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: ResponsiveHelper.getFontSize(
                      Get.context!,
                      'caption',
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveHelper.getFontSize(
                      Get.context!,
                      'cardSubtitle',
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Row(
              children: [
                Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(Get.context!, 'small'),
                  color: color,
                ),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(Get.context!, 'small'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(color: color),
                    ),
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
        return const AdminOverviewPage();
      case 1:
        return const AdminUserManagementPage();
      case 2:
        return const AdminMenuManagementPage();
      default:
        return const AdminOverviewPage();
    }
  }
}
