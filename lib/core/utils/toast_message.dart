import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mess_management/core/theme/app_theme.dart';
import '../constants/app_colors.dart';

/// Toast Message Utility Class
///
/// Provides consistent, customized toast messages throughout the app.
/// All toasts appear in the top-right corner with appropriate styling.
class ToastMessage {
  static BuildContext? _safeContext() {
    return Get.overlayContext ?? Get.context ?? Get.key.currentContext;
  }

  static IconData _defaultIcon(String type) {
    switch (type) {
      case 'success':
        return FontAwesomeIcons.check;
      case 'error':
        return FontAwesomeIcons.xmark;
      case 'warning':
        return FontAwesomeIcons.triangleExclamation;
      case 'loading':
        return FontAwesomeIcons.spinner;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  static String _defaultTitle(String type) {
    switch (type) {
      case 'success':
        return 'Success';
      case 'error':
        return 'Error';
      case 'warning':
        return 'Warning';
      case 'loading':
        return 'Loading';
      default:
        return 'Info';
    }
  }

  static bool _showGetSnackbar({
    required String type,
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Duration duration,
  }) {
    final overlayContext = Get.overlayContext;
    if (overlayContext == null || Overlay.maybeOf(overlayContext) == null) {
      return false;
    }

    try {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: backgroundColor.withOpacity(0.9),
        colorText: textColor,
        icon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: textColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Icon(icon, color: textColor, size: 16.0),
        ),
        duration: duration,
        margin: const EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
        borderRadius: 12.0,
        animationDuration: const Duration(milliseconds: 300),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        titleText: Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        messageText: Text(
          message,
          style: AppTextStyles.body2.copyWith(
            color: textColor.withOpacity(0.9),
            fontSize: 14.0,
          ),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool _showScaffoldSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Duration duration,
  }) {
    final context = _safeContext();
    if (context == null) {
      return false;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return false;
    }

    try {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor.withOpacity(0.95),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(icon, color: textColor, size: 16.0),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      message,
                      style: AppTextStyles.body2.copyWith(
                        color: textColor.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static void _showToast({
    required String type,
    required String message,
    String? title,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    int attempt = 0,
  }) {
    final resolvedTitle = title ?? _defaultTitle(type);
    final resolvedIcon = icon ?? _defaultIcon(type);

    final shown =
        _showGetSnackbar(
          type: type,
          title: resolvedTitle,
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: resolvedIcon,
          duration: duration,
        ) ||
        _showScaffoldSnackBar(
          title: resolvedTitle,
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: resolvedIcon,
          duration: duration,
        );

    if (!shown && attempt < 5) {
      Future.delayed(
        Duration(milliseconds: 140 * (attempt + 1)),
        () => _showToast(
          type: type,
          message: message,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: icon,
          duration: duration,
          attempt: attempt + 1,
        ),
      );
    }
  }

  /// Show success toast message
  static void success(String message, {String? title}) {
    _showToast(
      type: 'success',
      message: message,
      title: title,
      backgroundColor: AppColors.success,
      textColor: Colors.white,
      icon: FontAwesomeIcons.check,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show error toast message
  static void error(String message, {String? title}) {
    _showToast(
      type: 'error',
      message: message,
      title: title,
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      icon: FontAwesomeIcons.xmark,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show warning toast message
  static void warning(String message, {String? title}) {
    _showToast(
      type: 'warning',
      message: message,
      title: title,
      backgroundColor: AppColors.warning,
      textColor: Colors.white,
      icon: FontAwesomeIcons.triangleExclamation,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show info toast message
  static void info(String message, {String? title}) {
    _showToast(
      type: 'info',
      message: message,
      title: title,
      backgroundColor: AppColors.info,
      textColor: Colors.white,
      icon: FontAwesomeIcons.circleInfo,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show custom toast message with custom styling
  static void custom({
    required String message,
    String? title,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      type: 'custom',
      message: message,
      title: title ?? 'Notification',
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
    );
  }

  /// Show loading toast message (stays until dismissed)
  static void loading(String message, {String? title}) {
    _showToast(
      type: 'loading',
      message: message,
      title: title,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      icon: FontAwesomeIcons.spinner,
      duration: const Duration(seconds: 30),
    );
  }

  /// Dismiss all active snackbars
  static void dismissAll() {
    try {
      Get.closeAllSnackbars();
    } catch (_) {
      final context = _safeContext();
      final messenger = context != null
          ? ScaffoldMessenger.maybeOf(context)
          : null;
      messenger?.hideCurrentSnackBar();
    }
  }

  /// Show simple message without title (useful for quick notifications)
  static void show(String message, {ToastType type = ToastType.info}) {
    switch (type) {
      case ToastType.success:
        success(message);
        break;
      case ToastType.error:
        error(message);
        break;
      case ToastType.warning:
        warning(message);
        break;
      case ToastType.info:
        info(message);
        break;
    }
  }
}

/// Enum for toast types
enum ToastType { success, error, warning, info }
