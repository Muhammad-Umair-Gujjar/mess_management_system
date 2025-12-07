import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';
import '../../../../user/user_controller.dart';
import '../../../../../data/models/auth_models.dart';

class WelcomeCard extends StatelessWidget {
  final StudentController controller;

  const WelcomeCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      decoration: AppDecorations.gradientContainer(
        gradient: AppColors.primaryGradient,
      ),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeContent(context, greeting),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
            _buildWelcomeAvatar(context),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildWelcomeContent(context, greeting)),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'xlarge')),
            _buildWelcomeAvatar(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
  }

  Widget _buildWelcomeContent(BuildContext context, String greeting) {
    return GetX<UserController>(
      builder: (userController) {
        final user = userController.currentUser.value;
        final studentData = userController.currentStudentData.value;
        String name = user?.fullName ?? 'Loading...';
        String hostelInfo = 'Loading hostel info...';

        if (user != null &&
            user.role == UserRole.student &&
            studentData != null) {
          final hostelName = studentData.hostel;
          final roomNumber = studentData.roomNumber;
          if (hostelName.isNotEmpty && roomNumber.isNotEmpty) {
            hostelInfo = '$hostelName • Room $roomNumber';
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting 👋',
              style: AppTextStyles.heading5.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              name,
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                vertical: ResponsiveHelper.getSpacing(context, 'small'),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'large'),
                ),
              ),
              child: Text(
                hostelInfo,
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              'Welcome back! Check your meal attendance, view today\'s menu, and manage your billing.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeAvatar(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'padding'),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'large'),
        ),
      ),
      child: Icon(
        FontAwesomeIcons.graduationCap,
        size: ResponsiveHelper.getIconSize(context, 'medium'),
        color: Colors.white,
      ),
    ).animate().scale(delay: 300.ms);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
