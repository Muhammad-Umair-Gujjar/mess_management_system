import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../staff_controller.dart';
import 'student_card.dart';

class StudentsListView extends StatelessWidget {
  final StaffController controller;
  final bool isMobile;
  final String selectedMeal;
  final DateTime selectedDay;

  const StudentsListView({
    super.key,
    required this.controller,
    required this.isMobile,
    required this.selectedMeal,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredStudents = controller.filteredStudents;

      if (filteredStudents.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return StudentCard(
            student: student,
            controller: controller,
            index: index,
            selectedMeal: selectedMeal,
            selectedDay: selectedDay,
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.users, size: 64.sp, color: AppColors.textLight),
          SizedBox(height: 24.h),
          Text(
            'No students found',
            style: AppTextStyles.heading5.copyWith(color: AppColors.textLight),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filter criteria',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
