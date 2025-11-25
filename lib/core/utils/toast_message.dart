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
  /// Show success toast message
  static void success(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success.withOpacity(0.9),
      colorText: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          FontAwesomeIcons.check,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Success',
        style: AppTextStyles.body1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
        ),
      ),
    );
  }

  /// Show error toast message
  static void error(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error.withOpacity(0.9),
      colorText: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          FontAwesomeIcons.xmark,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Error',
        style: AppTextStyles.body1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
        ),
      ),
    );
  }

  /// Show warning toast message
  static void warning(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning.withOpacity(0.9),
      colorText: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          FontAwesomeIcons.triangleExclamation,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Warning',
        style: AppTextStyles.body1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
        ),
      ),
    );
  }

  /// Show info toast message
  static void info(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info.withOpacity(0.9),
      colorText: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          FontAwesomeIcons.circleInfo,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Info',
        style: AppTextStyles.body1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
        ),
      ),
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
    Get.snackbar(
      title ?? 'Notification',
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
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Notification',
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
  }

  /// Show loading toast message (stays until dismissed)
  static void loading(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Loading',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(8.0),
        child: const SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      duration: const Duration(seconds: 30), // Long duration for loading
      margin: EdgeInsets.only(
        top: 60.0,
        right: 20.0,
        left: Get.width > 600 ? Get.width * 0.6 : 20.0,
      ),
      borderRadius: 12.0,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      titleText: Text(
        title ?? 'Loading',
        style: AppTextStyles.body1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
        ),
      ),
    );
  }

  /// Dismiss all active snackbars
  static void dismissAll() {
    Get.closeAllSnackbars();
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
