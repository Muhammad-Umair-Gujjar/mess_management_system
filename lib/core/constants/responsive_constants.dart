// Responsive configuration constants for the entire application
class ResponsiveConstants {
  // ==================== BREAKPOINTS ====================
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double smallMobileBreakpoint = 400;

  // ==================== GRID CONFIGURATIONS ====================
  // Different components need different grid layouts across devices
  static const Map<String, Map<String, int>> gridConfigurations = {
    // Quick Actions (3 columns mobile, 4 tablet, 2 desktop)
    'quickActions': {'mobile': 3, 'tablet': 4, 'desktop': 2},

    // Stats Cards (3 mobile, 3 tablet, 4 desktop)
    'statsCards': {'mobile': 2, 'tablet': 3, 'desktop': 4},

    // Menu Items (3 mobile, 2 tablet, 3 desktop)
    'menuItems': {'mobile': 3, 'tablet': 2, 'desktop': 3},

    // Student Cards (3 mobile, 3 tablet, 4 desktop)
    'studentCards': {'mobile': 3, 'tablet': 3, 'desktop': 4},

    // Staff Dashboard Cards (3 mobile, 2 tablet, 3 desktop)
    'staffDashboard': {'mobile': 3, 'tablet': 2, 'desktop': 3},

    // Attendance Grid (3 mobile, 3 tablet, 4 desktop)
    'attendanceGrid': {'mobile': 3, 'tablet': 3, 'desktop': 4},

    // Student Dashboard (3 mobile, 2 tablet, 3 desktop)
    'studentDashboard': {'mobile': 3, 'tablet': 2, 'desktop': 3},
  };

  // ==================== SPACING SYSTEM ====================
  static const Map<String, Map<String, double>> spacing = {
    // Container padding - Enhanced mobile comfort
    'padding': {'mobile': 20.0, 'tablet': 22.0, 'desktop': 32.0},

    // Card padding - Enhanced for mobile
    'cardPadding': {'mobile': 14.0, 'tablet': 20.0, 'desktop': 22.0},

    // Section margins - Enhanced mobile spacing
    'sectionMargin': {'mobile': 18.0, 'tablet': 20.0, 'desktop': 24.0},

    // Item spacing in grids - Enhanced mobile spacing
    'itemSpacing': {'mobile': 10.0, 'tablet': 12.0, 'desktop': 14.0},

    // Content margins - Enhanced mobile readability
    'contentMargin': {'mobile': 16.0, 'tablet': 18.0, 'desktop': 20.0},

    // General spacing - Enhanced mobile
    'xs': {'mobile': 4.0, 'tablet': 5.0, 'desktop': 4.0},
    'xsmall': {'mobile': 6.0, 'tablet': 8.0, 'desktop': 6.0},
    'small': {'mobile': 8.0, 'tablet': 10.0, 'desktop': 8.0},
    'medium': {'mobile': 12.0, 'tablet': 14.0, 'desktop': 16.0},
    'large': {'mobile': 20.0, 'tablet': 22.0, 'desktop': 24.0},
    'xlarge': {'mobile': 24.0, 'tablet': 26.0, 'desktop': 32.0},
  };

  // ==================== TYPOGRAPHY SCALING ====================
  // Font sizes optimized for readability across devices - ENHANCED MOBILE
  static const Map<String, Map<String, double>> typography = {
    // Headings - Enhanced mobile sizes for better visibility
    'heading1': {'mobile': 32.0, 'tablet': 32.0, 'desktop': 36.0},
    'heading2': {'mobile': 28.0, 'tablet': 28.0, 'desktop': 32.0},
    'heading3': {'mobile': 24.0, 'tablet': 24.0, 'desktop': 28.0},
    'heading4': {'mobile': 20.0, 'tablet': 20.0, 'desktop': 24.0},
    'heading5': {'mobile': 16.0, 'tablet': 18.0, 'desktop': 20.0},

    // Body text - Enhanced for mobile readability
    'body1': {'mobile': 16.0, 'tablet': 17.0, 'desktop': 18.0},
    'body2': {'mobile': 15.0, 'tablet': 16.0, 'desktop': 16.0},
    'body3': {'mobile': 12.0, 'tablet': 13.0, 'desktop': 14.0},
    'caption': {'mobile': 14.0, 'tablet': 15.0, 'desktop': 16.0},
    'label': {'mobile': 14.0, 'tablet': 15.0, 'desktop': 14.0},
    'button': {'mobile': 16.0, 'tablet': 17.0, 'desktop': 16.0},

    // Specific UI text types - Enhanced mobile
    'cardTitle': {'mobile': 16.0, 'tablet': 17.0, 'desktop': 18.0},
    'cardSubtitle': {'mobile': 14.0, 'tablet': 15.0, 'desktop': 16.0},
    'cardValue': {'mobile': 20.0, 'tablet': 22.0, 'desktop': 24.0},
    'menuItem': {'mobile': 15.0, 'tablet': 16.0, 'desktop': 16.0},
    'tabText': {'mobile': 16.0, 'tablet': 17.0, 'desktop': 16.0},
    'ratingText': {'mobile': 16.0, 'tablet': 17.0, 'desktop': 16.0},
  };

