import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../student_controller.dart';

class CurrentBillCard extends StatelessWidget {
  final StudentController controller;
  final AnimationController countAnimationController;
  final VoidCallback onDownloadPDF;
  final VoidCallback onExportCSV;

  const CurrentBillCard({
    super.key,
    required this.controller,
    required this.countAnimationController,
    required this.onDownloadPDF,
    required this.onExportCSV,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: AppShadows.glassmorphicCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 32.h),
          _buildAnimatedBillAmount(context),
          SizedBox(height: 32.h),
          _buildQuickActions(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            FontAwesomeIcons.receipt,
            size: 28.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Month Bill',
              style: AppTextStyles.heading5.copyWith(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
              ),
            ),
            Text(
              DateFormat('MMMM yyyy').format(DateTime.now()),
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedBillAmount(BuildContext context) {
    return AnimatedBuilder(
      animation: countAnimationController,
      builder: (context, child) {
        final animatedValue =
            Tween<double>(begin: 0, end: controller.monthlyBilling.value)
                .animate(
                  CurvedAnimation(
                    parent: countAnimationController,
                    curve: Curves.easeOutBack,
                  ),
                )
                .value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${animatedValue.toStringAsFixed(0)}',
              style: AppTextStyles.heading1.copyWith(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 36,
                  tablet: 42,
                  desktop: 48,
                ),
                foreground: Paint()
                  ..shader = AppColors.primaryGradient.createShader(
                    const Rect.fromLTWH(0, 0, 200, 70),
                  ),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.arrowDown,
                        size: 12.sp,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '12% vs last month',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            'Download PDF',
            FontAwesomeIcons.filePdf,
            AppColors.error,
            onDownloadPDF,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildQuickActionButton(
            'Export CSV',
            FontAwesomeIcons.fileCsv,
            AppColors.success,
            onExportCSV,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
