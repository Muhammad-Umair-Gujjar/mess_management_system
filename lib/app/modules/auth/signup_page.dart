import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../app/widgets/common/reusable_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'enhanced_login_page.dart';
import 'components/auth_helpers.dart';
import 'components/auth_widgets.dart';
import 'components/auth_dropdowns.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController roomNumberController = TextEditingController();

  String selectedHostel = 'Abubakr Hostel';
  final List<String> hostels = ['Abubakr Hostel', 'Usman Hostel', 'Ali Hostel'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    rollNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    roomNumberController.dispose();
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
          'Create Account',
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
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildSignupForm(context),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Hero content
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 2 : 1,
          child: _buildHeroSection(context),
        ),
        // Right side - Signup form
        Expanded(
          flex: ResponsiveHelper.isTablet(context) ? 3 : 1,
          child: Container(
            color: Colors.white,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.isTablet(context) ? 500 : 600,
                  maxHeight: MediaQuery.of(context).size.height * 0.95,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
                    vertical: ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  child: _buildSignupForm(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              FontAwesomeIcons.userPlus,
              color: Colors.white,
              size: ResponsiveHelper.getIconSize(context, 'xlarge'),
            ),
          ).animate().scale(delay: 300.ms),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

          // Title
          Center(
            child: Text(
              'Join ${AppStrings.appName}',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 'heading2'),
                color: ResponsiveHelper.isMobile(context)
                    ? Colors.black87
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

          // Subtitle
          Text(
            'Create your account to get started',
            style: AppTextStyles.body1.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
              color: ResponsiveHelper.isMobile(context)
                  ? Colors.black87.withOpacity(0.9)
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xlarge')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

          // Benefits
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  '🎓 Student Portal Access',
                  '📊 Real-time Updates',
                  '💰 Billing Management',
                  '🍽️ Menu Preferences',
                  '📱 Mobile Friendly',
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final benefit = entry.value;
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
                                  benefit,
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

  Widget _buildSignupForm(BuildContext context) {
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
        key: authController.signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title (for mobile)
            if (ResponsiveHelper.isMobile(context)) ...[
              Text(
                'Create Account',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 'heading3'),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms).slideY(begin: -0.3),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),
            ],

            // First Name & Last Name Row
            Row(
              children: [
                Expanded(
                  child: ReusableTextField(
                    controller: firstNameController,
                    label: 'First Name',
                    hintText: 'Enter first name',
                    prefixIcon: FontAwesomeIcons.user,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
                Expanded(
                  child: ReusableTextField(
                    controller: lastNameController,
                    label: 'Last Name',
                    hintText: 'Enter last name',
                    prefixIcon: FontAwesomeIcons.user,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Roll No
            ReusableTextField(
              controller: rollNoController,
              label: 'Roll Number',
              hintText: 'Enter your roll number',
              prefixIcon: FontAwesomeIcons.hashtag,
            ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Email
            ReusableTextField(
              controller: emailController,
              type: TextFieldType.email,
              label: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: FontAwesomeIcons.envelope,
            ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Password
            ReusableTextField(
              controller: passwordController,
              type: TextFieldType.password,
              label: 'Password',
              hintText: 'Enter password',
              prefixIcon: FontAwesomeIcons.lock,
            ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Confirm Password
            ReusableTextField(
              controller: confirmPasswordController,
              type: TextFieldType.password,
              label: 'Confirm Password',
              hintText: 'Confirm password',
              prefixIcon: FontAwesomeIcons.lock,
            ).animate().fadeIn(delay: 1100.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Hostel Selection
            _buildHostelSelection(context),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            // Room Number
            ReusableTextField(
              controller: roomNumberController,
              label: 'Room Number',
              hintText: 'Enter room number',
              prefixIcon: FontAwesomeIcons.doorOpen,
              type: TextFieldType.number,
            ).animate().fadeIn(delay: 1300.ms).slideX(begin: -0.3),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Register Button
            Obx(() => _buildRegisterButton(context)),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

            // Sign In Link
            _buildSignInLink(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHostelSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hostel Name',
          style: AppTextStyles.body2.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedHostel,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'large'),
                vertical: ResponsiveHelper.getSpacing(context, 'medium'),
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                FontAwesomeIcons.building,
                color: AppColors.primary,
                size: ResponsiveHelper.getIconSize(context, 'medium'),
              ),
            ),
            items: hostels.map((hostel) {
              return DropdownMenuItem(
                value: hostel,
                child: Text(
                  hostel,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedHostel = value;
                });
              }
            },
            style: AppTextStyles.body1.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms).slideX(begin: 0.3);
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getValue<double>(
        context,
        mobile: 55,
        tablet: 55,
        desktop: 60,
      ),
      child: ElevatedButton(
        onPressed: authController.isLoading.value
            ? null
            : () {
                // Signup button pressed!
                // isLoading: ${authController.isLoading.value}
                _handleSignup();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.studentRole,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.studentRole.withOpacity(0.3),
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
                    FontAwesomeIcons.userPlus,
                    size: ResponsiveHelper.isMobile(context)
                        ? ResponsiveHelper.getIconSize(context, 'small')
                        : ResponsiveHelper.getIconSize(context, 'medium'),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  Flexible(
                    child: Text(
                      'Create Account',
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
    ).animate().fadeIn(delay: 1500.ms).slideY(begin: 0.3);
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
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
    ).animate().fadeIn(delay: 1600.ms);
  }

  void _handleSignup() {
    // _handleSignup() called in signup_page.dart

    // Validation
    if (_validateForm()) {
      print(
        '✅ DEBUG: Form validation passed, calling authController.signUp...',
      );
      authController.signUp(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        rollNo: rollNoController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        hostel: selectedHostel,
        roomNumber: roomNumberController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );
    } else {
      // Form validation failed
    }
  }

  bool _validateForm() {
    if (firstNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your first name');
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your last name');
      return false;
    }

    if (rollNoController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your roll number');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a password');
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }

    if (roomNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your room number');
      return false;
    }

    return true;
  }
}
