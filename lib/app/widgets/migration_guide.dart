// MIGRATION GUIDE: How to replace existing GridViews with CustomGridView

/*
=== EXAMPLE 1: Replace Staff Reports Attendance Cards ===

OLD CODE (around line 251 in staff_reports_page.dart):
```dart
final summaryData = [
  {
    'title': 'Total Students',
    'value': '234',
    'icon': FontAwesomeIcons.graduationCap,
    'color': AppColors.info,
  },
  // ... more data
];

return GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: isMobile ? 2 : 4,
    crossAxisSpacing: 16.w,
    mainAxisSpacing: 16.h,
    childAspectRatio: isMobile ? 1.5 : 1.7,
  ),
  itemCount: summaryData.length,
  itemBuilder: (context, index) {
    final data = summaryData[index];
    return _buildSummaryCard(
      data['title'] as String,
      data['value'] as String,
      data['icon'] as IconData,
      data['color'] as Color,
      index,
    );
  },
);
```

NEW CODE:
```dart
final gridData = [
  GridCardData(
    title: 'Total Students',
    value: '234',
    icon: FontAwesomeIcons.graduationCap,
    color: AppColors.info,
    trend: '+12%',
    trendIcon: FontAwesomeIcons.arrowUp,
    trendColor: AppColors.success,
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
    icon: FontAwesomeIcons.chartLine,
    color: AppColors.warning,
    trend: '+5%',
    trendColor: AppColors.success,
  ),
];

return CustomGridView(
  data: gridData,
  crossAxisCount: 4,
  mobileCrossAxisCount: 2,
  childAspectRatio: 1.7,
  mobileAspectRatio: 1.5,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  cardStyle: CustomGridCardStyle.elevated,
  showAnimation: true,
);
```

=== EXAMPLE 2: Admin Dashboard Cards ===

Replace the admin dashboard grid with:
```dart
final adminGridData = [
  GridCardData(
    title: 'Total Users',
    value: '347',
    icon: FontAwesomeIcons.users,
    color: AppColors.error,
    trend: '+12%',
    trendIcon: FontAwesomeIcons.arrowTrendUp,
    trendColor: AppColors.success,
  ),
  GridCardData(
    title: 'Active Students',
    value: '234',
    icon: FontAwesomeIcons.graduationCap,
    color: AppColors.primary,
    trend: '+5%',
    trendIcon: FontAwesomeIcons.arrowUp,
    trendColor: AppColors.success,
  ),
  GridCardData(
    title: 'Staff Members',
    value: '12',
    icon: FontAwesomeIcons.userTie,
    color: AppColors.success,
    trend: '+2',
    trendColor: AppColors.success,
  ),
  GridCardData(
    title: 'Monthly Revenue',
    value: '₹246K',
    icon: FontAwesomeIcons.indianRupeeSign,
    color: AppColors.warning,
    trend: '+18%',
    trendIcon: FontAwesomeIcons.arrowTrendUp,
    trendColor: AppColors.success,
  ),
  GridCardData(
    title: 'Pending Approvals',
    value: '23',
    icon: FontAwesomeIcons.clock,
    color: AppColors.error,
    trend: '-3',
    trendColor: AppColors.error,
  ),
  GridCardData(
    title: 'System Uptime',
    value: '99%',
    icon: FontAwesomeIcons.server,
    color: AppColors.success,
    trend: '99.9%',
    trendColor: AppColors.success,
  ),
];

CustomGridView(
  data: adminGridData,
  crossAxisCount: 3,
  mobileCrossAxisCount: 2,
  tabletCrossAxisCount: 2,
  childAspectRatio: 1.2,
  mobileAspectRatio: 1.0,
  cardStyle: CustomGridCardStyle.gradient,
  shrinkWrap: true,
  padding: EdgeInsets.all(16.r),
)
```

=== EXAMPLE 3: Student Dashboard Cards ===

Replace student dashboard with:
```dart
final studentGridData = [
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
];

CustomGridView(
  data: studentGridData,
  crossAxisCount: 2,
  mobileCrossAxisCount: 2,
  childAspectRatio: 1.4,
  mobileAspectRatio: 1.2,
  cardStyle: CustomGridCardStyle.outlined,
  shrinkWrap: true,
)
```

=== STEP-BY-STEP MIGRATION PROCESS ===

1. Add imports to your file:
```dart
import '../../../widgets/custom_tab_bar.dart';
import '../../../widgets/custom_grid_view.dart';
```

2. Replace TabController with simple index state:
OLD:
```dart
class _PageState extends State<Page> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
```

NEW:
```dart
class _PageState extends State<Page> {
  int _selectedTabIndex = 0;
```

3. Replace TabBar with CustomTabBar:
OLD:
```dart
TabBar(
  controller: _tabController,
  tabs: [
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
  ],
)
```

NEW:
```dart
CustomTabBar(
  tabs: [
    CustomTabBarItem(label: 'Tab 1', icon: FontAwesomeIcons.icon1),
    CustomTabBarItem(label: 'Tab 2', icon: FontAwesomeIcons.icon2),
  ],
  selectedIndex: _selectedTabIndex,
  onTap: (index) => setState(() => _selectedTabIndex = index),
  selectedColor: Colors.white,
  selectedBackgroundColor: AppColors.primary,
)
```

4. Replace TabBarView with IndexedStack:
OLD:
```dart
TabBarView(
  controller: _tabController,
  children: [widget1, widget2],
)
```

NEW:
```dart
IndexedStack(
  index: _selectedTabIndex,
  children: [widget1, widget2],
)
```

5. Convert your data to GridCardData format and replace GridView.builder with CustomGridView

=== BENEFITS OF MIGRATION ===

✅ Consistent UI across all dashboards
✅ Better responsive behavior  
✅ Built-in animations
✅ Multiple card styles (elevated, outlined, gradient, minimal, glassmorphism)
✅ Easy customization
✅ Trend indicators and subtitles support
✅ Tap handlers for navigation
✅ Better overflow handling
✅ No more TabController complexity

=== ADVANCED CUSTOMIZATION ===

1. Custom card styles:
```dart
CustomGridView(
  cardStyle: CustomGridCardStyle.glassmorphism,
  // or create completely custom content
  data: [
    GridCardData(
      title: '',
      value: '',
      icon: FontAwesomeIcons.placeholder,
      color: AppColors.primary,
      customContent: YourCustomWidget(),
    ),
  ],
)
```

2. Navigation handling:
```dart
GridCardData(
  title: 'Users',
  value: '347',
  icon: FontAwesomeIcons.users,
  color: AppColors.primary,
  onTap: () => Get.toNamed('/users'),
)
```

3. Different responsive behavior:
```dart
CustomGridView(
  crossAxisCount: 4,        // Desktop: 4 columns
  tabletCrossAxisCount: 3,  // Tablet: 3 columns  
  mobileCrossAxisCount: 2,  // Mobile: 2 columns
  childAspectRatio: 1.5,    // Desktop ratio
  tabletAspectRatio: 1.3,   // Tablet ratio
  mobileAspectRatio: 1.1,   // Mobile ratio
)
```
*/
