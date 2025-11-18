import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';

class PaymentHistoryCard extends StatelessWidget {
  final StudentController controller;

  const PaymentHistoryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _buildHistoryList(),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideX(begin: 0.3);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment History', style: AppTextStyles.heading5),
            SizedBox(height: 4.h),
            Text(
              'Last 6 months',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        Icon(FontAwesomeIcons.chartLine, color: AppColors.primary, size: 24.sp),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (index) {
            final month = DateTime.now().subtract(Duration(days: index * 30));
            final amount = (2500 + (index * 150)).toDouble();

            return _PaymentHistoryItem(
              month: DateFormat('MMM yyyy').format(month),
              amount: amount,
              status: index == 0 ? 'Current' : 'Paid',
              index: index,
            );
          }),
        ),
      ),
    );
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final String month;
  final double amount;
  final String status;
  final int index;

  const _PaymentHistoryItem({
    required this.month,
    required this.amount,
    required this.status,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'Paid';
    final isCurrent = status == 'Current';

    return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCurrent
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              _buildStatusIcon(isPaid, isCurrent),
              SizedBox(width: 16.w),
              _buildItemContent(isCurrent, isPaid),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? AppColors.primary : AppColors.textDark,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.2);
  }

  Widget _buildStatusIcon(bool isPaid, bool isCurrent) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primary
            : isPaid
            ? AppColors.success
            : AppColors.warning,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        isCurrent
            ? FontAwesomeIcons.clock
            : isPaid
            ? FontAwesomeIcons.check
            : FontAwesomeIcons.exclamation,
        size: 16.sp,
        color: Colors.white,
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
