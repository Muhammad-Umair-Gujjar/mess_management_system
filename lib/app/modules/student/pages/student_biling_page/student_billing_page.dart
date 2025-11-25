import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/utils/toast_message.dart';
import '../../student_controller.dart';
import 'components/current_bill_card.dart';
import 'components/meal_count_cards.dart';
import 'components/payment_history_card.dart';
import 'components/meal_rates_card.dart';

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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
          CurrentBillCard(
            controller: controller,
            countAnimationController: _countAnimationController,
            onDownloadPDF: _downloadPDF,
            onExportCSV: _exportCSV,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          MealCountCards(
            controller: controller,
            countAnimationController: _countAnimationController,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          PaymentHistoryCard(controller: controller),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          MealRatesCard(
            controller: controller,
            countAnimationController: _countAnimationController,
          ),
          SizedBox(
            height: ResponsiveHelper.getSpacing(context, 'medium'),
          ), // Add bottom padding
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
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurrentBillCard(
                  controller: controller,
                  countAnimationController: _countAnimationController,
                  onDownloadPDF: _downloadPDF,
                  onExportCSV: _exportCSV,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                MealCountCards(
                  controller: controller,
                  countAnimationController: _countAnimationController,
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PaymentHistoryCard(controller: controller),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                MealRatesCard(
                  controller: controller,
                  countAnimationController: _countAnimationController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPDF() {
    // Implement PDF download functionality
    ToastMessage.success('Your billing PDF is being generated...');
  }

  void _exportCSV() {
    // Implement CSV export functionality
    ToastMessage.info('Your billing data is being exported to CSV...');
  }
}
