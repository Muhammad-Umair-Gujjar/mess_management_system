import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_text_field.dart';
import '../../../staff_controller.dart';

class SearchAndFilterRow extends StatelessWidget {
  final StaffController controller;

  const SearchAndFilterRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? _buildMobileLayout(context)
        : _buildDesktopLayout(context);
  }

  /// Mobile layout - vertical stacking for better space utilization
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Search field - full width
        ReusableTextField(
          hintText: 'Search students by name or ID...',
          type: TextFieldType.search,
          onChanged: controller.filterStudents,
        ),
        SizedBox(height: 12.h),

        // Filter dropdown - full width
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Filter by Status',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            labelStyle: TextStyle(fontSize: 12.sp),
          ),
          style: TextStyle(fontSize: 12.sp),
          value: 'All',
          items: ['All', 'Present', 'Absent', 'Not Marked'].map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status, style: TextStyle(fontSize: 12.sp)),
            );
          }).toList(),
          onChanged: (value) => controller.filterByStatus(value ?? 'All'),
        ),
      ],
    );
  }

  /// Desktop layout - original horizontal layout
  Widget _buildDesktopLayout(BuildContext context) {
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
