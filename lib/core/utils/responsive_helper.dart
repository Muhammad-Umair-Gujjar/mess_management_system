import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile.sp;
    if (isTablet(context)) return tablet.sp;
    return desktop.sp;
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isMobile(context)) return mobile ?? EdgeInsets.all(16.r);
    if (isTablet(context)) return tablet ?? EdgeInsets.all(24.r);
    return desktop ?? EdgeInsets.all(32.r);
  }

  static int getGridCrossAxisCount(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For very small screens (< 400px), force to 2 columns max
    if (screenWidth < 400) return mobile.clamp(1, 2);
    // For small mobile screens (400-600px), use mobile setting
    if (screenWidth < 600) return mobile;
    // For large mobile/small tablet (600-768px), use mobile setting but allow more
    if (screenWidth < 768) return mobile.clamp(2, 3);
    // For tablet (768-1024px), use tablet setting
    if (screenWidth < 1024) return tablet;
    // For desktop (1024px+), use desktop setting
    return desktop;
  }

  static double getCardAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust aspect ratio based on screen size for better fit
    if (screenWidth < 400) return 0.9; // More square on very small screens
    if (screenWidth < 600) return 1.0; // Square on mobile
    if (screenWidth < 768) return 1.1; // Slightly taller on large mobile
    if (screenWidth < 1024) return 1.2; // More rectangular on tablet
    return 1.3; // Most rectangular on desktop
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400)
      return EdgeInsets.all(6.r); // Very small padding for tiny screens
    if (screenWidth < 600)
      return EdgeInsets.all(8.r); // Small padding for mobile
    if (screenWidth < 1024)
      return EdgeInsets.all(10.r); // Medium padding for tablet
    return EdgeInsets.all(12.r); // Larger padding for desktop
  }

  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth - 32.w;
    if (isTablet(context)) return (screenWidth - 48.w) / 2;
    return (screenWidth - 96.w) / 3;
  }

  static Widget buildResponsiveLayout({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    required Widget desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return desktop;
  }
}
