import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'mediumr')),
      decoration: AppShadows.glassmorphicCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
          _buildAnimatedBillAmount(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
          _buildQuickActions(),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
          ),
          child: Icon(
            FontAwesomeIcons.receipt,
            size: ResponsiveHelper.getIconSize(context, 'medium'),
            color: Colors.white,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Month Bill',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
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
              '${animatedValue.toStringAsFixed(0)} Rs',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 26,
                  tablet: 26,
                  desktop: 24,
                ),
                foreground: Paint()
                  ..shader = AppColors.primaryGradient.createShader(
                    const Rect.fromLTWH(0, 0, 200, 70),
                  ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                    vertical:
                        ResponsiveHelper.getSpacing(context, 'small') * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getSpacing(context, 'medium'),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.circleCheck,
                        size: ResponsiveHelper.getIconSize(context, 'small'),
                        color: AppColors.success,
                      ),
                      SizedBox(
                        width:
                            ResponsiveHelper.getSpacing(context, 'small') * 0.5,
                      ),
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
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              context,
              'Download PDF',
              FontAwesomeIcons.filePdf,
              AppColors.error,
              onDownloadPDF,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
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
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.getSpacing(context, 'medium'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getSpacing(context, 'small'),
          ),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: ResponsiveHelper.getIconSize(context, 'small')),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
