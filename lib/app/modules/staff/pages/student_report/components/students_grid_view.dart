import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/responsive_helper.dart';
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
    return GridView.builder(
      padding: EdgeInsets.all(8.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context)
            ? 1
            : ResponsiveHelper.isTablet(context)
            ? 2
            : 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.4,
      ),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return StudentCard(
          student: student,
          index: index,
          controller: controller,
        );
      },
    );
  }
}
