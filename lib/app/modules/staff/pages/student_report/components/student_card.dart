import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../staff_controller.dart';
import 'student_details_dialog.dart';

class StudentCard extends StatelessWidget {
  final dynamic student;
  final int index;
  final StaffController controller;

  const StudentCard({
    super.key,
    required this.student,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: AppShadows.light,
            border: Border.all(color: AppColors.staffRole.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.staffRole.withOpacity(0.1),
                    child: Text(
                      student['name'].substring(0, 1).toUpperCase(),
                      style: AppTextStyles.heading5.copyWith(
                        color: AppColors.staffRole,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: ${student['id']}',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.doorOpen,
                    size: 14.sp,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Room: ${student['room']}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.envelope,
                    size: 14.sp,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      student['email'],
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: ReusableButton(
                      text: 'View Details',
                      type: ButtonType.outline,
                      size: ButtonSize.small,
                      onPressed: () =>
                          StudentDetailsDialog.show(context, student),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      FontAwesomeIcons.check,
                      size: 12.sp,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
