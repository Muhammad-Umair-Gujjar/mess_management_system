import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mess_management/app/widgets/common_widgets.dart';
import 'package:mess_management/app/widgets/custom_footer.dart';
import 'package:mess_management/core/constants/app_colors.dart';
import 'package:mess_management/core/constants/app_strings.dart';
import '../../data/models/feedback.dart';
import 'auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned.fill(
                    child: _buildBackgroundPattern(),
                  ),
                  // Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(),
                          const SizedBox(height: 60),
                          // Main Content
                          Expanded(
                            child: Row(
                              children: [
                                // Left Side - Hero Content
                                Expanded(
                                  child: _buildHeroContent(),
                                ),
                                const SizedBox(width: 40),
                                // Right Side - Login Options
                                Expanded(
                                  child: _buildLoginOptions(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return CustomPaint(
      painter: BackgroundPatternPainter(),
      child: Container(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.utensils,
                color: Colors.white,
                size: 24,
              ),
            ).animate().scale(delay:  300.ms ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3),
                Text(
                  AppStrings.appVersion,
                  style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
                ).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3),
              ],
            ),
          ],
        ),
        // Contact Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FontAwesomeIcons.headset,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Support: +92 123 456 7890',
                style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay:  300.ms ).slideX(begin: 0.3),
      ],
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Title
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Welcome to ${AppStrings.appName}',
              textStyle: Theme.of(Get.context!).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              speed: const  Duration(milliseconds: 300) ,
            ),
          ],
          totalRepeatCount: 1,
        ),
        const SizedBox(height: 24),
        
        // Tagline
        Text(
          AppStrings.appTagline,
          style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3),
        
        const SizedBox(height: 32),
        
        // Features List
        ...[
          '📊 Real-time Attendance Tracking',
          '💳 Automated Billing System',
          '🍽️ Dynamic Menu Management',
          '📱 Multi-role Dashboard Access',
        ].asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.check,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(delay: (1200 +  100 ).ms)
            .slideX(begin: -0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildLoginOptions() {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            AppStrings.selectRole,
            style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay:  300.ms ).slideY(begin: -0.3),
          
          const SizedBox(height: 40),
          
          // Role Cards
          ..._buildRoleCards(),
          
          const SizedBox(height: 32),
          
          // Demo Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.circleInfo,
                  color: AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This is a demo application with dummy data',
                    style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay:  300.ms ).slideY(begin: 0.3),
        ],
      ),
    );
  }

  List<Widget> _buildRoleCards() {
    final roles = [
      {
        'role': UserRole.student,
        'title': AppStrings.student,
        'subtitle': 'View attendance, billing & menu',
        'icon': FontAwesomeIcons.graduationCap,
        'color': AppColors.studentRole,
        'userName': 'Ali Ahmed',
      },
      {
        'role': UserRole.staff,
        'title': AppStrings.staff,
        'subtitle': 'Mark attendance & generate reports',
        'icon': FontAwesomeIcons.userTie,
        'color': AppColors.staffRole,
        'userName': 'Muhammad Usman',
      },
      {
        'role': UserRole.admin,
        'title': AppStrings.admin,
        'subtitle': 'Manage system & analytics',
        'icon': FontAwesomeIcons.userShield,
        'color': AppColors.adminRole,
        'userName': 'Dr. Hassan Ali',
      },
    ];

    return roles.asMap().entries.map((entry) {
      final index = entry.key;
      final role = entry.value;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Obx(() => GradientButton(
          text: 'Login as ${role['title']}',
          icon: role['icon'] as IconData,
          gradientColors: [
            (role['color'] as Color),
            (role['color'] as Color).withOpacity(0.7),
          ],
          onPressed: authController.isLoading.value ? null : () {
            authController.login(
              role['role'] as UserRole,
              role['userName'] as String,
            );
          },
          isLoading: authController.isLoading.value,
        )),
      ).animate()
        .fadeIn(delay: (800 +  100 ).ms)
        .slideX(begin: 0.3);
    }).toList();
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw floating circles
    for (int i = 0; i < 20; i++) {
      final x = (i * 100.0) % size.width;
      final y = (i * 150.0) % size.height;
      final radius = 20 + (i % 3) * 10.0;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    
    // Draw gradient overlay
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary.withOpacity(0.02),
        AppColors.secondary.withOpacity(0.02),
      ],
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



