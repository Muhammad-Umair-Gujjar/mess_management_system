import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppDecorations {
  // Neumorphic Container Decoration
  static BoxDecoration neumorphicContainer({
    Color? color,
    double? borderRadius,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: AppColors.shadowMedium,
                offset: Offset(1.w, 1.h),
                blurRadius: 2.r,
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: Offset(8.w, 8.h),
                blurRadius: 16.r,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: Offset(-8.w, -8.h),
                blurRadius: 16.r,
              ),
            ],
    );
  }

  // Glassmorphic Container Decoration
  static BoxDecoration glassmorphicContainer({
    Color? color,
    double? borderRadius,
    double opacity = 0.25,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 8.h),
          blurRadius: 32.r,
        ),
      ],
    );
  }

  // Gradient Container Decoration
  static BoxDecoration gradientContainer({
    required Gradient gradient,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      boxShadow:
          boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4.h),
              blurRadius: 16.r,
            ),
          ],
    );
  }

  // Floating Card Decoration
  static BoxDecoration floatingCard({Color? color, double? borderRadius}) {
    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          offset: Offset(0, 12.h),
          blurRadius: 24.r,
        ),
        BoxShadow(
          color: AppColors.shadowMedium,
          offset: Offset(0, 4.h),
          blurRadius: 8.r,
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
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          offset: Offset(0, 8.h),
          blurRadius: 24.r,
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
  static BoxDecoration shimmerContainer() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24.r),
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
  }) {
    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                offset: Offset(0, 12.h),
                blurRadius: 32.r,
              ),
              BoxShadow(
                color: AppColors.shadowMedium,
                offset: Offset(0, 4.h),
                blurRadius: 12.r,
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: Offset(0, 4.h),
                blurRadius: 12.r,
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

  static BorderRadius get defaultRadius => BorderRadius.circular(24.r);
  static BorderRadius get smallRadius => BorderRadius.circular(12.r);
  static BorderRadius get largeRadius => BorderRadius.circular(32.r);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(48.r);
}

class AppShadows {
  static List<BoxShadow> get light => [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 2.h),
      blurRadius: 8.r,
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: Offset(0, 4.h),
      blurRadius: 16.r,
    ),
  ];

  static List<BoxShadow> get heavy => [
    BoxShadow(
      color: AppColors.shadowDark,
      offset: Offset(0, 8.h),
      blurRadius: 32.r,
    ),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 12.h),
      blurRadius: 24.r,
    ),
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: Offset(0, 4.h),
      blurRadius: 8.r,
    ),
  ];

  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      offset: Offset(0, 8.h),
      blurRadius: 24.r,
    ),
  ];

  static BoxDecoration glassmorphicCard() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 8.h),
          blurRadius: 24.r,
        ),
      ],
    );
  }
}
