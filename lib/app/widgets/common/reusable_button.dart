import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/responsive_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/responsive_helper.dart';

enum ButtonType { primary, secondary, outline, danger, success, warning, ghost }

enum ButtonSize { small, medium, large, extraLarge }

class ReusableButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool disabled;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ReusableButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.width,
    this.padding,
    this.borderRadius,
  });

  @override
  State<ReusableButton> createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const  Duration(milliseconds: 300) ,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const  Duration(milliseconds: 300) ,
                width: widget.width,
                padding: widget.padding ?? _getButtonPadding(),
                decoration: _getButtonDecoration(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.disabled || widget.isLoading
                        ? null
                        : widget.onPressed,
                    borderRadius:
                        widget.borderRadius ??
                        BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(context, 'button'),
                        ),
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.isLoading
                          ? _buildLoadingIndicator()
                          : _buildButtonContent(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getButtonPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return ResponsiveHelper.getResponsivePadding(
          context,
          mobile: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
            vertical: ResponsiveHelper.getSpacing(context, 'xsmall'),
          ),
          tablet: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
            vertical: ResponsiveHelper.getSpacing(context, 'small'),
          ),
          desktop: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
            vertical: ResponsiveHelper.getSpacing(context, 'small'),
          ),
        );
      case ButtonSize.medium:
        return ResponsiveHelper.getResponsivePadding(
          context,
          mobile: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
            vertical: ResponsiveHelper.getSpacing(context, 'small'),
          ),
          tablet: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          desktop: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
        );
      case ButtonSize.large:
        return ResponsiveHelper.getResponsivePadding(
          context,
          mobile: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'large'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          tablet: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          desktop: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
        );
      case ButtonSize.extraLarge:
        return ResponsiveHelper.getResponsivePadding(
          context,
          mobile: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
            vertical: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          tablet: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
            vertical: ResponsiveHelper.getSpacing(context, 'large'),
          ),
          desktop: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'xlarge'),
            vertical: ResponsiveHelper.getSpacing(context, 'large'),
          ),
        );
    }
  }

  BoxDecoration _getButtonDecoration() {
    final isEnabled = !widget.disabled && !widget.isLoading;

    switch (widget.type) {
      case ButtonType.primary:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                    ? _getHoverGradient(AppColors.primaryGradient)
                    : AppColors.primaryGradient)
              : LinearGradient(
                  colors: [AppColors.textLight, AppColors.textLight],
                ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          boxShadow: isEnabled && _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 12.0,
                      tablet: 14.0,
                      desktop: 16.0,
                    ),
                    offset: Offset(
                      0,
                      ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 6.0,
                        tablet: 7.0,
                        desktop: 8.0,
                      ),
                    ),
                  ),
                ]
              : AppShadows.light,
        );

      case ButtonType.secondary:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                    ? _getHoverGradient(AppColors.accentGradient)
                    : AppColors.accentGradient)
              : LinearGradient(
                  colors: [AppColors.textLight, AppColors.textLight],
                ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.secondary)
              : AppShadows.light,
        );

      case ButtonType.outline:
        return BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          border: Border.all(
            color: isEnabled ? AppColors.primary : AppColors.textLight,
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 2.0,
              tablet: 2.0,
              desktop: 2.0,
            ),
          ),
          boxShadow: _isHovered ? AppShadows.light : null,
        );

      case ButtonType.danger:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                    ? LinearGradient(
                        colors: [
                          AppColors.error.withOpacity(0.8),
                          AppColors.error,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.error,
                          AppColors.error.withOpacity(0.8),
                        ],
                      ))
              : LinearGradient(
                  colors: [AppColors.textLight, AppColors.textLight],
                ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.error)
              : AppShadows.light,
        );

      case ButtonType.success:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                    ? LinearGradient(
                        colors: [
                          AppColors.success.withOpacity(0.8),
                          AppColors.success,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.success,
                          AppColors.success.withOpacity(0.8),
                        ],
                      ))
              : LinearGradient(
                  colors: [AppColors.textLight, AppColors.textLight],
                ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.success)
              : AppShadows.light,
        );

      case ButtonType.warning:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                    ? LinearGradient(
                        colors: [
                          AppColors.warning.withOpacity(0.8),
                          AppColors.warning,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.warning,
                          AppColors.warning.withOpacity(0.8),
                        ],
                      ))
              : LinearGradient(
                  colors: [AppColors.textLight, AppColors.textLight],
                ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.warning)
              : AppShadows.light,
        );

      case ButtonType.ghost:
        return BoxDecoration(
          color: _isHovered ? AppColors.cardBackground : Colors.transparent,
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'button'),
              ),
        );
    }
  }

  LinearGradient _getHoverGradient(LinearGradient original) {
    return LinearGradient(
      colors: original.colors.map((color) => color.withOpacity(0.8)).toList(),
      begin: original.begin,
      end: original.end,
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: _getIconSize(),
      height: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 2.0,
          tablet: 2.0,
          desktop: 2.0,
        ),
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: _getIconSize(), color: _getTextColor()),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'itemSpacing')),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: _getTextStyle(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return ResponsiveHelper.getIconSize(context, 'small');
      case ButtonSize.medium:
        return ResponsiveHelper.getIconSize(context, 'small');
      case ButtonSize.large:
        return ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 18.0,
          tablet: 19.0,
          desktop: 20.0,
        );
      case ButtonSize.extraLarge:
        return ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 22.0,
          tablet: 23.0,
          desktop: 24.0,
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (widget.size) {
      ButtonSize.small => AppTextStyles.caption,
      ButtonSize.medium => AppTextStyles.body2,
      ButtonSize.large => AppTextStyles.subtitle1,
      ButtonSize.extraLarge => AppTextStyles.heading5,
    };

    return baseStyle.copyWith(
      color: _getTextColor(),
      fontWeight: FontWeight.w600,
    );
  }

  Color _getTextColor() {
    if (widget.disabled || widget.isLoading) {
      return AppColors.textLight;
    }

    switch (widget.type) {
      case ButtonType.outline:
      case ButtonType.ghost:
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }
}




