import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../staff_controller.dart';
import 'student_list_tile.dart';

class StudentsListView extends StatelessWidget {
  final List<dynamic> students;
  final StaffController controller;

  const StudentsListView({
    super.key,
    required this.students,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.r),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: StudentListTile(
            student: student,
            index: index,
            controller: controller,
          ),
        );
      },
    );
  }
}
