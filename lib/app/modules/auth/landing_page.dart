import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveHelper.isMobile(context)
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top:
                        ResponsiveHelper.getSpacing(context, 'large') * 3, // Extra top padding for mobile
                    bottom: ResponsiveHelper.getSpacing(context, 'large'),
                    left: ResponsiveHelper.getSpacing(context, 'medium'),
                    right: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(context),
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(context, 'large'),
                      ),
                      _buildMobileLayout(context),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(context),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context, 'large'),
                    ),
                    _buildDesktopLayout(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Choose Your Role',
      style: AppTextStyles.heading1.copyWith(
        color: const Color(0xFF2D3748),
        fontSize: ResponsiveHelper.getFontSize(context, 'heading1'),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Mobile layout - vertical stack for role cards
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'large'),
      ),
      child: Column(
        children: [
          _buildRoleCard(
            context,
            'Student',
            'Access your meal plans, attendance, and billing',
            FontAwesomeIcons.graduationCap,
            const Color(0xFF3182CE),
            () => Get.toNamed('/student'),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          _buildRoleCard(
            context,
            'Mess Staff',
            'Mark attendance, manage daily operations',
            FontAwesomeIcons.userTie,
            const Color(0xFF38A169),
            () => Get.toNamed('/staff'),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          _buildRoleCard(
            context,
            'Administrator',
            'Full system control, analytics, and management',
            FontAwesomeIcons.userShield,
            const Color(0xFFE53E3E),
            () => Get.toNamed('/admin'),
          ),
        ],
      ),
    );
  }

  /// Desktop/Tablet layout - horizontal row for role cards
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRoleCard(
          context,
          'Student',
          'Access your meal plans, attendance, and billing',
          FontAwesomeIcons.graduationCap,
          const Color(0xFF3182CE),
          () => Get.toNamed('/student'),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        _buildRoleCard(
          context,
          'Mess Staff',
          'Mark attendance, manage daily operations',
          FontAwesomeIcons.userTie,
          const Color(0xFF38A169),
          () => Get.toNamed('/staff'),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        _buildRoleCard(
          context,
          'Administrator',
          'Full system control, analytics, and management',
          FontAwesomeIcons.userShield,
          const Color(0xFFE53E3E),
          () => Get.toNamed('/admin'),
        ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
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
          width: ResponsiveHelper.isMobile(context)
              ? double.infinity
              : ResponsiveHelper.getValue<double>(
                  context,
                  mobile: 150,
                  tablet: 210,
                  desktop: 240,
                ),
          height: ResponsiveHelper.getValue<double>(
            context,
            mobile: 200,
            tablet: 300,
            desktop: 300,
          ),
          padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, 'large'),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.13),
                spreadRadius: 2,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: ResponsiveHelper.getIconSize(context, 'largeIcon'),
                height: ResponsiveHelper.getIconSize(context, 'largeIcon'),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'medium'),
                  ),
                ),
                child: Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(context, 'medium'),
                  color: color,
                ),
              ),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

              // Title
              Text(
                title,
                style: AppTextStyles.heading4.copyWith(
                  color: const Color(0xFF2D3748),
                  fontSize: ResponsiveHelper.getFontSize(context, 'heading4'),
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

              // Description
              Text(
                description,
                style: AppTextStyles.body2.copyWith(
                  color: const Color(0xFF718096),
                  fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Access Button
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.getPadding(context, 'small'),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'small'),
                  ),
                ),
                child: Text(
                  'Access Dashboard',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, 'button'),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




