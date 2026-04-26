import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../staff_controller.dart';
import 'components/active_students_tab.dart';

class StaffStudentManagementPage extends StatefulWidget {
  const StaffStudentManagementPage({super.key});

  @override
  State<StaffStudentManagementPage> createState() =>
      _StaffStudentManagementPageState();
}

class _StaffStudentManagementPageState
    extends State<StaffStudentManagementPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Column(
        children: [
          // Main Content
          Expanded(
            child: ActiveStudentsTab(
              controller: controller,
              isMobile: isMobile,
            ),
          ),
        ],
      ),
    );
  }
}
