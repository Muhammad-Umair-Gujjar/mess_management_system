import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../app/widgets/common/reusable_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'enhanced_login_page.dart';
import 'components/auth_helpers.dart';
import 'components/auth_widgets.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();

  bool isEmailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Reset Password',
          style: AppTextStyles.heading5.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
          _buildResetForm(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Hero content
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 1 : 1,
          child: _buildHeroSection(),
        ),
        // Right side - Reset form
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 2 : 1,
          child: Container(
            color: Colors.white.withOpacity(0.95),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'xlarge'),
                ),
                child: _buildResetForm(),
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
        // Icon
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
            FontAwesomeIcons.key,
            color: Colors.white,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
          ),
        ).animate().scale(delay: 300.ms),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

        // Title
        Text(
          'Forgot Password?',
          style: AppTextStyles.heading2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading2'),
            color: ResponsiveHelper.isMobile(context)
                ? Colors.black87
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // Subtitle
        Text(
          "No worries! Enter your email and we'll \nsend you reset instructions",
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Steps
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    '📧 Enter your email address',
                    '✉️ Check your inbox',
                    '🔗 Click the reset link',
                    '🔐 Create new password',
                    '✅ Sign in with new password',
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
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
                                    ResponsiveHelper.getSpacing(
                                      context,
                                      'small',
                                    ),
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
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTextStyles.body2.copyWith(
                                      fontSize: ResponsiveHelper.getFontSize(
                                        context,
                                        'body2',
                                      ),
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
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
                                    step,
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
      ),
    );
  }

  Widget _buildResetForm() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'large'),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveHelper.getSpacing(context, 'large'),
            offset: Offset(0, ResponsiveHelper.getSpacing(context, 'small')),
          ),
        ],
      ),
      child: isEmailSent ? _buildSuccessState() : _buildEmailForm(),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title (for mobile)
        if (ResponsiveHelper.isMobile(context)) ...[
          Text(
            'Reset Password',
            style: AppTextStyles.heading3.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms).slideY(begin: -0.3),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

          Text(
            'Enter your email to receive reset instructions',
            style: AppTextStyles.body2.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 700.ms).slideY(begin: -0.3),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
        ],

        // Email Field
        ReusableTextField(
          controller: emailController,
          type: TextFieldType.email,
          label: 'Email Address',
          hintText: 'Enter your registered email',
          prefixIcon: FontAwesomeIcons.envelope,
          autofocus: true,
        ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

        // Send Reset Button
        Obx(() => _buildSendResetButton()),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

        // Back to Sign In Link
        _buildBackToSignInLink(),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success Icon
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'large'),
            ),
          ),
          child: Icon(
            FontAwesomeIcons.circleCheck,
            color: AppColors.success,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
          ),
        ).animate().scale(delay: 300.ms),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

        // Success Title
        Text(
          'Check Your Email',
          style: AppTextStyles.heading3.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        // Success Message
        Text(
          "We've sent password reset instructions to\n${emailController.text.trim()}",
          style: AppTextStyles.body1.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

        // Resend Button
        TextButton(
          onPressed: () {
            setState(() {
              isEmailSent = false;
            });
          },
          child: Text(
            'Send Again',
            style: AppTextStyles.body2.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

        // Back to Sign In Button
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.getValue<double>(
            context,
            mobile: 50,
            tablet: 55,
            desktop: 60,
          ),
          child: ElevatedButton(
            onPressed: () {
              Get.off(() => const EnhancedLoginPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: AppColors.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'medium'),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: ResponsiveHelper.getIconSize(context, 'medium'),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                Text(
                  'Back to Sign In',
                  style: AppTextStyles.button.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'button'),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildSendResetButton() {
    return SizedBox(
      height: ResponsiveHelper.getValue<double>(
        context,
        mobile: 60,
        tablet: 55,
        desktop: 60,
      ),
      child: ElevatedButton(
        onPressed: authController.isLoading.value
            ? null
            : () => _handlePasswordReset(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.3),
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
                    FontAwesomeIcons.paperPlane,
                    size: ResponsiveHelper.isMobile(context)
                        ? ResponsiveHelper.getIconSize(context, 'small')
                        : ResponsiveHelper.getIconSize(context, 'medium'),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  Flexible(
                    child: Text(
                      'Send Reset Instructions',
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
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3);
  }

  Widget _buildBackToSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remember your password? ',
          style: AppTextStyles.body2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.off(() => const EnhancedLoginPage());
          },
          child: Text(
            'Sign In',
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

  void _handlePasswordReset() {
    // Basic validation
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    // Call auth controller
    authController.resetPassword(
      email: emailController.text.trim(),
      onSuccess: () {
        setState(() {
          isEmailSent = true;
        });
      },
    );
  }
}
