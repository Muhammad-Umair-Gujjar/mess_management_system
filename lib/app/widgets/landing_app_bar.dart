import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/utils/toast_message.dart';
import '../../core/utils/responsive_helper.dart';

class LandingAppBar extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const LandingAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getComponentDimension(context, 'appBarHeight'),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'large'),
        vertical: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: ResponsiveHelper.getBorderRadius(context, 'large'),
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
          ),
          child: Row(
            children: [
              // Logo and Brand
              _buildLogo().animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),

              const Spacer(),

              // Navigation Menu
              _buildNavigationMenu()
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: -0.3),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),

              // Action Buttons
              _buildActionButtons()
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideX(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return IntrinsicWidth(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: AppDecorations.gradientContainer(
              gradient: AppColors.primaryGradient,
            ),
            child: Icon(
              FontAwesomeIcons.utensils,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          SizedBox(width: 16.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Hostel Mess Management',
                    style: AppTextStyles.heading5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Smart Mess Management',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return Row(
      children: [
        _buildNavItem(
          'Features',
          Icons.star_outline,
          () => _scrollToSection('features'),
        ),
        SizedBox(width: 32.0),
        _buildNavItem(
          'About',
          Icons.info_outline,
          () => _scrollToSection('about'),
        ),
        SizedBox(width: 32.0),
        _buildNavItem(
          'Contact',
          Icons.contact_support_outlined,
          () => _scrollToSection('contact'),
        ),
      ],
    );
  }

  Widget _buildNavItem(String title, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: Row(
            children: [
              Icon(icon, size: 16.0, color: AppColors.textSecondary),
              SizedBox(width: 8.0),
              Text(title, style: AppTextStyles.navMenuItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Login Button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Get.toNamed('/login'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Login',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primary,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 16.0),

        // Quick Access Button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showQuickAccessDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              decoration: AppDecorations.gradientContainer(
                gradient: AppColors.primaryGradient,
              ),
              child: Row(
                children: [
                  Icon(Icons.dashboard, color: Colors.white, size: 16.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Quick Access',
                    style: AppTextStyles.button.copyWith(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _scrollToSection(String section) {
    // In a real implementation, this would scroll to the specific section
    ToastMessage.info('Scrolling to $section section');
  }

  void _showQuickAccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400.0,
          padding: EdgeInsets.all(32.0),
          decoration: AppDecorations.glassmorphicContainer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quick Access', style: AppTextStyles.heading4),
              SizedBox(height: 24.0),
              Text(
                'Select your role to continue',
                style: AppTextStyles.subtitle2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.0),
              Column(
                children: [
                  _buildQuickAccessButton(
                    'Student Dashboard',
                    FontAwesomeIcons.graduationCap,
                    AppColors.studentRole,
                    () => Get.offNamed('/student'),
                  ),
                  SizedBox(height: 16.0),
                  _buildQuickAccessButton(
                    'Mess Staff',
                    FontAwesomeIcons.userTie,
                    AppColors.staffRole,
                    () => Get.offNamed('/staff'),
                  ),
                  SizedBox(height: 16.0),
                  _buildQuickAccessButton(
                    'Administrator',
                    FontAwesomeIcons.userShield,
                    AppColors.adminRole,
                    () => Get.offNamed('/admin'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildQuickAccessButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Get.back(); // Close dialog
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: Colors.white, size: 20.0),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
