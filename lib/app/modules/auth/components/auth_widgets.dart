import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isMobile;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
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
            icon,
            color: Colors.white,
            size: ResponsiveHelper.getIconSize(context, 'xlarge'),
          ),
        ).animate().scale(delay: 300.ms),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

        // Title
        Text(
          title,
          style: AppTextStyles.heading1.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading1'),
            color: isMobile ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.body1.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
            color: isMobile
                ? Colors.white.withOpacity(0.9)
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
      ],
    );
  }
}

class AuthFormContainer extends StatelessWidget {
  final Widget child;

  const AuthFormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getValue<double>(
        context,
        mobile: 50,
        tablet: 55,
        desktop: 60,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'medium'),
            ),
          ),
        ),
        child: isLoading
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
                    icon,
                    size: ResponsiveHelper.getIconSize(context, 'medium'),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 'button'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AuthHeroFeatures extends StatelessWidget {
  final List<String> features;

  const AuthHeroFeatures({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'small'),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'small'),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  color: AppColors.primary,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              Expanded(
                child: Text(
                  feature,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (800 + index * 100).ms).slideX(begin: -0.3);
      }).toList(),
    );
  }
}