  // ==================== ICON SIZES ====================
  // Icon sizes optimized for touch targets and visual hierarchy - ENHANCED MOBILE
  static const Map<String, Map<String, double>> iconSizes = {
    'xsmall': {'mobile': 12.0, 'tablet': 14.0, 'desktop': 12.0},
    'tiny': {'mobile': 16.0, 'tablet': 18.0, 'desktop': 16.0},
    'small': {'mobile': 18.0, 'tablet': 20.0, 'desktop': 20.0},
    'medium': {'mobile': 22.0, 'tablet': 24.0, 'desktop': 28.0},
    'large': {'mobile': 28.0, 'tablet': 32.0, 'desktop': 35.0},
    'xlarge': {'mobile': 32.0, 'tablet': 40.0, 'desktop': 48.0},

    // Specific use cases - Enhanced mobile
    'actionIcon': {'mobile': 24.0, 'tablet': 26.0, 'desktop': 28.0},
    'cardIcon': {'mobile': 20.0, 'tablet': 22.0, 'desktop': 24.0},
    'buttonIcon': {'mobile': 20.0, 'tablet': 22.0, 'desktop': 20.0},
    'tabIcon': {'mobile': 24.0, 'tablet': 26.0, 'desktop': 24.0},
    'menuIcon': {'mobile': 26.0, 'tablet': 28.0, 'desktop': 28.0},
  };

  // ==================== COMPONENT DIMENSIONS ====================
  static const Map<String, Map<String, double>> componentDimensions = {
    // Button heights
    'buttonHeight': {'mobile': 40.0, 'tablet': 44.0, 'desktop': 48.0},
    'smallButtonHeight': {'mobile': 32.0, 'tablet': 36.0, 'desktop': 40.0},

    // Input field heights
    'inputHeight': {'mobile': 44.0, 'tablet': 48.0, 'desktop': 52.0},

    // Card minimum heights
    'cardMinHeight': {'mobile': 80.0, 'tablet': 100.0, 'desktop': 120.0},

    // Avatar sizes
    'avatarSmall': {'mobile': 24.0, 'tablet': 28.0, 'desktop': 32.0},
    'avatarMedium': {'mobile': 32.0, 'tablet': 36.0, 'desktop': 48.0},
    'avatarLarge': {'mobile': 48.0, 'tablet': 56.0, 'desktop': 64.0},
  };

  // ==================== ASPECT RATIOS ====================
  static const Map<String, Map<String, double>> aspectRatios = {
    'card': {'mobile': 1.0, 'tablet': 1.1, 'desktop': 1.2},
    'actionCard': {'mobile': 1.2, 'tablet': 1.1, 'desktop': 1.3},
    'menuCard': {'mobile': 0.8, 'tablet': 0.9, 'desktop': 1.1},
    'statsCard': {'mobile': 1.0, 'tablet': 1.3, 'desktop': 0.97},
    'quickAction': {'mobile': 1.3, 'tablet': 1.1, 'desktop': 1.3},
    'studentCard': {'mobile': 1.0, 'tablet': 1.1, 'desktop': 1.1},
  };

  // ==================== CONTAINER WIDTHS ====================
  static const Map<String, Map<String, double>> containerWidths = {
    'form': {
      'mobile': 1.0, // Full width
      'tablet': 0.8, // 80% of screen
      'desktop': 0.6, // 60% of screen
    },
    'dialog': {
      'mobile': 0.95, // 95% of screen
      'tablet': 0.7, // 70% of screen
      'desktop': 0.5, // 50% of screen
    },
    'card': {
      'mobile': 1.0, // Full width
      'tablet': 1.0, // Full width
      'desktop': 1.0, // Full width
    },
  };

  // ==================== BORDER RADIUS ====================
  static const Map<String, Map<String, double>> borderRadius = {
    'small': {'mobile': 6.0, 'tablet': 8.0, 'desktop': 8.0},
    'medium': {'mobile': 8.0, 'tablet': 12.0, 'desktop': 16.0},
    'large': {'mobile': 12.0, 'tablet': 16.0, 'desktop': 20.0},
    'card': {'mobile': 12.0, 'tablet': 16.0, 'desktop': 20.0},
    'button': {'mobile': 8.0, 'tablet': 10.0, 'desktop': 12.0},
  };

  // ==================== HELPER METHODS ====================

  /// Get grid configuration for a specific component type
  static Map<String, int>? getGridConfig(String componentType) {
    return gridConfigurations[componentType];
  }

  /// Get spacing configuration for a specific type
  static Map<String, double>? getSpacing(String spacingType) {
    return spacing[spacingType];
  }

  /// Get typography configuration for a specific text style
  static Map<String, double>? getTypography(String textStyle) {
    return typography[textStyle];
  }

  /// Get icon size configuration for a specific size category
  static Map<String, double>? getIconSizes(String sizeCategory) {
    return iconSizes[sizeCategory];
  }

  /// Get aspect ratio configuration for a specific component type
  static Map<String, double>? getAspectRatio(String componentType) {
    return aspectRatios[componentType];
  }

  /// Get container width configuration for a specific component type
  static Map<String, double>? getContainerWidth(String componentType) {
    return containerWidths[componentType];
  }

  /// Get component dimension configuration
  static Map<String, double>? getComponentDimension(String componentType) {
    return componentDimensions[componentType];
  }

  /// Get border radius configuration
  static Map<String, double>? getBorderRadius(String radiusType) {
    return borderRadius[radiusType];
  }
}




