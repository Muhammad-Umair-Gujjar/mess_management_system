import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) ...[
            _buildMobileLayout(context),
          ] else ...[
            _buildDesktopLayout(context),
          ],
        ],
      ),
    ).animate().fadeIn(duration:  300.ms ).slideY(begin: -0.3);
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        ReusableTextField(
          hintText: 'Search users...',
          type: TextFieldType.search,
          onChanged: onSearchChanged,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        Row(
          children: [
            Expanded(flex: 2, child: _buildRoleDropdown(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),
            Expanded(flex: 2, child: _buildStatusDropdown(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),
            Flexible(
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

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ReusableTextField(
            hintText: r'Search users by name or email...',
            type: TextFieldType.search,
            onChanged: onSearchChanged,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        Expanded(
          flex: 2,
          child: SizedBox(
            width: ResponsiveHelper.getComponentDimension(
              context,
              'dropdownWidth',
            ),
            child: _buildRoleDropdown(context),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'xs')),
        Expanded(
          flex: 2,
          child: SizedBox(
            width: ResponsiveHelper.getComponentDimension(
              context,
              'dropdownWidth',
            ),
            child: _buildStatusDropdown(context),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        Expanded(
          child: ReusableButton(
            text: 'Add User',
            icon: FontAwesomeIcons.userPlus,
            type: ButtonType.primary,
            size: ButtonSize.small,
            onPressed: onAddUser,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: TextStyle(
        fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
      ),
      decoration:  InputDecoration(
        labelText: 'Role',
        labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'medium')
        ),
        isDense: true,
      ),
      value: selectedRole.isEmpty ? null : selectedRole,
      items: ['Student', 'Staff', 'Admin'].map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(
            role,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'caption'),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) => onRoleChanged(value ?? ''),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: TextStyle(
        fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
      ),
      decoration:  InputDecoration(
        labelText: 'Status',
        labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'medium')),
        isDense: true,
      ),
      value: selectedStatus.isEmpty ? null : selectedStatus,
      items: ['Active', 'Inactive', 'Suspended'].map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(
            status,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'caption'),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) => onStatusChanged(value ?? ''),
    );
  }
}




