import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
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
                    horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                    vertical: ResponsiveHelper.getSpacing(context, 'xs'),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getSpacing(context, 'small'),
                    ),
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
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            if (approvals.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      size: ResponsiveHelper.getIconSize(context, 'xxlarge'),
                      color: AppColors.success.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context, 'medium'),
                    ),
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
                      margin: EdgeInsets.only(
                        bottom: ResponsiveHelper.getSpacing(context, 'medium'),
                      ),
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getSpacing(context, 'medium'),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getSpacing(context, 'small'),
                        ),
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
                                  horizontal: ResponsiveHelper.getSpacing(
                                    context,
                                    'xsmall',
                                  ),
                                  vertical: ResponsiveHelper.getSpacing(
                                    context,
                                    'xsmall',
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getSpacing(
                                      context,
                                      'xsmall',
                                    ),
                                  ),
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
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              'small',
                            ),
                          ),
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
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              'medium',
                            ),
                          ),
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
                              SizedBox(
                                width: ResponsiveHelper.getSpacing(
                                  context,
                                  'small',
                                ),
                              ),
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
