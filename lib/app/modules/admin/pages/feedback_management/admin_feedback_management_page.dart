import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/utils/toast_message.dart';
import '../../../../data/models/feedback.dart' as feedback_model;
import '../../../../data/services/menu_service.dart';
import '../../../../widgets/common/reusable_text_field.dart';

class AdminFeedbackManagementPage extends StatefulWidget {
  const AdminFeedbackManagementPage({super.key});

  @override
  State<AdminFeedbackManagementPage> createState() =>
      _AdminFeedbackManagementPageState();
}

class _AdminFeedbackManagementPageState
    extends State<AdminFeedbackManagementPage> {
  late final MenuService _menuService;

  final List<feedback_model.Feedback> _feedbacks = [];
  bool _isLoading = false;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _menuService = Get.find<MenuService>();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _menuService.getAllStudentFeedbacks();
      if (!mounted) {
        return;
      }

      setState(() {
        _feedbacks
          ..clear()
          ..addAll(data);
      });
    } catch (e) {
      ToastMessage.error('Failed to load feedbacks');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<feedback_model.Feedback> get _filteredFeedbacks {
    if (_statusFilter == 'all') {
      return _feedbacks;
    }

    return _feedbacks
        .where((feedback) => feedback.status.toLowerCase() == _statusFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.backgroundGradient(),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolbar(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Text('Student Feedback', style: AppTextStyles.heading5),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, 'small'),
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'medium'),
              ),
              border: Border.all(color: AppColors.textLight.withOpacity(0.25)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'medium'),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'reviewed', child: Text('Reviewed')),
                  DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _statusFilter = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
          IconButton(
            onPressed: _loadFeedbacks,
            icon: const Icon(FontAwesomeIcons.arrowsRotate),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _feedbacks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final list = _filteredFeedbacks;
    if (list.isEmpty) {
      return Container(
        decoration: AppDecorations.floatingCard(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context, 'large'),
            ),
            child: Text(
              'No feedback found for selected filter.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeedbacks,
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
        itemBuilder: (context, index) {
          final feedback = list[index];
          return _buildFeedbackCard(context, feedback);
        },
      ),
    );
  }

  Widget _buildFeedbackCard(
    BuildContext context,
    feedback_model.Feedback feedback,
  ) {
    final hasResponse =
        feedback.response != null && feedback.response!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.studentName,
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context, 'xsmall'),
                    ),
                    Text(
                      '${feedback.category} | ${DateFormat('MMM dd, yyyy hh:mm a').format(feedback.submittedAt)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, feedback.status),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.star,
                size: ResponsiveHelper.getIconSize(context, 'xsmall'),
                color: AppColors.warning,
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),
              Text(
                '${feedback.rating}/5',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(feedback.comment, style: AppTextStyles.body2),
          if (hasResponse) ...[
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'small'),
                ),
                border: Border.all(color: AppColors.success.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Response',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'xsmall'),
                  ),
                  Text(
                    feedback.response!,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openResponseDialog(feedback),
              icon: Icon(
                hasResponse
                    ? FontAwesomeIcons.penToSquare
                    : FontAwesomeIcons.reply,
                size: ResponsiveHelper.getIconSize(context, 'xsmall'),
              ),
              label: Text(hasResponse ? 'Edit Response' : 'Add Response'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.adminRole,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final normalized = status.toLowerCase();
    final color = _statusColor(normalized);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'xsmall'),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'small'),
        ),
      ),
      child: Text(
        normalized,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'reviewed':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  Future<void> _openResponseDialog(feedback_model.Feedback feedback) async {
    final responseController = TextEditingController(
      text: feedback.response ?? '',
    );
    String selectedStatus = feedback.status.toLowerCase();
    if (selectedStatus.isEmpty || selectedStatus == 'pending') {
      selectedStatus = 'reviewed';
    }

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Respond to Feedback'),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.comment,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(
                        dialogContext,
                        'medium',
                      ),
                    ),
                    ReusableTextField(
                      label: 'Response',
                      hintText: 'Write your response for the student',
                      controller: responseController,
                      maxLines: 4,
                      prefixIcon: Icons.reply,
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(
                        dialogContext,
                        'small',
                      ),
                    ),
                    Row(
                      children: [
                        Text('Status', style: AppTextStyles.body2),
                        SizedBox(
                          width: ResponsiveHelper.getSpacing(
                            dialogContext,
                            'small',
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'reviewed',
                                child: Text('reviewed'),
                              ),
                              DropdownMenuItem(
                                value: 'resolved',
                                child: Text('resolved'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setDialogState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop({
                      'response': responseController.text.trim(),
                      'status': selectedStatus,
                    });
                  },
                  child: const Text('Save Response'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    final response = (result['response'] ?? '').trim();
    final status = (result['status'] ?? 'reviewed').trim();

    if (response.isEmpty) {
      ToastMessage.error('Response cannot be empty');
      return;
    }

    final success = await _menuService.respondToStudentFeedback(
      feedbackId: feedback.id,
      response: response,
      status: status,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ToastMessage.success('Feedback response saved');
      await _loadFeedbacks();
    } else {
      ToastMessage.error('Failed to save feedback response');
    }
  }
}
