import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../../core/theme/app_decorations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/landing_app_bar.dart';
import 'login_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: AppDecorations.backgroundGradient(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Landing App Bar
              const LandingAppBar(showBackButton: false),

              // Hero Section
              _buildHeroSection(controller),

              // Role Selection Section
              _buildRoleSelectionSection(controller),

              // Features Section
              _buildFeaturesSection(),

              // Statistics Section
              _buildStatisticsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(LoginController controller) {
    return Container(
      constraints: BoxConstraints(minHeight: 60.h),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      child: Row(
        children: [
          // Left Side - Text Content
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Title
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'MessMaster',
                        textStyle: AppTextStyles.heroTitle.copyWith(
                          foreground: Paint()
                            ..shader = AppColors.primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 70),
                            ),
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),

                  SizedBox(height: 16.h),

                  // Subtitle
                  Text(
                        'Smart Meal Attendance & Billing System',
                        style: AppTextStyles.heroSubtitle,
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 500.ms)
                      .slideX(begin: -0.3),

                  SizedBox(height: 24.h),

                  // Description
                  Container(
                        padding: EdgeInsets.all(24.r),
                        decoration: AppDecorations.glassmorphicContainer(
                          opacity: 0.1,
                        ),
                        child: Text(
                          'Streamline your hostel mess management with our comprehensive solution. '
                          'Track attendance, manage billing, plan meals, and gather feedback - all in one place.',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 18.sp,
                            height: 1.6,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 800.ms)
                      .slideY(begin: 0.3),

                  SizedBox(height: 40.h),

                  // CTA Buttons
                  Row(
                    children: [
                      _buildGradientButton(
                            'Get Started',
                            Icons.rocket_launch,
                            AppColors.primaryGradient,
                            () => _showRoleSelection(),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 1200.ms)
                          .scale(begin: const Offset(0.8, 0.8)),

                      SizedBox(width: 20.w),

                      _buildOutlineButton(
                            'Learn More',
                            Icons.info_outline,
                            () => _scrollToFeatures(),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 1400.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 40.w),

          // Right Side - Lottie Animation
          Expanded(
            flex: 4,
            child:
                Container(
                      height: 60.h,
                      decoration: AppDecorations.glassmorphicContainer(
                        opacity: 0.1,
                      ),
                      child: _buildHeroAnimation(),
                    )
                    .animate()
                    .fadeIn(duration: 1000.ms, delay: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAnimation() {
    return Container(
      padding: EdgeInsets.all(40.r),
      decoration: AppDecorations.glassmorphicContainer(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main Icon
          Container(
                padding: EdgeInsets.all(32.r),
                decoration: AppDecorations.gradientContainer(
                  gradient: AppColors.primaryGradient,
                ),
                child: Icon(
                  FontAwesomeIcons.utensils,
                  size: 80.sp,
                  color: Colors.white,
                ),
              )
              .animate()
              .scale(duration: 1000.ms)
              .then()
              .shimmer(duration: 2000.ms),

          SizedBox(height: 24.h),

          // Floating Food Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFloatingIcon(
                FontAwesomeIcons.bowlFood,
                AppColors.accent,
                0.ms,
              ),
              _buildFloatingIcon(
                FontAwesomeIcons.pizzaSlice,
                AppColors.success,
                200.ms,
              ),
              _buildFloatingIcon(
                FontAwesomeIcons.burger,
                AppColors.warning,
                400.ms,
              ),
              _buildFloatingIcon(
                FontAwesomeIcons.coffee,
                AppColors.info,
                600.ms,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, Duration delay) {
    return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(icon, size: 32.sp, color: color),
        )
        .animate(delay: delay)
        .fadeIn(duration: 600.ms)
        .moveY(begin: 20.h, end: -20.h, duration: 2000.ms)
        .then()
        .moveY(begin: -20.h, end: 20.h, duration: 2000.ms);
  }

  Widget _buildRoleSelectionSection(LoginController controller) {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Text(
            'Choose Your Role',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

          SizedBox(height: 16.h),

          Text(
                'Select your role to access the appropriate dashboard',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideY(begin: 0.3),

          SizedBox(height: 48.h),

          // Role Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoleCard(
                    'Student',
                    'Access your meal plans, attendance, and billing',
                    FontAwesomeIcons.graduationCap,
                    AppColors.studentRole,
                    () => Get.toNamed('/student'),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.3),

              SizedBox(width: 32.w),

              _buildRoleCard(
                    'Mess Staff',
                    'Mark attendance, manage daily operations',
                    FontAwesomeIcons.userTie,
                    AppColors.staffRole,
                    () => Get.toNamed('/staff'),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.3),

              SizedBox(width: 32.w),

              _buildRoleCard(
                    'Administrator',
                    'Full system control, analytics, and management',
                    FontAwesomeIcons.userShield,
                    AppColors.adminRole,
                    () => Get.toNamed('/admin'),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms)
                  .slideY(begin: 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Text(
            'Powerful Features',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

          SizedBox(height: 48.h),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 24.h,
            crossAxisSpacing: 24.w,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                'Smart Attendance',
                'Automated meal attendance tracking with QR codes and manual marking',
                FontAwesomeIcons.qrcode,
                AppColors.primary,
              ),
              _buildFeatureCard(
                'Billing Management',
                'Automatic bill calculation based on attendance and meal rates',
                FontAwesomeIcons.receipt,
                AppColors.accent,
              ),
              _buildFeatureCard(
                'Menu Planning',
                'Weekly menu planning with nutritional information and preferences',
                FontAwesomeIcons.calendarDays,
                AppColors.success,
              ),
              _buildFeatureCard(
                'Real-time Analytics',
                'Comprehensive dashboard with attendance trends and insights',
                FontAwesomeIcons.chartLine,
                AppColors.info,
              ),
              _buildFeatureCard(
                'Feedback System',
                'Collect and analyze student feedback to improve meal quality',
                FontAwesomeIcons.star,
                AppColors.warning,
              ),
              _buildFeatureCard(
                'Mobile Responsive',
                'Access from any device with our responsive web application',
                FontAwesomeIcons.mobileScreen,
                AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: AppDecorations.glassmorphicContainer(opacity: 0.05),
      child: Column(
        children: [
          Text(
            'Trusted by Universities Worldwide',
            style: AppTextStyles.heading3,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

          SizedBox(height: 48.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('500+', 'Active Students', FontAwesomeIcons.users),
              _buildStatCard('50+', 'Mess Staff', FontAwesomeIcons.userGroup),
              _buildStatCard('25+', 'Universities', FontAwesomeIcons.building),
              _buildStatCard('99.9%', 'Uptime', FontAwesomeIcons.clock),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(
    String text,
    IconData icon,
    Gradient gradient,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: AppDecorations.gradientContainer(gradient: gradient),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(text, style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  text,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 320.w,
          padding: EdgeInsets.all(32.r),
          decoration: AppDecorations.hoverContainer(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: AppDecorations.gradientContainer(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: Icon(icon, size: 48.sp, color: Colors.white),
              ),

              SizedBox(height: 24.h),

              Text(title, style: AppTextStyles.cardTitle),

              SizedBox(height: 12.h),

              Text(
                description,
                style: AppTextStyles.cardSubtitle,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Access Dashboard',
                  style: AppTextStyles.button.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, size: 32.sp, color: color),
          ),

          SizedBox(height: 16.h),

          Text(
            title,
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            description,
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildStatCard(String number, String label, IconData icon) {
    return Column(
          children: [
            Icon(icon, size: 32.sp, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              number,
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.subtitle2),
          ],
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 400.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  void _showRoleSelection() {
    // Scroll to role selection section
    // This would normally use a scroll controller, but for simplicity we'll navigate directly
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(32.r),
          decoration: AppDecorations.glassmorphicContainer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Your Role', style: AppTextStyles.heading3),
              SizedBox(height: 24.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuickRoleButton(
                    'Student',
                    FontAwesomeIcons.graduationCap,
                    () => Get.toNamed('/student'),
                  ),
                  SizedBox(width: 16.w),
                  _buildQuickRoleButton(
                    'Staff',
                    FontAwesomeIcons.userTie,
                    () => Get.toNamed('/staff'),
                  ),
                  SizedBox(width: 16.w),
                  _buildQuickRoleButton(
                    'Admin',
                    FontAwesomeIcons.userShield,
                    () => Get.toNamed('/admin'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildQuickRoleButton(String role, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: AppDecorations.neumorphicContainer(),
        child: Column(
          children: [
            Icon(icon, size: 24.sp, color: AppColors.primary),
            SizedBox(height: 8.h),
            Text(role, style: AppTextStyles.subtitle2),
          ],
        ),
      ),
    );
  }

  void _scrollToFeatures() {
    // In a real implementation, this would scroll to the features section
    Get.snackbar(
      'Info',
      'Features section is below',
      backgroundColor: AppColors.info.withOpacity(0.9),
      colorText: Colors.white,
    );
  }
}
