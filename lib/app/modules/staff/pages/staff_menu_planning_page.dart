import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/toast_message.dart';
import '../../../widgets/common/reusable_button.dart';
import '../../../widgets/common/reusable_text_field.dart';
import '../../../widgets/custom_grid_view.dart';
import '../staff_controller.dart';

class StaffMenuPlanningPage extends StatefulWidget {
  const StaffMenuPlanningPage({super.key});

  @override
  State<StaffMenuPlanningPage> createState() => _StaffMenuPlanningPageState();
}

class _StaffMenuPlanningPageState extends State<StaffMenuPlanningPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedWeek = DateTime.now();

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> _mealTypes = ['Breakfast', 'Dinner'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Column(
        children: [
          // Week Selector and Tabs
          _buildHeader(),

          SizedBox(height: 24.h),

          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWeeklyPlannerTab(controller, isMobile),
                _buildMenuItemsTab(controller, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Week Selector
          Row(
            children: [
              Text('Menu Planning', style: AppTextStyles.heading5),
              const Spacer(),
              ReusableButton(
                text: 'Previous Week',
                icon: FontAwesomeIcons.chevronLeft,
                type: ButtonType.outline,
                size: ButtonSize.small,
                onPressed: () => _changeWeek(-1),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _getWeekRangeText(),
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              ReusableButton(
                text: 'Next Week',
                icon: FontAwesomeIcons.chevronRight,
                type: ButtonType.outline,
                size: ButtonSize.small,
                onPressed: () => _changeWeek(1),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Tab Selector
          TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.circular(12.r),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyles.body2,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.calendar, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text('Weekly Planner'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.utensils, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text('Menu Items'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildWeeklyPlannerTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Header Actions
          Row(
            children: [
              Text('Weekly Menu Schedule', style: AppTextStyles.heading5),
              const Spacer(),
              ReusableButton(
                text: 'Save Menu',
                icon: FontAwesomeIcons.floppyDisk,
                type: ButtonType.primary,
                size: ButtonSize.medium,
                onPressed: _saveWeeklyMenu,
              ),
              SizedBox(width: 12.w),
              ReusableButton(
                text: 'Generate Menu',
                icon: FontAwesomeIcons.wandMagicSparkles,
                type: ButtonType.secondary,
                size: ButtonSize.medium,
                onPressed: _generateRandomMenu,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Weekly Schedule Grid
          Expanded(
            child: isMobile ? _buildMobileMenuGrid() : _buildDesktopMenuGrid(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildDesktopMenuGrid() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Row
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                SizedBox(width: 120.w), // Space for meal type column
                ..._weekDays
                    .map(
                      (day) => Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            day,
                            style: AppTextStyles.body2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),

          // Menu Grid Rows
          ..._mealTypes
              .map(
                (mealType) => Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Type Label
                      Container(
                        width: 120.w,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: mealType == 'Breakfast'
                              ? AppColors.warning.withOpacity(0.1)
                              : AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              mealType == 'Breakfast'
                                  ? FontAwesomeIcons.sun
                                  : FontAwesomeIcons.moon,
                              size: 24.sp,
                              color: mealType == 'Breakfast'
                                  ? AppColors.warning
                                  : AppColors.info,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              mealType,
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: mealType == 'Breakfast'
                                    ? AppColors.warning
                                    : AppColors.info,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Menu Items for Each Day
                      ..._weekDays.asMap().entries.map((entry) {
                        final dayIndex = entry.key;
                        final day = entry.value;

                        return Expanded(
                          child: _buildMenuItemCard(day, mealType, dayIndex),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMobileMenuGrid() {
    return ListView.builder(
      itemCount: _weekDays.length,
      itemBuilder: (context, dayIndex) {
        final day = _weekDays[dayIndex];
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.r),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: AppTextStyles.heading5.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: _mealTypes
                    .map(
                      (mealType) => Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _buildMenuItemCard(
                            day,
                            mealType,
                            dayIndex,
                            compact: true,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItemCard(
    String day,
    String mealType,
    int dayIndex, {
    bool compact = false,
  }) {
    final menuItems = _getMenuForDayAndMeal(day, mealType);

    return Container(
          height: compact ? 120.h : 180.h,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact) ...[
                Row(
                  children: [
                    Icon(
                      mealType == 'Breakfast'
                          ? FontAwesomeIcons.sun
                          : FontAwesomeIcons.moon,
                      size: 12.sp,
                      color: mealType == 'Breakfast'
                          ? AppColors.warning
                          : AppColors.info,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      mealType,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: menuItems
                        .map(
                          (item) => Container(
                            margin: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              item,
                              style: AppTextStyles.body2.copyWith(
                                fontSize: compact ? 11.sp : 13.sp,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () => _editDayMenu(day, mealType),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.pencil,
                        size: 10.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Edit',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: dayIndex * 100))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildMenuItemsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text('Menu Item Library', style: AppTextStyles.heading5),
              const Spacer(),
              SizedBox(
                width: 250.w,
                child: ReusableTextField(
                  hintText: 'Search menu items...',
                  type: TextFieldType.search,
                  onChanged: (query) {
                    // Implement search functionality
                  },
                ),
              ),
              SizedBox(width: 16.w),
              ReusableButton(
                text: 'Add Item',
                icon: FontAwesomeIcons.plus,
                type: ButtonType.primary,
                size: ButtonSize.medium,
                onPressed: _addMenuItem,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Menu Categories
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories Sidebar
                Container(width: 200.w, child: _buildCategoriesList()),

                SizedBox(width: 24.w),

                // Menu Items Grid
                Expanded(child: _buildMenuItemsGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    final categories = [
      {'name': 'Main Course', 'icon': FontAwesomeIcons.utensils, 'count': 15},
      {'name': 'Rice & Bread', 'icon': FontAwesomeIcons.bowlRice, 'count': 8},
      {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot, 'count': 12},
      {'name': 'Beverages', 'icon': FontAwesomeIcons.mugHot, 'count': 6},
      {'name': 'Desserts', 'icon': FontAwesomeIcons.cakeCandles, 'count': 4},
    ];

    return Column(
      children: categories
          .map(
            (category) => Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  category['name'] as String,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.textLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${category['count']}',
                    style: AppTextStyles.caption,
                  ),
                ),
                onTap: () {
                  // Filter by category
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMenuItemsGrid() {
    final menuItems = [
      {
        'name': 'Chicken Biryani',
        'category': 'Main Course',
        'calories': 450,
        'price': 120,
      },
      {
        'name': 'Dal Tadka',
        'category': 'Main Course',
        'calories': 180,
        'price': 60,
      },
      {
        'name': 'Basmati Rice',
        'category': 'Rice & Bread',
        'calories': 200,
        'price': 40,
      },
      {'name': 'Roti', 'category': 'Rice & Bread', 'calories': 80, 'price': 15},
      {
        'name': 'Mixed Vegetables',
        'category': 'Vegetables',
        'calories': 120,
        'price': 50,
      },
      {'name': 'Chai', 'category': 'Beverages', 'calories': 50, 'price': 20},
    ];

    // Convert menu items to GridCardData format
    final gridData = menuItems
        .map(
          (item) => GridCardData(
            title: item['name'] as String,
            value: '${item['calories']} cal',
            icon: FontAwesomeIcons.utensils,
            color: AppColors.primary,
            subtitle: item['category'] as String,
            customContent: _buildMenuItemContent(item),
          ),
        )
        .toList();

    return CustomGridView(
      data: gridData,
      crossAxisCount: 4, // Desktop: 4 columns
      tabletCrossAxisCount: 3, // Tablet: 3 columns
      mobileCrossAxisCount: 2, // Mobile: 2 columns
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 0.85,
      mobileAspectRatio: 0.85,
      tabletAspectRatio: 0.85,
      cardStyle: CustomGridCardStyle.elevated,
      showAnimation: true,
    );
  }

  Widget _buildMenuItemContent(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item['name'] as String,
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PopupMenuButton(
              icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 16.sp),
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text('Edit')),
                const PopupMenuItem(child: Text('Delete')),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            item['category'] as String,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(FontAwesomeIcons.fire, size: 12.sp, color: AppColors.warning),
            SizedBox(width: 4.w),
            Text('${item['calories']} cal', style: AppTextStyles.caption),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.indianRupee,
              size: 12.sp,
              color: AppColors.success,
            ),
            SizedBox(width: 4.w),
            Text(
              '₹${item['price']}',
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getWeekRangeText() {
    final startOfWeek = _selectedWeek.subtract(
      Duration(days: _selectedWeek.weekday - 1),
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(endOfWeek)}';
  }

  void _changeWeek(int direction) {
    setState(() {
      _selectedWeek = _selectedWeek.add(Duration(days: 7 * direction));
    });
  }

  List<String> _getMenuForDayAndMeal(String day, String mealType) {
    // Mock data - in real app this would come from controller
    if (mealType == 'Breakfast') {
      return ['Aloo Paratha', 'Curd', 'Pickle', 'Tea/Coffee'];
    } else {
      return ['Rice', 'Dal', 'Chicken Curry', 'Roti', 'Salad'];
    }
  }

  void _editDayMenu(String day, String mealType) {
    Get.dialog(
      AlertDialog(
        title: Text('Edit $mealType Menu - $day'),
        content: Container(
          width: 400.w,
          height: 300.h,
          child: ReusableTextField(
            label: 'Menu Items (one per line)',
            maxLines: 10,
            hintText: 'Enter menu items...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Save',
            type: ButtonType.primary,
            size: ButtonSize.small,
            onPressed: () {
              Get.back();
              ToastMessage.success('Menu updated successfully');
            },
          ),
        ],
      ),
    );
  }

  void _addMenuItem() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Menu Item'),
        content: Container(
          width: 400.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableTextField(
                label: 'Item Name',
                hintText: 'Enter item name',
              ),
              SizedBox(height: 16.h),
              ReusableTextField(label: 'Category', hintText: 'Select category'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ReusableTextField(
                      label: 'Calories',
                      type: TextFieldType.number,
                      hintText: 'Cal',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ReusableTextField(
                      label: 'Price (₹)',
                      type: TextFieldType.number,
                      hintText: 'Price',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Add Item',
            type: ButtonType.primary,
            size: ButtonSize.small,
            onPressed: () {
              Get.back();
              ToastMessage.success('Menu item added successfully');
            },
          ),
        ],
      ),
    );
  }

  void _saveWeeklyMenu() {
    ToastMessage.success('Weekly menu saved successfully');
  }

  void _generateRandomMenu() {
    ToastMessage.success('Random menu generated for the week');
  }
}
