import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../controllers/admin_overview_controller.dart';

class PendingApprovalsCard extends StatelessWidget {
  final AdminOverviewController overviewController;
  final bool isMobile;

  const PendingApprovalsCard({
    super.key,
    required this.overviewController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pendingRequests = overviewController.pendingStudentRequests;

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
        decoration: AppDecorations.floatingCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Pending Student Approvals',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading5,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: Container(
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
                      '${pendingRequests.length} pending',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            if (pendingRequests.isEmpty)
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
                      'No pending student approvals',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...pendingRequests
                  .map(
                    (request) => Container(
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
                                  'Student Registration',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDate(request.requestedAt),
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
                          Text(
                            '${request.firstName} ${request.lastName}',
                            style: AppTextStyles.subtitle1.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            request.email,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(context, 'xs'),
                          ),
                          Row(
                            children: [
                              _buildInfoChip(
                                context,
                                'Roll No',
                                request.rollNumber,
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getSpacing(
                                  context,
                                  'xs',
                                ),
                              ),
                              _buildInfoChip(context, 'Hostel', request.hostel),
                            ],
                          ),
                          if (request.department.isNotEmpty ||
                              request.semester > 0) ...[
                            SizedBox(
                              height: ResponsiveHelper.getSpacing(
                                context,
                                'xs',
                              ),
                            ),
                            if (!ResponsiveHelper.isMobile(context))
                              Row(
                                children: [
                                  _buildInfoChip(
                                    context,
                                    'Department',
                                    request.department,
                                  ),
                                  SizedBox(
                                    width: ResponsiveHelper.getSpacing(
                                      context,
                                      'small',
                                    ),
                                  ),
                                  _buildInfoChip(
                                    context,
                                    'Semester',
                                    '${request.semester}',
                                  ),
                                ],
                              ),
                          ],
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              'medium',
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => ReusableButton(
                                    text: 'Approve',
                                    type: ButtonType.success,
                                    size: ButtonSize.small,
                                    isLoading: overviewController
                                        .isProcessingRequest
                                        .value,
                                    onPressed: () => overviewController
                                        .approveStudentRequest(request),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getSpacing(
                                  context,
                                  'small',
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => ReusableButton(
                                    text: 'Reject',
                                    type: ButtonType.danger,
                                    size: ButtonSize.small,
                                    isLoading: overviewController
                                        .isProcessingRequest
                                        .value,
                                    onPressed: () =>
                                        _showRejectDialog(context, request),
                                  ),
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
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3);
    });
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'xs'),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'xs'),
        ),
      ),
      child: Text(
        '$label: $value',
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _showRejectDialog(BuildContext context, dynamic request) {
    final TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Reject Student Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to reject ${request.firstName} ${request.lastName}?',
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason',
                hintText: 'Enter reason for rejection...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                Get.snackbar('Error', 'Please provide a rejection reason');
                return;
              }
              Get.back();
              overviewController.rejectStudentRequest(request, reason);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
