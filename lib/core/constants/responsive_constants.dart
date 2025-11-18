// Responsive configuration constants for the entire application
class ResponsiveConstants {
  // ==================== BREAKPOINTS ====================
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double smallMobileBreakpoint = 400;

  // ==================== GRID CONFIGURATIONS ====================
  // Different components need different grid layouts across devices
  static const Map<String, Map<String, int>> gridConfigurations = {
    // Quick Actions (2 columns mobile, 4 tablet, 2 desktop)
    'quickActions': {'mobile': 2, 'tablet': 4, 'desktop': 2},

    // Stats Cards (2 mobile, 3 tablet, 4 desktop)
    'statsCards': {'mobile': 2, 'tablet': 3, 'desktop': 4},

    // Menu Items (1 mobile, 2 tablet, 3 desktop)
    'menuItems': {'mobile': 1, 'tablet': 2, 'desktop': 3},

    // Student Cards (2 mobile, 3 tablet, 4 desktop)
    'studentCards': {'mobile': 2, 'tablet': 3, 'desktop': 4},

    // Staff Dashboard Cards (2 mobile, 2 tablet, 3 desktop)
    'staffDashboard': {'mobile': 2, 'tablet': 2, 'desktop': 3},

    // Attendance Grid (2 mobile, 3 tablet, 4 desktop)
    'attendanceGrid': {'mobile': 2, 'tablet': 3, 'desktop': 4},
  };

  // ==================== SPACING SYSTEM ====================
  static const Map<String, Map<String, double>> spacing = {
    // Container padding
    'padding': {'mobile': 16.0, 'tablet': 24.0, 'desktop': 32.0},

    // Card padding
    'cardPadding': {'mobile': 12.0, 'tablet': 16.0, 'desktop': 20.0},

    // Section margins
    'sectionMargin': {'mobile': 16.0, 'tablet': 20.0, 'desktop': 24.0},

    // Item spacing in grids
    'itemSpacing': {'mobile': 8.0, 'tablet': 12.0, 'desktop': 16.0},

    // Content margins
    'contentMargin': {'mobile': 12.0, 'tablet': 16.0, 'desktop': 20.0},
  };

  // ==================== TYPOGRAPHY SCALING ====================
  static const Map<String, Map<String, double>> typography = {
    'heading1': {'mobile': 28.0, 'tablet': 32.0, 'desktop': 36.0},
    'heading2': {'mobile': 24.0, 'tablet': 28.0, 'desktop': 32.0},
    'heading3': {'mobile': 20.0, 'tablet': 24.0, 'desktop': 28.0},
    'heading4': {'mobile': 18.0, 'tablet': 20.0, 'desktop': 24.0},
    'heading5': {'mobile': 16.0, 'tablet': 18.0, 'desktop': 20.0},
    'body1': {'mobile': 16.0, 'tablet': 16.0, 'desktop': 18.0},
    'body2': {'mobile': 14.0, 'tablet': 14.0, 'desktop': 16.0},
    'caption': {'mobile': 12.0, 'tablet': 14.0, 'desktop': 16.0},
    'button': {'mobile': 14.0, 'tablet': 16.0, 'desktop': 16.0},
  };

  // ==================== ICON SIZES ====================
  static const Map<String, Map<String, double>> iconSizes = {
    'small': {'mobile': 16.0, 'tablet': 18.0, 'desktop': 20.0},
    'medium': {'mobile': 20.0, 'tablet': 24.0, 'desktop': 28.0},
    'large': {'mobile': 24.0, 'tablet': 32.0, 'desktop': 40.0},
    'xlarge': {'mobile': 32.0, 'tablet': 40.0, 'desktop': 48.0},
  };

  // ==================== ASPECT RATIOS ====================
  static const Map<String, Map<String, double>> aspectRatios = {
    'card': {'mobile': 1.0, 'tablet': 1.1, 'desktop': 1.2},
    'actionCard': {'mobile': 1.3, 'tablet': 1.1, 'desktop': 1.3},
    'menuCard': {'mobile': 0.9, 'tablet': 1.0, 'desktop': 1.1},
    'statsCard': {'mobile': 1.2, 'tablet': 1.3, 'desktop': 1.4},
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
}
