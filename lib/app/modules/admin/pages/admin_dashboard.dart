import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final controller = Get.put(AdminController());

    return ResponsiveDashboardLayout(
      title: 'Admin Dashboard',
      userRole: 'Admin',
      userName: 'Administrator',
      userEmail: 'admin@messmaster.com',
      currentIndex: controller.currentPageIndex,
      onItemSelected: controller.changePage,
      menuItems: controller.navigationItems,
      header: _buildHeader(controller),
      onLogoutPressed: () => Get.offAllNamed('/'),
      child: Obx(() => _buildPageContent(controller.currentPageIndex.value)),
    );
  }

  Widget _buildHeader(AdminController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isMobile(Get.context!) ? 16.w : 32.w,
        vertical: 24.h,
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
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      Get.context!,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.getCurrentPageSubtitle(),
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // System Stats
          Obx(() {
            final stats = controller.getSystemOverview();
            final isMobile = ResponsiveHelper.isMobile(Get.context!);

            return Row(
              children: [
                _buildQuickStat(
                  'Total Users',
                  '${stats['totalUsers']}',
                  FontAwesomeIcons.users,
                  AppColors.adminRole,
                  isMobile: isMobile,
                ),
                SizedBox(width: isMobile ? 12.w : 24.w),
                _buildQuickStat(
                  'Pending',
                  '${stats['pendingApprovals']}',
                  FontAwesomeIcons.clock,
                  AppColors.warning,
                  isMobile: isMobile,
                ),
                SizedBox(width: isMobile ? 12.w : 24.w),
                _buildQuickStat(
                  'Revenue',
                  '₹${(stats['monthlyRevenue'] / 1000).toStringAsFixed(0)}K',
                  FontAwesomeIcons.chartLine,
                  AppColors.success,
                  isMobile: isMobile,
                ),
                // Only show uptime on tablet and desktop
                if (!isMobile) ...[
                  SizedBox(width: 24.w),
                  _buildQuickStat(
                    'Uptime',
                    '${stats['systemUptime']}%',
                    FontAwesomeIcons.server,
                    AppColors.info,
                    isMobile: false,
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
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
          ? BoxConstraints(maxWidth: 100.w, minHeight: 60.h)
          : null,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.w : 16.w,
        vertical: isMobile ? 8.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 8.r : 12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.sp, color: color),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 10.sp,
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
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Row(
              children: [
                Icon(icon, size: 18.sp, color: color),
                SizedBox(width: 8.w),
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
