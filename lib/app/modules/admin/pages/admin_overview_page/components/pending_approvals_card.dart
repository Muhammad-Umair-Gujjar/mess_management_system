import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../admin_controller.dart';

class PendingApprovalsCard extends StatelessWidget {
  final AdminController controller;
  final bool isMobile;

  const PendingApprovalsCard({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final approvals = controller.pendingApprovals;

      return Container(
        padding: EdgeInsets.all(24.r),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pending Approvals', style: AppTextStyles.heading5),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${approvals.length} pending',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (approvals.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      size: 48.sp,
                      color: AppColors.success.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No pending approvals',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...approvals
                  .map(
                    (approval) => Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  approval['type'],
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                approval['submittedDate'],
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (approval['name'] != null) ...[
                            Text(
                              approval['name'],
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (approval['email'] != null)
                              Text(
                                approval['email'],
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                          if (approval['description'] != null)
                            Text(
                              approval['description'],
                              style: AppTextStyles.body2,
                            ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: ReusableButton(
                                  text: 'Approve',
                                  type: ButtonType.success,
                                  size: ButtonSize.small,
                                  onPressed: () =>
                                      controller.approveUser(approval['id']),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ReusableButton(
                                  text: 'Reject',
                                  type: ButtonType.danger,
                                  size: ButtonSize.small,
                                  onPressed: () =>
                                      controller.rejectUser(approval['id']),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.3);
    });
  }
}
