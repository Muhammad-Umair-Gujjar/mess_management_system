import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../admin_controller.dart';
import '../../controllers/admin_overview_controller.dart';
import 'components/system_stats_grid.dart';
import 'components/recent_activity_card.dart';
import 'components/quick_actions_card.dart';
import 'components/pending_approvals_card.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final overviewController = Get.put(AdminOverviewController());
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Obx(() {
        if (overviewController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: overviewController.refreshData,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Stats Overview
                SystemStatsGrid(
                  overviewController: overviewController,
                  isMobile: isMobile,
                ),

                SizedBox(
                  height: ResponsiveHelper.getSpacing(context, 'xlarge'),
                ),

                // Recent Activity and Quick Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Activity
                    Expanded(
                      flex: 2,
                      child: RecentActivityCard(controller: controller),
                    ),

                    if (!isMobile) ...[
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(context, 'large'),
                      ),
                      // Quick Actions
                      Expanded(
                        flex: 1,
                        child: QuickActionsCard(controller: controller),
                      ),
                    ],
                  ],
                ),

                if (isMobile) ...[
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  QuickActionsCard(controller: controller),
                ],

                SizedBox(
                  height: ResponsiveHelper.getSpacing(context, 'xlarge'),
                ),

                // Pending Approvals - Now uses real data
                PendingApprovalsCard(
                  overviewController: overviewController,
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
