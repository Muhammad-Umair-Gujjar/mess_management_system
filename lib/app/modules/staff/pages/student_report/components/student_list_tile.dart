import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../staff_controller.dart';
import 'student_details_dialog.dart';

class StudentListTile extends StatelessWidget {
  final dynamic student;
  final int index;
  final StaffController controller;

  const StudentListTile({
    super.key,
    required this.student,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.getSpacing(context, 'medium'),
                backgroundColor: AppColors.staffRole.withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.staffRole,
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${student['id']} • Room: ${student['room']}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              ReusableButton(
                text: 'Details',
                type: ButtonType.ghost,
                size: ButtonSize.small,
                onPressed: () => StudentDetailsDialog.show(context, student),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.3);
  }
}
