import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../staff_controller.dart';
import 'components/management_tab_selector.dart';
import 'components/active_students_tab.dart';
import 'components/student_stats_tab.dart';

class StaffStudentManagementPage extends StatefulWidget {
  const StaffStudentManagementPage({super.key});

  @override
  State<StaffStudentManagementPage> createState() =>
      _StaffStudentManagementPageState();
}

class _StaffStudentManagementPageState extends State<StaffStudentManagementPage>
    with TickerProviderStateMixin {
  int selectedTabIndex = 0;
  late AnimationController _listAnimationController;

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Column(
        children: [
          // Tab Selector
          ManagementTabSelector(
            selectedTabIndex: selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

          // Main Content
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                ActiveStudentsTab(controller: controller, isMobile: isMobile),
                StudentStatsTab(controller: controller, isMobile: isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
