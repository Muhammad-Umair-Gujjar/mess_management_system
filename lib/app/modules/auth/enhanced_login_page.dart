import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../app/widgets/common/reusable_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/auth_models.dart';
import 'controllers/auth_controller.dart';
import 'password_reset_page.dart';
import 'signup_page.dart';
import 'components/auth_dropdowns.dart';

class EnhancedLoginPage extends StatefulWidget {
  const EnhancedLoginPage({super.key});

  @override
  State<EnhancedLoginPage> createState() => _EnhancedLoginPageState();
}

class _EnhancedLoginPageState extends State<EnhancedLoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget? _cachedLoginForm; // Cache the form widget to avoid duplicate keys

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _getLoginForm() {
    if (_cachedLoginForm == null) {
      _cachedLoginForm = _buildLoginForm();
    }
    return _cachedLoginForm!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ResponsiveHelper.isMobile(context)
              ? _buildMobileLayout()
              : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      child: Column(
        children: [
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
          _buildHeader(),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
          _getLoginForm(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Hero content
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 2 : 1,
          child: _buildHeroSection(),
        ),
        // Right side - Login form
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 3 : 1,
          child: Container(
            color: Colors.white,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.isTablet(context) ? 400 : 500,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
                  vertical: ResponsiveHelper.getSpacing(context, 'large'),
                ),
                child: SingleChildScrollView(child: _getLoginForm()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'large'),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: ResponsiveHelper.getSpacing(context, 'medium'),
                offset: Offset(
                  0,
                  ResponsiveHelper.getSpacing(context, 'small'),
                ),
              ),
            ],
          ),
          child: Icon(
            FontAwesomeIcons.utensils,
            color: Colors.white,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
          ),
        ).animate().scale(delay: 300.ms),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

        // App Name
        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading1'),
            color: ResponsiveHelper.isMobile(context)
                ? Colors.black87
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // App Tagline
        Text(
          AppStrings.appTagline,
          style: AppTextStyles.body1.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
            color: ResponsiveHelper.isMobile(context)
                ? Colors.black87.withOpacity(0.9)
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xlarge')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

          // Features
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  '📊 Real-time Attendance Tracking',
                  '💳 Automated Billing System',
                  '🍽️ Dynamic Menu Management',
                  '📱 Multi-role Dashboard Access',
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  return Padding(
                        padding: EdgeInsets.only(
                          bottom: ResponsiveHelper.getSpacing(
                            context,
                            'medium',
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  ResponsiveHelper.getSpacing(context, 'small'),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getBorderRadius(
                                      context,
                                      'small',
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: AppColors.primary,
                                  size: ResponsiveHelper.getIconSize(
                                    context,
                                    'small',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getSpacing(
                                  context,
                                  'medium',
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  feature,
                                  style: AppTextStyles.body1.copyWith(
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      'body1',
                                    ),
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: (800 + index * 100).ms)
                      .slideX(begin: -0.3);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.isMobile(context)
            ? ResponsiveHelper.getSpacing(context, 'large')
            : ResponsiveHelper.getSpacing(context, 'xlarge'),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.isMobile(context)
              ? ResponsiveHelper.getBorderRadius(context, 'large')
              : ResponsiveHelper.getBorderRadius(context, 'medium'),
        ),
        boxShadow: ResponsiveHelper.isMobile(context)
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: ResponsiveHelper.getSpacing(context, 'large'),
                  offset: Offset(
                    0,
                    ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                ),
              ]
            : [],
      ),
      child: Form(
        key: authController.loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Welcome Back',
              style: AppTextStyles.heading3.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms).slideY(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

            Text(
              'Sign in to your account',
              style: AppTextStyles.body2.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 700.ms).slideY(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Role Selection
            _buildRoleSelection(),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

            // Email Field
            ReusableTextField(
              controller: emailController,
              type: TextFieldType.email,
              label: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: FontAwesomeIcons.envelope,
            ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Password Field
            ReusableTextField(
              controller: passwordController,
              type: TextFieldType.password,
              label: 'Password',
              hintText: 'Enter your password',
              prefixIcon: FontAwesomeIcons.lock,
            ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),

            // Remember Me & Forgot Password Row
            _buildRememberForgotRow(),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Login Button
            Obx(() => _buildLoginButton()),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

            // Sign Up Link
            _buildSignUpLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Obx(
      () => RoleSelectionDropdown(
        selectedRole: authController.selectedRole.value,
        onRoleChanged: authController.updateRole,
      ).animate().fadeIn(delay: 750.ms).slideX(begin: 0.3),
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Forgot Password
        TextButton(
          onPressed: () {
            Get.to(() => const PasswordResetPage());
          },
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.body2.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: ResponsiveHelper.getValue<double>(
        context,
        mobile: 60,
        tablet: 55,
        desktop: 55,
      ),
      child: ElevatedButton(
        onPressed: authController.isLoading.value
            ? null
            : () {
                // Login button pressed!
                // isLoading: ${authController.isLoading.value}
                _handleLogin();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getRoleColor(authController.selectedRole.value),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: _getRoleColor(
            authController.selectedRole.value,
          ).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
          ),
        ),
        child: authController.isLoading.value
            ? SizedBox(
                height: ResponsiveHelper.getIconSize(context, 'medium'),
                width: ResponsiveHelper.getIconSize(context, 'medium'),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getRoleIcon(authController.selectedRole.value),
                    size: ResponsiveHelper.isMobile(context)
                        ? ResponsiveHelper.getIconSize(context, 'medium')
                        : ResponsiveHelper.getIconSize(context, 'medium'),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  Flexible(
                    child: Text(
                      'Sign In as ${_getRoleTitle(authController.selectedRole.value)}',
                      style: AppTextStyles.button.copyWith(
                        fontSize: ResponsiveHelper.isMobile(context)
                            ? ResponsiveHelper.getFontSize(context, 'body1')
                            : ResponsiveHelper.getFontSize(context, 'button'),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3);
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.body2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const SignupPage());
          },
          child: Text(
            'Sign Up',
            style: AppTextStyles.body2.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms);
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return FontAwesomeIcons.graduationCap;
      case UserRole.staff:
        return FontAwesomeIcons.userTie;
      case UserRole.admin:
        return FontAwesomeIcons.userShield;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppColors.studentRole;
      case UserRole.staff:
        return AppColors.staffRole;
      case UserRole.admin:
        return AppColors.adminRole;
    }
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.staff:
        return 'Staff';
      case UserRole.admin:
        return 'Admin';
    }
  }

  void _handleLogin() {
    // _handleLogin() called in enhanced_login_page.dart

    // Basic validation
    if (emailController.text.trim().isEmpty) {
      // Email is empty
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      // Password is empty
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    // Call auth controller with form data
    authController.loginWithCredentials(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: authController.selectedRole.value,
    );
  }
}
