import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../constants/responsive_constants.dart';

class AppDecorations {
  // Neumorphic Container Decoration
  static BoxDecoration neumorphicContainer({
    Color? color,
    double? borderRadius,
    bool isPressed = false,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: AppColors.shadowMedium,
                offset: const Offset(1.0, 1.0),
                blurRadius: 2.0,
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: const Offset(8.0, 8.0),
                blurRadius: 16.0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-8.0, -8.0),
                blurRadius: 16.0,
              ),
            ],
    );
  }

  // Glassmorphic Container Decoration
  static BoxDecoration glassmorphicContainer({
    Color? color,
    double? borderRadius,
    double opacity = 0.25,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 8.0),
          blurRadius: 32.0,
        ),
      ],
    );
  }

  // Gradient Container Decoration
  static BoxDecoration gradientContainer({
    required Gradient gradient,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow:
          boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4.0),
              blurRadius: 16.0,
            ),
          ],
    );
  }

  // Floating Card Decoration
  static BoxDecoration floatingCard({
    Color? color,
    double? borderRadius,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          offset: const Offset(0, 12.0),
          blurRadius: 24.0,
        ),
        BoxShadow(
          color: AppColors.shadowMedium,
          offset: const Offset(0, 4.0),
          blurRadius: 8.0,
        ),
      ],
    );
  }

  // Elevated Card with Gradient Border
  static BoxDecoration elevatedCardWithGradientBorder({
    Color? backgroundColor,
    Gradient? borderGradient,
    double? borderRadius,
    double borderWidth = 2.0,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      color: backgroundColor ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          offset: const Offset(0, 8.0),
          blurRadius: 24.0,
        ),
      ],
    );
  }

  // Background Gradient Decoration
  static BoxDecoration backgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF8FAFF), Color(0xFFE0E7FF), Color(0xFFF0F4FF)],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  // Animated Shimmer Decoration
  static BoxDecoration shimmerContainer({BuildContext? context}) {
    final radius = context != null
        ? ResponsiveHelper.getBorderRadius(context, 'large')
        : 24.0;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade100,
          Colors.grey.shade200,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  // Hover Effect Decoration
  static BoxDecoration hoverContainer({
    Color? color,
    double? borderRadius,
    bool isHovered = false,
    BuildContext? context,
  }) {
    final radius =
        borderRadius ??
        (context != null
            ? ResponsiveHelper.getBorderRadius(context, 'large')
            : 24.0);

    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                offset: const Offset(0, 12.0),
                blurRadius: 32.0,
              ),
              BoxShadow(
                color: AppColors.shadowMedium,
                offset: const Offset(0, 4.0),
                blurRadius: 12.0,
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: const Offset(0, 4.0),
                blurRadius: 12.0,
              ),
            ],
    );
  }
}

class AppBorders {
  static Border gradientBorder({
    required Gradient gradient,
    double width = 2.0,
  }) {
    return Border.all(color: Colors.transparent, width: width);
  }

  static BorderRadius get defaultRadius => BorderRadius.circular(24.0);
  static BorderRadius get smallRadius => BorderRadius.circular(12.0);
  static BorderRadius get largeRadius => BorderRadius.circular(32.0);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(48.0);
}

class AppShadows {
  static List<BoxShadow> get light => [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 2.0),
      blurRadius: 8.0,
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4.0),
      blurRadius: 16.0,
    ),
  ];

  static List<BoxShadow> get heavy => [
    BoxShadow(
      color: AppColors.shadowDark,
      offset: const Offset(0, 8.0),
      blurRadius: 32.0,
    ),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 12.0),
      blurRadius: 24.0,
    ),
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4.0),
      blurRadius: 8.0,
    ),
  ];

  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      offset: const Offset(0, 8.0),
      blurRadius: 24.0,
    ),
  ];

  static BoxDecoration glassmorphicCard({BuildContext? context}) {
    final radius = context != null
        ? ResponsiveHelper.getBorderRadius(context, 'large')
        : 24.0;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 8.0),
          blurRadius: 24.0,
        ),
      ],
    );
  }
}




