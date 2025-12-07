import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';

class AuthErrorHandler {
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
        size: ResponsiveHelper.getIconSize(Get.context!, 'small'),
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(
        ResponsiveHelper.getSpacing(Get.context!, 'medium'),
      ),
    );
  }

  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: ResponsiveHelper.getIconSize(Get.context!, 'small'),
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(
        ResponsiveHelper.getSpacing(Get.context!, 'medium'),
      ),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
        size: ResponsiveHelper.getIconSize(Get.context!, 'small'),
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(
        ResponsiveHelper.getSpacing(Get.context!, 'medium'),
      ),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      icon: Icon(
        Icons.warning_outlined,
        color: Colors.white,
        size: ResponsiveHelper.getIconSize(Get.context!, 'small'),
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(
        ResponsiveHelper.getSpacing(Get.context!, 'medium'),
      ),
    );
  }
}

class AuthValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Backward compatibility method
  static bool isValidEmail(String value) {
    return GetUtils.isEmail(value.trim());
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  static String? validateRollNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your roll number';
    }
    if (value.trim().length < 3) {
      return 'Roll number must be at least 3 characters';
    }
    return null;
  }

  // Alias for backward compatibility
  static String? validateRollNumber(String? value) {
    return validateRollNo(value);
  }

  // Add phone number validation for backward compatibility (returns null since not required)
  static String? validatePhoneNumber(String? value) {
    return null; // Phone number is not required anymore
  }

  static String? validateRoomNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your room number';
    }
    return null;
  }
}
