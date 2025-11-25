import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_grid_view.dart';
import '../../../staff_controller.dart';
import 'student_card.dart';

class StudentsGridView extends StatelessWidget {
  final List<dynamic> students;
  final StaffController controller;

  const StudentsGridView({
    super.key,
    required this.students,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Convert students to GridCardData format with custom content
    final gridData = students
        .map(
          (student) => GridCardData(
            title: student['name'] ?? '',
            value: student['id']?.toString() ?? '',
            icon: FontAwesomeIcons.user,
            color: AppColors.staffRole,
            customContent: StudentCard(
              student: student,
              index: students.indexOf(student),
              controller: controller,
            ),
          ),
        )
        .toList();

    return CustomGridView(
      data: gridData,
      crossAxisCount: 3, // Desktop: 4 columns
      tabletCrossAxisCount: 3, // Tablet: 3 columns
      mobileCrossAxisCount: 2, // Mobile: 2 columns
      crossAxisSpacing: ResponsiveHelper.getSpacing(context, 'medium'),
      mainAxisSpacing: ResponsiveHelper.getSpacing(context, 'medium'),
      childAspectRatio: 1.2, // Reduced from 1.4 to give more vertical space
      mobileAspectRatio: 0.9, // Even more vertical space on mobile
      tabletAspectRatio: 1.2, // Slightly more vertical space on tablet
      // Removed outer padding to make cards bigger
      physics: const BouncingScrollPhysics(), // Enable scrolling
      shrinkWrap: false, // Ensure it takes full available space
      cardStyle: CustomGridCardStyle.minimal,
      showAnimation: true,
    );
  }
}




