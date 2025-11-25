import 'package:flutter/material.dart';

import '../../../../../../core/utils/responsive_helper.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xsmall')),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'small'),
          ),
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




