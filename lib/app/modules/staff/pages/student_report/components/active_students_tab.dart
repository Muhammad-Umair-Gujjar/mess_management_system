import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_text_field.dart';
import '../../../staff_controller.dart';
import '../../../controllers/staff_student_controller.dart';
import 'students_grid_view.dart';
import 'students_list_view.dart';

class ActiveStudentsTab extends StatelessWidget {
  final StaffController controller;
  final bool isMobile;

  const ActiveStudentsTab({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final studentController = Get.find<StaffStudentController>();

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with search
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Students', style: AppTextStyles.heading5),
                    Obx(
                      () => Text(
                        '${studentController.filteredStudents.length} students enrolled',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReusableTextField(
                  hintText: 'Search students...',
                  type: TextFieldType.search,
                  onChanged: studentController.filterStudents,
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

          // Students Grid/List
          Expanded(
            child: Obx(() {
              final students = studentController.studentsAsMap;

              if (students.isEmpty) {
                if (studentController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildEmptyState('No active students found');
              }

              return isMobile
                  ? StudentsListView(students: students, controller: controller)
                  : StudentsGridView(
                      students: students,
                      controller: controller,
                    );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.3);
  }

  Widget _buildEmptyState(String message) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.users,
              size: ResponsiveHelper.getIconSize(context, 'xlarge'),
              color: AppColors.textLight,
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            Text(
              message,
              style: AppTextStyles.heading5.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
