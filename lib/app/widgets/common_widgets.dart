import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import 'responsive/responsive_widgets.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveBorderRadius =
        borderRadius ?? ResponsiveHelper.getBorderRadius(context, 'card');
    final responsivePadding =
        padding ?? ResponsiveHelper.getCardPadding(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: GlassmorphicContainer(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: responsiveBorderRadius,
          blur: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 15.0,
            tablet: 18.0,
            desktop: 20.0,
          ),
          alignment: Alignment.bottomCenter,
          border: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 1.5,
            tablet: 1.8,
            desktop: 2.0,
          ),
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.glassBackground,
              AppColors.glassBackground.withOpacity(0.1),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.glassBorder,
              AppColors.glassBorder.withOpacity(0.1),
            ],
          ),
          child: Padding(padding: responsivePadding, child: child),
        ),
      ),
    ).animate().fadeIn(duration:  300.ms ).scale(delay:  300.ms );
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final List<Color>? gradientColors;

  const AnimatedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.gradientColors,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        widget.padding ?? ResponsiveHelper.getCardPadding(context);
    final responsiveMargin =
        widget.margin ?? ResponsiveHelper.getMargin(context, 'small');
    final responsiveBorderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'card',
    );

    return Container(
      width: widget.width,
      height: widget.height,
      margin: responsiveMargin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const  Duration(milliseconds: 300) ,
            transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
            decoration: BoxDecoration(
              color: widget.color ?? AppColors.cardBackground,
              gradient: widget.gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.gradientColors!,
                    )
                  : null,
              borderRadius: BorderRadius.circular(responsiveBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.shadowLight,
                  blurRadius: _isHovered
                      ? ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        )
                      : ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 6.0,
                          tablet: 7.0,
                          desktop: 8.0,
                        ),
                  offset: Offset(
                    0,
                    _isHovered
                        ? ResponsiveHelper.getResponsiveSpacing(
                            context,
                            mobile: 6.0,
                            tablet: 7.0,
                            desktop: 8.0,
                          )
                        : ResponsiveHelper.getResponsiveSpacing(
                            context,
                            mobile: 3.0,
                            tablet: 3.5,
                            desktop: 4.0,
                          ),
                  ),
                ),
              ],
            ),
            child: Padding(padding: responsivePadding, child: widget.child),
          ),
        ),
      ),
    ).animate().fadeIn(duration:  300.ms ).slideY(begin: 0.3, delay:  300.ms );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      gradientColors: [color.withOpacity(0.1), color.withOpacity(0.05)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: ResponsiveHelper.getPadding(context, 'small'),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, 'medium'),
                  ),
                ),
                child: ResponsiveIcon(
                  icon: icon,
                  color: color,
                  sizeType: 'medium',
                ),
              ),
              if (onTap != null)
                ResponsiveIcon(
                  icon: Icons.arrow_forward_ios,
                  color: AppColors.textLight,
                  sizeType: 'small',
                ),
            ],
          ),

          ResponsiveSpacing(spacingType: 'sectionMargin'),

          ResponsiveText(
            text: value,
            styleType: 'heading3',
            color: color,
            fontWeight: FontWeight.bold,
          ).animate().fadeIn(delay:  300.ms ).slideX(begin: 0.3),

          ResponsiveSpacing(spacingType: 'itemSpacing'),

          ResponsiveText(
            text: title,
            styleType: 'subtitle2',
            color: AppColors.textSecondary,
          ),

          if (subtitle != null) ...[
            ResponsiveSpacing(spacingType: 'xs'),
            ResponsiveText(
              text: subtitle!,
              styleType: 'caption',
              color: AppColors.textLight,
            ),
          ],
        ],
      ),
    );
  }
}

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsiveHeight =
        widget.height ??
        ResponsiveHelper.getComponentDimension(context, 'buttonHeight');
    final responsiveBorderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'button',
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const  Duration(milliseconds: 300) ,
          width: widget.width,
          height: responsiveHeight,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  widget.gradientColors ??
                  [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
            boxShadow: [
              BoxShadow(
                color: (widget.gradientColors?.first ?? AppColors.primary)
                    .withOpacity(0.3),
                blurRadius: _isHovered
                    ? ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 12.0,
                        tablet: 14.0,
                        desktop: 16.0,
                      )
                    : ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 6.0,
                        tablet: 7.0,
                        desktop: 8.0,
                      ),
                offset: Offset(
                  0,
                  _isHovered
                      ? ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 4.0,
                          tablet: 5.0,
                          desktop: 6.0,
                        )
                      : ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 2.0,
                          tablet: 2.5,
                          desktop: 3.0,
                        ),
                ),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 20.0,
                      tablet: 22.0,
                      desktop: 24.0,
                    ),
                    height: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 20.0,
                      tablet: 22.0,
                      desktop: 24.0,
                    ),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 1.8,
                        tablet: 2.0,
                        desktop: 2.2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        ResponsiveIcon(
                          icon: widget.icon!,
                          color: Colors.white,
                          sizeType: 'buttonIcon',
                        ),
                        ResponsiveSpacing(spacingType: 'itemSpacing'),
                      ],
                      ResponsiveText(
                        text: widget.text,
                        styleType: 'button',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration:  300.ms ).scale(delay:  300.ms );
  }
}




