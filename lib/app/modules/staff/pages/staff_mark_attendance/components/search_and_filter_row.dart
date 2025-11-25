import 'package:flutter/material.dart';

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
    return Row(
      children: [
        // Search field - full width
        Expanded(
          flex: 3,
          child: ReusableTextField(
            hintText: 'Search students by name or ID...',
            type: TextFieldType.search,
            onChanged: controller.filterStudents,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),

        // Filter dropdown - full width
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'medium'),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                vertical: ResponsiveHelper.getSpacing(context, 'xsmall'),
              ),
              labelStyle: const TextStyle(fontSize: 12),
            ),
            style: const TextStyle(fontSize: 12),
            value: 'All',
            items: ['All', 'Present', 'Absent', 'Not Marked'].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (value) => controller.filterByStatus(value ?? 'All'),
          ),
        ),
      ],
    );
  }

  /// Desktop layout - original horizontal layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ReusableTextField(
            hintText: 'Search students by name or ID...',
            type: TextFieldType.search,
            onChanged: controller.filterStudents,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'medium'),
                ),
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




