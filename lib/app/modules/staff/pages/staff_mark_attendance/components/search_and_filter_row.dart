import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/common/reusable_text_field.dart';
import '../../../staff_controller.dart';

class SearchAndFilterRow extends StatelessWidget {
  final StaffController controller;

  const SearchAndFilterRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ReusableTextField(
            hintText: 'Search students by name or ID...',
            type: TextFieldType.search,
            onChanged: controller.filterStudents,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            value: 'All',
            items: ['All', 'Present', 'Absent', 'Not Marked'].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) => controller.filterByStatus(value ?? 'All'),
          ),
        ),
      ],
    );
  }
}
