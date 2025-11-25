import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/responsive_helper.dart';

enum TextFieldType { normal, email, password, search, number, phone }

class ReusableTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextFieldType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;

  const ReusableTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.type = TextFieldType.normal,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.borderRadius,
    this.inputFormatters,
  });

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const  Duration(milliseconds: 300) ,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _obscureText = widget.type == TextFieldType.password;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),
        ],
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ??
                        ResponsiveHelper.getBorderRadius(context, 'medium'),
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: ResponsiveHelper.getBorderRadius(
                              context,
                              'medium',
                            ),
                            offset: Offset(
                              0,
                              ResponsiveHelper.getSpacing(context, 'xs'),
                            ),
                          ),
                        ]
                      : AppShadows.light,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  obscureText: _obscureText,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  textInputAction: widget.textInputAction,
                  keyboardType: _getKeyboardType(),
                  inputFormatters:
                      widget.inputFormatters ?? _getInputFormatters(),
                  style: AppTextStyles.body1.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
                    color: AppColors.textPrimary,
                  ),
                  onTap: () {
                    widget.onTap?.call();
                    setState(() => _isFocused = true);
                    _animationController.forward();
                  },
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                  },
                  onFieldSubmitted: (value) {
                    widget.onSubmitted?.call(value);
                    setState(() => _isFocused = false);
                    _animationController.reverse();
                  },
                  onEditingComplete: () {
                    setState(() => _isFocused = false);
                    _animationController.reverse();
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    helperText: widget.helperText,
                    errorText: widget.errorText,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    contentPadding:
                        widget.contentPadding ??
                        EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getSpacing(
                            context,
                            'large',
                          ),
                          vertical: ResponsiveHelper.getSpacing(
                            context,
                            'medium',
                          ),
                        ),
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                      fontSize: ResponsiveHelper.getFontSize(context, 'body1'),
                    ),
                    helperStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                    errorStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Container(
                            margin: EdgeInsets.only(
                              left: ResponsiveHelper.getSpacing(
                                context,
                                'medium',
                              ),
                              right: ResponsiveHelper.getSpacing(
                                context,
                                'small',
                              ),
                            ),
                            child: Icon(
                              widget.prefixIcon,
                              size: ResponsiveHelper.getIconSize(
                                context,
                                'small',
                              ),
                              color: _isFocused
                                  ? AppColors.primary
                                  : AppColors.textLight,
                            ),
                          )
                        : null,
                    suffixIcon: _buildSuffixIcon(),
                    border: _buildBorder(),
                    enabledBorder: _buildBorder(),
                    focusedBorder: _buildFocusedBorder(),
                    errorBorder: _buildErrorBorder(),
                    focusedErrorBorder: _buildErrorBorder(),
                    disabledBorder: _buildDisabledBorder(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          size: ResponsiveHelper.getIconSize(context, 'tiny'),
          color: AppColors.textLight,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: ResponsiveHelper.getIconSize(context, 'small'),
          color: AppColors.textLight,
        ),
        onPressed: widget.onSuffixPressed,
      );
    }

    if (widget.type == TextFieldType.search) {
      return Icon(
        FontAwesomeIcons.magnifyingGlass,
        size: ResponsiveHelper.getIconSize(context, 'tiny'),
        color: AppColors.textLight,
      );
    }

    return null;
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        widget.borderRadius ??
            ResponsiveHelper.getBorderRadius(context, 'medium'),
      ),
      borderSide: BorderSide(
        color: AppColors.textLight.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        widget.borderRadius ??
            ResponsiveHelper.getBorderRadius(context, 'medium'),
      ),
      borderSide: BorderSide(color: AppColors.primary, width: 2.0),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        widget.borderRadius ??
            ResponsiveHelper.getBorderRadius(context, 'medium'),
      ),
      borderSide: BorderSide(color: AppColors.error, width: 2.0),
    );
  }

  OutlineInputBorder _buildDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        widget.borderRadius ??
            ResponsiveHelper.getBorderRadius(context, 'medium'),
      ),
      borderSide: BorderSide(
        color: AppColors.textLight.withOpacity(0.1),
        width: 1.0,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
      default:
        return null;
    }
  }
}




