import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_decorations.dart';

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
      duration: const Duration(milliseconds: 150),
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
                duration: const Duration(milliseconds: 200),
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
                        widget.borderRadius ?? BorderRadius.circular(16.r),
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
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
      case ButtonSize.extraLarge:
        return EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h);
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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
          boxShadow: isEnabled && _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 16.r,
                    offset: Offset(0, 8.h),
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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.secondary)
              : AppShadows.light,
        );

      case ButtonType.outline:
        return BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
          border: Border.all(
            color: isEnabled ? AppColors.primary : AppColors.textLight,
            width: 2.w,
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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
          boxShadow: isEnabled && _isHovered
              ? AppShadows.coloredShadow(AppColors.warning)
              : AppShadows.light,
        );

      case ButtonType.ghost:
        return BoxDecoration(
          color: _isHovered ? AppColors.cardBackground : Colors.transparent,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
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
        strokeWidth: 2.w,
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
          SizedBox(width: 8.w),
        ],
        Text(widget.text, style: _getTextStyle(), textAlign: TextAlign.center),
      ],
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16.sp;
      case ButtonSize.medium:
        return 18.sp;
      case ButtonSize.large:
        return 20.sp;
      case ButtonSize.extraLarge:
        return 24.sp;
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
