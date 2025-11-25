import 'package:flutter/material.dart';
import '../constants/responsive_constants.dart';

class ResponsiveHelper {
  // Device type detection
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >=
          ResponsiveConstants.mobileBreakpoint &&
      MediaQuery.of(context).size.width < ResponsiveConstants.tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveConstants.tabletBreakpoint;

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width <
      ResponsiveConstants.smallMobileBreakpoint;

  // ==================== TYPOGRAPHY METHODS ====================

  /// Get responsive font size from ResponsiveConstants
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get font size from ResponsiveConstants typography
  static double getFontSize(BuildContext context, String textStyle) {
    final config = ResponsiveConstants.getTypography(textStyle);
    if (config == null) return 16.0;

    return getResponsiveFontSize(
      context,
      mobile: config['mobile']!,
      tablet: config['tablet']!,
      desktop: config['desktop']!,
    );
  }

  // ==================== ICON METHODS ====================

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get icon size from ResponsiveConstants
  static double getIconSize(BuildContext context, String sizeCategory) {
    final config = ResponsiveConstants.getIconSizes(sizeCategory);
    if (config == null) return 24.0;

    return getResponsiveIconSize(
      context,
      mobile: config['mobile']!,
      tablet: config['tablet']!,
      desktop: config['desktop']!,
    );
  }

  // ==================== SPACING METHODS ====================

  /// Get responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get spacing from ResponsiveConstants
  static double getSpacing(BuildContext context, String spacingType) {
    final config = ResponsiveConstants.getSpacing(spacingType);
    if (config == null) return 16.0;

    return getResponsiveSpacing(
      context,
      mobile: config['mobile']!,
      tablet: config['tablet']!,
      desktop: config['desktop']!,
    );
  }

