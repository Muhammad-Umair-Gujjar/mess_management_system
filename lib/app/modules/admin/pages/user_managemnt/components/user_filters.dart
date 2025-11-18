import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../../../widgets/common/reusable_text_field.dart';

class UserFilters extends StatelessWidget {
  final String searchQuery;
  final String selectedRole;
  final String selectedStatus;
  final Function(String) onSearchChanged;
  final Function(String) onRoleChanged;
  final Function(String) onStatusChanged;
  final VoidCallback onAddUser;

  const UserFilters({
    Key? key,
    required this.searchQuery,
    required this.selectedRole,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onAddUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) ...[
            _buildMobileLayout(),
          ] else ...[
            _buildDesktopLayout(),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        ReusableTextField(
          hintText: 'Search users...',
          type: TextFieldType.search,
          onChanged: onSearchChanged,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Flexible(child: _buildRoleDropdown()),
            SizedBox(width: 4.w),
            Flexible(child: _buildStatusDropdown()),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: ReusableButton(
                text: 'Add User',
                icon: FontAwesomeIcons.userPlus,
                type: ButtonType.primary,
                size: ButtonSize.medium,
                onPressed: onAddUser,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ReusableTextField(
            hintText: 'Search users by name or email...',
            type: TextFieldType.search,
            onChanged: onSearchChanged,
          ),
        ),
        SizedBox(width: 16.w),
        SizedBox(width: 100.w, child: _buildRoleDropdown()),
        SizedBox(width: 6.w),
        SizedBox(width: 100.w, child: _buildStatusDropdown()),
        SizedBox(width: 16.w),
        ReusableButton(
          text: 'Add User',
          icon: FontAwesomeIcons.userPlus,
          type: ButtonType.primary,
          size: ButtonSize.medium,
          onPressed: onAddUser,
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      style: TextStyle(fontSize: 10.sp),
      decoration: const InputDecoration(
        labelText: 'Role',
        labelStyle: TextStyle(fontSize: 9),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        isDense: true,
      ),
      value: selectedRole.isEmpty ? null : selectedRole,
      items: ['Student', 'Staff', 'Admin'].map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role, style: TextStyle(fontSize: 10.sp)),
        );
      }).toList(),
      onChanged: (value) => onRoleChanged(value ?? ''),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      style: TextStyle(fontSize: 10.sp),
      decoration: const InputDecoration(
        labelText: 'Status',
        labelStyle: TextStyle(fontSize: 9),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        isDense: true,
      ),
      value: selectedStatus.isEmpty ? null : selectedStatus,
      items: ['Active', 'Inactive', 'Suspended'].map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status, style: TextStyle(fontSize: 10.sp)),
        );
      }).toList(),
      onChanged: (value) => onStatusChanged(value ?? ''),
    );
  }
}
