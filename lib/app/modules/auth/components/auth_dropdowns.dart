import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/models/auth_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/theme/app_theme.dart';

class RoleSelectionDropdown extends StatelessWidget {
  final UserRole selectedRole;
  final Function(UserRole) onRoleChanged;

  const RoleSelectionDropdown({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: AppTextStyles.body2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: DropdownButtonFormField<UserRole>(
            value: selectedRole,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'large'),
                vertical: ResponsiveHelper.getSpacing(context, 'medium'),
              ),
              
          

            ),
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Row(
                  children: [
                    Icon(
                      _getRoleIcon(role),
                      color: _getRoleColor(role),
                      size: ResponsiveHelper.getIconSize(context, 'small'),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getSpacing(context, 'small'),
                    ),
                    Text(
                      _getRoleTitle(role),
                      style: AppTextStyles.body1.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          'body1',
                        ),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (UserRole? value) {
              if (value != null) {
                onRoleChanged(value);
              }
            },
            style: AppTextStyles.body1.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return FontAwesomeIcons.graduationCap;
      case UserRole.staff:
        return FontAwesomeIcons.userTie;
      case UserRole.admin:
        return FontAwesomeIcons.userShield;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppColors.studentRole;
      case UserRole.staff:
        return AppColors.staffRole;
      case UserRole.admin:
        return AppColors.adminRole;
    }
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.staff:
        return 'Staff';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

class HostelSelectionDropdown extends StatelessWidget {
  final String selectedHostel;
  final Function(String) onHostelChanged;

  const HostelSelectionDropdown({
    super.key,
    required this.selectedHostel,
    required this.onHostelChanged,
  });

  static const List<String> hostels = [
    'Abubakr Hostel',
    'Usman Hostel',
    'Ali Hostel',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hostel Name',
          style: AppTextStyles.body2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedHostel,
            decoration: InputDecoration(
               border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'large'),
                vertical: ResponsiveHelper.getSpacing(context, 'medium'),
              ),
             
              prefixIcon: Icon(
                FontAwesomeIcons.building,
                color: AppColors.primary,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
              ),
            ),
            items: hostels.map((hostel) {
              return DropdownMenuItem(
                value: hostel,
                child: Text(
                  hostel,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                onHostelChanged(value);
              }
            },
            style: AppTextStyles.body1.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
              color: AppColors.textPrimary,
            ),
          ),
        ),
      
      ],
    );
  }
}
