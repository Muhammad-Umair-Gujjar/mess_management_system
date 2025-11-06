// Example usage of CustomTabBar and CustomGridView widgets

/*
=== CUSTOM TAB BAR USAGE EXAMPLES ===

1. Basic Tab Bar (like in your attendance dashboard):
```dart
CustomTabBar(
  tabs: [
    CustomTabBarItem(
      label: 'Attendance',
      icon: FontAwesomeIcons.userCheck,
    ),
    CustomTabBarItem(
      label: 'Billing',
      icon: FontAwesomeIcons.receipt,
    ),
    CustomTabBarItem(
      label: 'Menu Analytics',
      icon: FontAwesomeIcons.chartLine,
    ),
    CustomTabBarItem(
      label: 'Students',
      icon: FontAwesomeIcons.users,
    ),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  selectedColor: Colors.white,
  selectedBackgroundColor: AppColors.primary,
  showIcons: true,
)
```

2. Tab Bar without icons (like billing dashboard):
```dart
CustomTabBar(
  tabs: [
    CustomTabBarItem(label: 'Active Students'),
    CustomTabBarItem(label: 'Pending Approvals'),
    CustomTabBarItem(label: 'Statistics'),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  showIcons: false,
  selectedBackgroundColor: AppColors.success,
)
```

3. Underline Tab Bar (traditional style):
```dart
CustomUnderlineTabBar(
  tabs: [
    CustomTabBarItem(
      label: 'Breakfast',
      icon: FontAwesomeIcons.coffee,
    ),
    CustomTabBarItem(
      label: 'Dinner',
      icon: FontAwesomeIcons.utensils,
    ),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  selectedColor: AppColors.primary,
  indicatorColor: AppColors.primary,
)
```

4. Custom colors and styles:
```dart
CustomTabBar(
  tabs: tabs,
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  selectedColor: Colors.white,
  unselectedColor: AppColors.textSecondary,
  selectedBackgroundColor: AppColors.warning,
  unselectedBackgroundColor: Colors.grey.shade100,
  borderRadius: BorderRadius.circular(25.r),
  tabHeight: 50.h,
)
```

=== CUSTOM GRID VIEW USAGE EXAMPLES ===

1. Dashboard Cards (like admin dashboard):
```dart
CustomGridView(
  data: [
    GridCardData(
      title: 'Total Users',
      value: '347',
      icon: FontAwesomeIcons.users,
      color: AppColors.primary,
      trend: '+12%',
      trendIcon: FontAwesomeIcons.arrowUp,
      trendColor: AppColors.success,
    ),
    GridCardData(
      title: 'Pending',
      value: '23',
      icon: FontAwesomeIcons.clock,
      color: AppColors.warning,
      subtitle: 'This Month',
    ),
    GridCardData(
      title: 'Revenue',
      value: '₹246K',
      icon: FontAwesomeIcons.indianRupeeSign,
      color: AppColors.success,
      trend: '+18%',
      trendIcon: FontAwesomeIcons.arrowTrendUp,
    ),
    GridCardData(
      title: 'Uptime',
      value: '99%',
      icon: FontAwesomeIcons.server,
      color: AppColors.info,
      trend: '+2',
      trendColor: AppColors.success,
    ),
  ],
  crossAxisCount: 4,
  mobileCrossAxisCount: 2,
  tabletCrossAxisCount: 3,
  childAspectRatio: 1.2,
  mobileAspectRatio: 1.0,
  cardStyle: CustomGridCardStyle.elevated,
  shrinkWrap: true,
  showAnimation: true,
)
```

2. Staff Dashboard Cards:
```dart
CustomGridView(
  data: [
    GridCardData(
      title: 'Total Students',
      value: '234',
      icon: FontAwesomeIcons.graduationCap,
      color: AppColors.info,
      subtitle: 'Active Today',
    ),
    GridCardData(
      title: 'Present Today',
      value: '201',
      icon: FontAwesomeIcons.userCheck,
      color: AppColors.success,
    ),
    GridCardData(
      title: 'Absent Today',
      value: '33',
      icon: FontAwesomeIcons.userXmark,
      color: AppColors.error,
    ),
    GridCardData(
      title: 'Attendance Rate',
      value: '86%',
      icon: FontAwesomeIcons.percentage,
      color: AppColors.warning,
    ),
  ],
  crossAxisCount: 2,
  mobileCrossAxisCount: 2,
  childAspectRatio: 1.5,
  cardStyle: CustomGridCardStyle.gradient,
  padding: EdgeInsets.all(16.r),
)
```

3. Student Dashboard Cards:
```dart
CustomGridView(
  data: [
    GridCardData(
      title: 'Meals Attended',
      value: '0',
      icon: FontAwesomeIcons.utensils,
      color: AppColors.success,
      subtitle: 'This Month',
    ),
    GridCardData(
      title: 'Monthly Bill',
      value: '₹0',
      icon: FontAwesomeIcons.receipt,
      color: AppColors.warning,
      subtitle: 'Current',
    ),
    GridCardData(
      title: 'Attendance Rate',
      value: '0.0%',
      icon: FontAwesomeIcons.chartLine,
      color: AppColors.info,
      subtitle: 'Overall',
    ),
    GridCardData(
      title: 'Days Active',
      value: '6',
      icon: FontAwesomeIcons.calendar,
      color: AppColors.primary,
      subtitle: 'This Month',
    ),
  ],
  crossAxisCount: 2,
  mobileCrossAxisCount: 2,
  childAspectRatio: 1.3,
  cardStyle: CustomGridCardStyle.outlined,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
)
```

4. Different card styles:
```dart
// Minimal style
CustomGridView(
  data: data,
  cardStyle: CustomGridCardStyle.minimal,
)

// Glassmorphism style
CustomGridView(
  data: data,
  cardStyle: CustomGridCardStyle.glassmorphism,
)

// Custom gradient
CustomGridView(
  data: [
    GridCardData(
      title: 'Custom Card',
      value: '100',
      icon: FontAwesomeIcons.star,
      color: AppColors.primary,
      gradient: LinearGradient(
        colors: [Colors.purple.shade400, Colors.blue.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ],
  cardStyle: CustomGridCardStyle.gradient,
)
```

5. Horizontal scrollable grid:
```dart
CustomHorizontalGridView(
  data: data,
  itemWidth: 180,
  itemHeight: 120,
  cardStyle: CustomGridCardStyle.elevated,
)
```

6. With tap handlers:
```dart
CustomGridView(
  data: [
    GridCardData(
      title: 'Total Users',
      value: '347',
      icon: FontAwesomeIcons.users,
      color: AppColors.primary,
      onTap: () {
        // Navigate to users page
        Get.toNamed('/users');
      },
    ),
  ],
)
```

7. Custom content:
```dart
CustomGridView(
  data: [
    GridCardData(
      title: '', // Not used when customContent is provided
      value: '', // Not used when customContent is provided
      icon: FontAwesomeIcons.chart, // Not used when customContent is provided
      color: AppColors.primary,
      customContent: Column(
        children: [
          // Your custom widget content here
          CircularProgressIndicator(),
          SizedBox(height: 8.h),
          Text('Loading...'),
        ],
      ),
    ),
  ],
)
```

=== RESPONSIVE BEHAVIOR ===

The widgets automatically adapt to different screen sizes:
- Mobile: Uses mobileCrossAxisCount and mobileAspectRatio
- Tablet: Uses tabletCrossAxisCount and tabletAspectRatio  
- Desktop: Uses default crossAxisCount and childAspectRatio

=== CUSTOMIZATION OPTIONS ===

CustomTabBar:
- selectedColor, unselectedColor
- selectedBackgroundColor, unselectedBackgroundColor
- showIcons, isScrollable
- borderRadius, tabHeight
- Custom text styles

CustomGridView:
- Multiple card styles (elevated, outlined, gradient, minimal, glassmorphism)
- Responsive grid counts and aspect ratios
- Animation support
- Custom colors, gradients, and content
- Tap handlers for navigation

*/