  // ==================== PADDING METHODS ====================

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isMobile(context)) return mobile ?? const EdgeInsets.all(14.0);
    if (isTablet(context)) return tablet ?? const EdgeInsets.all(20.0);
    return desktop ?? const EdgeInsets.all(32.0);
  }

  /// Get padding from ResponsiveConstants
  static EdgeInsets getPadding(BuildContext context, String paddingType) {
    final config = ResponsiveConstants.getSpacing(paddingType);
    if (config == null) return const EdgeInsets.all(16.0);

    return getResponsivePadding(
      context,
      mobile: EdgeInsets.all(config['mobile']!),
      tablet: EdgeInsets.all(config['tablet']!),
      desktop: EdgeInsets.all(config['desktop']!),
    );
  }

  /// Get card padding specifically
  static EdgeInsets getCardPadding(BuildContext context) {
    return getPadding(context, 'cardPadding');
  }

  // ==================== MARGIN METHODS ====================

  /// Get responsive margin
  static EdgeInsets getResponsiveMargin(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isMobile(context)) return mobile ?? const EdgeInsets.all(10.0);
    if (isTablet(context)) return tablet ?? const EdgeInsets.all(14.0);
    return desktop ?? const EdgeInsets.all(20.0);
  }

  /// Get margin from ResponsiveConstants
  static EdgeInsets getMargin(BuildContext context, String marginType) {
    final config = ResponsiveConstants.getSpacing(marginType);
    if (config == null) return const EdgeInsets.all(12.0);

    return getResponsiveMargin(
      context,
      mobile: EdgeInsets.all(config['mobile']!),
      tablet: EdgeInsets.all(config['tablet']!),
      desktop: EdgeInsets.all(config['desktop']!),
    );
  }

  // ==================== DIMENSION METHODS ====================

  /// Get component dimension from ResponsiveConstants
  static double getComponentDimension(
    BuildContext context,
    String dimensionType,
  ) {
    final config = ResponsiveConstants.getComponentDimension(dimensionType);
    if (config == null) return 40.0;

    if (isMobile(context)) return config['mobile']!;
    if (isTablet(context)) return config['tablet']!;
    return config['desktop']!;
  }

  /// Get border radius from ResponsiveConstants
  static double getBorderRadius(BuildContext context, String radiusType) {
    final config = ResponsiveConstants.getBorderRadius(radiusType);
    if (config == null) return 12.0;

    if (isMobile(context)) return config['mobile']!;
    if (isTablet(context)) return config['tablet']!;
    return config['desktop']!;
  }

  // ==================== GRID METHODS ====================

  /// Get grid configuration from ResponsiveConstants
  static int getGridCrossAxisCount(
    BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
    String? configType,
  }) {
    // If configType is provided, get from ResponsiveConstants
    if (configType != null) {
      final config = ResponsiveConstants.getGridConfig(configType);
      if (config != null) {
        if (isMobile(context)) return config['mobile']!;
        if (isTablet(context)) return config['tablet']!;
        return config['desktop']!;
      }
    }

    // Fallback to provided values or defaults
    final mobileCount = mobile ?? 1;
    final tabletCount = tablet ?? 2;
    final desktopCount = desktop ?? 3;

    final screenWidth = MediaQuery.of(context).size.width;

    // For very small screens (< 400px), force to 2 columns max
    if (screenWidth < 400) return mobileCount.clamp(1, 2);
    // For small mobile screens (400-600px), use mobile setting
    if (screenWidth < 600) return mobileCount;
    // For large mobile/small tablet (600-768px), use mobile setting but allow more
    if (screenWidth < ResponsiveConstants.mobileBreakpoint)
      return mobileCount.clamp(2, 3);
    // For tablet (768-1024px), use tablet setting
    if (screenWidth < ResponsiveConstants.tabletBreakpoint) return tabletCount;
    // For desktop (1024px+), use desktop setting
    return desktopCount;
  }

  /// Get aspect ratio from ResponsiveConstants
  static double getAspectRatio(BuildContext context, String aspectType) {
    final config = ResponsiveConstants.getAspectRatio(aspectType);
    if (config == null) {
      // Default aspect ratio logic
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 400) return 0.9;
      if (screenWidth < 600) return 1.0;
      if (screenWidth < ResponsiveConstants.mobileBreakpoint) return 1.1;
      if (screenWidth < ResponsiveConstants.tabletBreakpoint) return 1.2;
      return 1.3;
    }

    if (isMobile(context)) return config['mobile']!;
    if (isTablet(context)) return config['tablet']!;
    return config['desktop']!;
  }

  /// Get card aspect ratio - convenience method for cards
  static double getCardAspectRatio(BuildContext context) {
    return getAspectRatio(context, 'card');
  }

  // ==================== LAYOUT METHODS ====================

  /// Build responsive layout
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

  /// Get responsive value
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // ==================== CONTAINER METHODS ====================

  /// Get responsive container width
  static double getContainerWidth(
    BuildContext context, {
    double mobileRatio = 1.0,
    double tabletRatio = 0.8,
    double desktopRatio = 0.6,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth * mobileRatio;
    if (isTablet(context)) return screenWidth * tabletRatio;
    return screenWidth * desktopRatio;
  }

  /// Get container width from ResponsiveConstants
  static double getContainerWidthFromConfig(
    BuildContext context,
    String containerType,
  ) {
    final config = ResponsiveConstants.getContainerWidth(containerType);
    if (config == null) return MediaQuery.of(context).size.width;

    return getContainerWidth(
      context,
      mobileRatio: config['mobile']!,
      tabletRatio: config['tablet']!,
      desktopRatio: config['desktop']!,
    );
  }

  // ==================== TEXT STYLE METHODS ====================

  /// Create responsive text style
  static TextStyle getResponsiveTextStyle(
    BuildContext context, {
    required String styleType,
    Color? color,
    FontWeight? fontWeight,
    TextStyle? baseStyle,
  }) {
    final fontSize = getFontSize(context, styleType);

    return (baseStyle ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  /// Get button text style
  static TextStyle getButtonTextStyle(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return getResponsiveTextStyle(
      context,
      styleType: 'button',
      color: color,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  /// Get card title text style
  static TextStyle getCardTitleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return getResponsiveTextStyle(
      context,
      styleType: 'cardTitle',
      color: color,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  /// Get card subtitle text style
  static TextStyle getCardSubtitleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return getResponsiveTextStyle(
      context,
      styleType: 'cardSubtitle',
      color: color,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  // ==================== UTILITY METHODS ====================

  /// Get screen size category
  static String getScreenSizeCategory(BuildContext context) {
    if (isMobile(context)) return 'mobile';
    if (isTablet(context)) return 'tablet';
    return 'desktop';
  }

  /// Check if screen is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if screen is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}




