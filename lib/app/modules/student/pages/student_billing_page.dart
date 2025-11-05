import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/attendance.dart';
import '../student_controller.dart';

class StudentBillingPage extends StatefulWidget {
  const StudentBillingPage({super.key});

  @override
  State<StudentBillingPage> createState() => _StudentBillingPageState();
}

class _StudentBillingPageState extends State<StudentBillingPage>
    with TickerProviderStateMixin {
  late AnimationController _countAnimationController;
  late AnimationController _chartAnimationController;

  @override
  void initState() {
    super.initState();
    _countAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animations
    _countAnimationController.forward();
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _countAnimationController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentController>(
      init: Get.find<StudentController>(),
      builder: (controller) => Container(
        decoration: AppDecorations.backgroundGradient(),
        child: ResponsiveHelper.buildResponsiveLayout(
          context: context,
          mobile: _buildMobileLayout(controller),
          desktop: _buildDesktopLayout(controller),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrentBillCard(controller),
          SizedBox(height: 24.h),
          _buildMealCountCards(controller),
          SizedBox(height: 24.h),
          _buildPaymentHistoryCard(controller),
          SizedBox(height: 24.h),
          _buildMealRatesCard(controller),
          SizedBox(height: 20.h), // Add bottom padding
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCurrentBillCard(controller),
                SizedBox(height: 24.h),
                _buildMealCountCards(controller),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPaymentHistoryCard(controller),
                SizedBox(height: 24.h),
                _buildMealRatesCard(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBillCard(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: AppShadows.glassmorphicCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 32.h),

          // Animated Bill Amount
          AnimatedBuilder(
            animation: _countAnimationController,
            builder: (context, child) {
              final animatedValue =
                  Tween<double>(begin: 0, end: controller.monthlyBilling.value)
                      .animate(
                        CurvedAnimation(
                          parent: _countAnimationController,
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
          ),

          SizedBox(height: 32.h),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Download PDF',
                  FontAwesomeIcons.filePdf,
                  AppColors.error,
                  () => _downloadPDF(),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildQuickActionButton(
                  'Export CSV',
                  FontAwesomeIcons.fileCsv,
                  AppColors.success,
                  () => _exportCSV(),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
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

  Widget _buildMealCountCards(StudentController controller) {
    final stats = controller.getMonthlyStats();

    return Row(
      children: [
        Expanded(
          child: _buildMealCountCard(
            'Breakfast',
            stats['breakfastCount'] ?? 0,
            FontAwesomeIcons.sun,
            AppColors.warning,
            0,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMealCountCard(
            'Dinner',
            stats['dinnerCount'] ?? 0,
            FontAwesomeIcons.moon,
            AppColors.info,
            200,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCountCard(
    String title,
    int count,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
          padding: EdgeInsets.all(24.r),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, size: 28.sp, color: color),
              ),
              SizedBox(height: 16.h),
              AnimatedBuilder(
                animation: _countAnimationController,
                builder: (context, child) {
                  final animatedValue =
                      Tween<double>(begin: 0, end: count.toDouble())
                          .animate(
                            CurvedAnimation(
                              parent: _countAnimationController,
                              curve: Interval(
                                0.2,
                                1.0,
                                curve: Curves.elasticOut,
                              ),
                            ),
                          )
                          .value;

                  return Text(
                    animatedValue.toInt().toString(),
                    style: AppTextStyles.heading3.copyWith(
                      color: color,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 36,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildPaymentHistoryCard(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment History', style: AppTextStyles.heading5),
                  SizedBox(height: 4.h),
                  Text(
                    'Last 6 months',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              Icon(
                FontAwesomeIcons.chartLine,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Payment History List with constrained height
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(6, (index) {
                  final month = DateTime.now().subtract(
                    Duration(days: index * 30),
                  );
                  final amount = (2500 + (index * 150)).toDouble();

                  return _buildPaymentHistoryItem(
                    DateFormat('MMM yyyy').format(month),
                    amount,
                    index == 0 ? 'Current' : 'Paid',
                    index,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideX(begin: 0.3);
  }

  Widget _buildPaymentHistoryItem(
    String month,
    double amount,
    String status,
    int index,
  ) {
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
              Container(
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
              ),
              SizedBox(width: 16.w),
              Expanded(
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
              ),
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

  Widget _buildMealRatesCard(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Current Meal Rates', style: AppTextStyles.heading5),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Effective from Dec 2024',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          Column(
            children: controller.mealRates
                .map(
                  (rate) => _buildMealRateItem(
                    rate,
                    controller.mealRates.indexOf(rate),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildMealRateItem(MealRate rate, int index) {
    final mealIcon = rate.mealType == MealType.breakfast
        ? FontAwesomeIcons.sun
        : FontAwesomeIcons.moon;
    final mealName = rate.mealType == MealType.breakfast
        ? 'Breakfast'
        : 'Dinner';
    final mealColor = rate.mealType == MealType.breakfast
        ? AppColors.warning
        : AppColors.info;

    return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: mealColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: mealColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: mealColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(mealIcon, size: 20.sp, color: Colors.white),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: AppTextStyles.subtitle1.copyWith(
                        color: mealColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Per meal cost',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _countAnimationController,
                builder: (context, child) {
                  final animatedValue = Tween<double>(begin: 0, end: rate.rate)
                      .animate(
                        CurvedAnimation(
                          parent: _countAnimationController,
                          curve: Interval(
                            0.3 + (index * 0.1),
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        ),
                      )
                      .value;

                  return Text(
                    '₹${animatedValue.toStringAsFixed(0)}',
                    style: AppTextStyles.heading4.copyWith(
                      color: mealColor,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 200 * index))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }

  void _downloadPDF() {
    // Implement PDF download functionality
    Get.snackbar(
      'Download Started',
      'Your billing PDF is being generated...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success.withOpacity(0.1),
      colorText: AppColors.success,
      duration: const Duration(seconds: 3),
      icon: Icon(FontAwesomeIcons.filePdf, color: AppColors.success),
    );
  }

  void _exportCSV() {
    // Implement CSV export functionality
    Get.snackbar(
      'Export Started',
      'Your billing data is being exported to CSV...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info.withOpacity(0.1),
      colorText: AppColors.info,
      duration: const Duration(seconds: 3),
      icon: Icon(FontAwesomeIcons.fileCsv, color: AppColors.info),
    );
  }
}
