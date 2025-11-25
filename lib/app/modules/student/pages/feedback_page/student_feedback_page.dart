import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../student_controller.dart';
import 'components/feedback_form.dart';
import 'components/recent_feedbacks.dart';

class StudentFeedbackPage extends StatefulWidget {
  const StudentFeedbackPage({super.key});

  @override
  State<StudentFeedbackPage> createState() => _StudentFeedbackPageState();
}

class _StudentFeedbackPageState extends State<StudentFeedbackPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: _buildMobileLayout(controller),
        desktop: _buildDesktopLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FeedbackForm(),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: RecentFeedbacks(controller: controller),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: SingleChildScrollView(child: FeedbackForm()),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),
          Expanded(flex: 3, child: RecentFeedbacks(controller: controller)),
        ],
      ),
    );
  }
}
