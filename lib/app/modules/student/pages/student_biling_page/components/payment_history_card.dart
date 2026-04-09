import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class PaymentHistoryCard extends StatelessWidget {
  final StudentController controller;

  const PaymentHistoryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildHistoryList(context),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideX(begin: 0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment History', style: AppTextStyles.heading5),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, 'small') * 0.5,
            ),
            Text(
              'Last 6 months',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        if (ResponsiveHelper.isDesktop(context))
          Icon(
            FontAwesomeIcons.chartLine,
            color: AppColors.primary,
            size: ResponsiveHelper.getIconSize(context, 'medium'),
          ),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return Obx(() {
      final history = controller.billingHistory;

      if (controller.isLoadingBilling.value && history.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (history.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getSpacing(context, 'xlarge'),
          ),
          child: Text(
            'No billing history available yet.',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: ResponsiveHelper.getSpacing(context, 'xlarge') * 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: history.take(6).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final bill = entry.value;

              final month = DateTime.tryParse('${bill.monthId}-01');
              final monthLabel = month == null
                  ? bill.monthId
                  : DateFormat('MMM yyyy').format(month);

              return _PaymentHistoryItem(
                month: monthLabel,
                amount: bill.totalAmount,
                status: _normalizeStatus(bill.status, index),
                showAmount:
                    _normalizeStatus(bill.status, index).toLowerCase() ==
                    'paid',
                index: index,
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  String _normalizeStatus(String rawStatus, int index) {
    final normalized = rawStatus.trim().toLowerCase();
    if (normalized == 'paid') {
      return 'Paid';
    }
    if (index == 0) {
      return 'Current';
    }
    return 'Generated';
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final String month;
  final double amount;
  final String status;
  final bool showAmount;
  final int index;

  const _PaymentHistoryItem({
    required this.month,
    required this.amount,
    required this.status,
    required this.showAmount,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'Paid';
    final isCurrent = status == 'Current';

    return Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: status == 'Current'
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'small'),
            ),
            border: Border.all(
              color: isCurrent
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              _buildStatusIcon(isPaid, isCurrent),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              _buildItemContent(isCurrent, isPaid),
              Text(
                showAmount ? '${amount.toStringAsFixed(0)} Rs' : '-',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: showAmount
                      ? (isCurrent ? AppColors.primary : AppColors.textDark)
                      : AppColors.textLight,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.2);
  }

  Widget _buildStatusIcon(bool isPaid, bool isCurrent) {
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primary
              : isPaid
              ? AppColors.success
              : AppColors.warning,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
        ),
        child: Icon(
          isCurrent
              ? FontAwesomeIcons.clock
              : isPaid
              ? FontAwesomeIcons.check
              : FontAwesomeIcons.exclamation,
          size: ResponsiveHelper.getIconSize(context, 'medium'),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildItemContent(bool isCurrent, bool isPaid) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month,
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            status,
            style: AppTextStyles.caption.copyWith(
              color: isCurrent
                  ? AppColors.primary
                  : isPaid
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
