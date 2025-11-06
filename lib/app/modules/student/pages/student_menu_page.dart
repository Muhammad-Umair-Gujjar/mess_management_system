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
import '../../../data/models/menu.dart';
import '../../../data/models/attendance.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../student_controller.dart';

class StudentMenuPage extends StatefulWidget {
  const StudentMenuPage({super.key});

  @override
  State<StudentMenuPage> createState() => _StudentMenuPageState();
}

class _StudentMenuPageState extends State<StudentMenuPage> {
  int selectedDay = DateTime.now().weekday - 1; // Monday is 0
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: _buildMobileLayout(controller),
        desktop: _buildDesktopLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(controller),
          _buildWeekNavigator(),
          _buildMenuContent(controller),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(controller),
                    SizedBox(height: 24.h),
                    _buildWeekNavigator(),
                    SizedBox(height: 24.h),
                    _buildNutritionalInfo(controller),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(context),
                child: _buildMenuContent(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(StudentController controller) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Weekly Menu',
                  style: AppTextStyles.heading4.copyWith(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Plan your meals for the week',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.calendarWeek,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'This Week',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      height: 90.h,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context).horizontal,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final dayDate = startOfWeek.add(Duration(days: index));
          final isSelected = selectedDay == index;
          final isToday =
              dayDate.day == now.day &&
              dayDate.month == now.month &&
              dayDate.year == now.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = index;
              });
            },
            child:
                Container(
                      width: 70.w,
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 4.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected
                            ? null
                            : isToday
                            ? AppColors.accent.withOpacity(0.1)
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isToday && !isSelected
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 8.h),
                                  blurRadius: 16.r,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            weekDays[index],
                            style: AppTextStyles.body2.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            dayDate.day.toString(),
                            style: AppTextStyles.heading5.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: index * 100))
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: 0.3),
          );
        },
      ),
    );
  }

  Widget _buildMenuContent(StudentController controller) {
    return Container(
      margin: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(context).horizontal,
      ),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Tab Bar
          Container(
            margin: EdgeInsets.all(20.r),
            child: CustomTabBar(
              selectedIndex: selectedTabIndex,
              onTap: (index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              tabs: [
                CustomTabBarItem(
                  label: 'Breakfast',
                  icon: FontAwesomeIcons.sun,
                ),
                CustomTabBarItem(label: 'Dinner', icon: FontAwesomeIcons.moon),
              ],
              selectedColor: Colors.white,
              unselectedColor: AppColors.textSecondary,
              selectedBackgroundColor: AppColors.primary,
              unselectedBackgroundColor: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              tabHeight: 48.h,
              selectedTextStyle: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedTextStyle: AppTextStyles.subtitle1,
            ),
          ),

          // Tab Content - Fixed height to avoid unbounded constraints
          SizedBox(
            height: 400.h, // Fixed height instead of Expanded
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                _buildMealTab(controller, MealType.breakfast),
                _buildMealTab(controller, MealType.dinner),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildMealTab(StudentController controller, MealType mealType) {
    return Obx(() {
      final selectedDate = _getSelectedDate();
      final menuItem = controller.menuItems
          .where(
            (item) =>
                item.mealType == mealType &&
                item.date.day == selectedDate.day &&
                item.date.month == selectedDate.month &&
                item.date.year == selectedDate.year,
          )
          .firstOrNull;

      if (menuItem == null) {
        return _buildEmptyMealState(mealType);
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMealHeader(menuItem),
            SizedBox(height: 24.h),
            _buildMealDetails(menuItem),
            SizedBox(height: 24.h),
            _buildNutritionalCard(menuItem),
            if (ResponsiveHelper.isMobile(context)) ...[
              SizedBox(height: 24.h),
              _buildAttendanceStatus(controller, menuItem),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildEmptyMealState(MealType mealType) {
    final mealName = mealType == MealType.breakfast ? 'Breakfast' : 'Dinner';

    return Center(
      child: Container(
        padding: EdgeInsets.all(40.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mealType == MealType.breakfast
                  ? FontAwesomeIcons.sun
                  : FontAwesomeIcons.moon,
              size: 64.sp,
              color: AppColors.textLight,
            ),
            SizedBox(height: 20.h),
            Text(
              'No $mealName Planned',
              style: AppTextStyles.heading5.copyWith(
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Menu for this day is not available yet.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealHeader(MenuItem menuItem) {
    return Row(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            gradient: menuItem.mealType == MealType.breakfast
                ? LinearGradient(
                    colors: [
                      AppColors.warning,
                      AppColors.warning.withOpacity(0.7),
                    ],
                  )
                : LinearGradient(
                    colors: [AppColors.info, AppColors.info.withOpacity(0.7)],
                  ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            menuItem.mealType == MealType.breakfast
                ? FontAwesomeIcons.sun
                : FontAwesomeIcons.moon,
            size: 32.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menuItem.name,
                style: AppTextStyles.heading5.copyWith(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                DateFormat('EEEE, MMM dd').format(menuItem.date),
                style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealDetails(MenuItem menuItem) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.bowlFood,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 12.w),
              Text(
                'Description',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            menuItem.description,
            style: AppTextStyles.body1.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalCard(MenuItem menuItem) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.seedling,
                size: 20.sp,
                color: AppColors.success,
              ),
              SizedBox(width: 12.w),
              Text(
                'Nutritional Information',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildNutritionalItem(
                'Calories',
                '${menuItem.calories.toInt()}',
                'kcal',
              ),
              SizedBox(width: 24.w),
              _buildNutritionalItem(
                'Protein',
                '${(menuItem.calories * 0.15 / 4).toInt()}',
                'g',
              ),
              SizedBox(width: 24.w),
              _buildNutritionalItem(
                'Carbs',
                '${(menuItem.calories * 0.55 / 4).toInt()}',
                'g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.success),
        ),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            text: value,
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStatus(
    StudentController controller,
    MenuItem menuItem,
  ) {
    return Obx(() {
      final attendance = controller.attendanceList
          .where(
            (a) =>
                a.date.day == menuItem.date.day &&
                a.date.month == menuItem.date.month &&
                a.date.year == menuItem.date.year &&
                a.mealType == menuItem.mealType,
          )
          .firstOrNull;

      final isPresent = attendance?.isPresent ?? false;
      final isFuture = menuItem.date.isAfter(DateTime.now());

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isPresent
              ? AppColors.success.withOpacity(0.1)
              : isFuture
              ? AppColors.info.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPresent
                ? AppColors.success.withOpacity(0.3)
                : isFuture
                ? AppColors.info.withOpacity(0.3)
                : AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isPresent
                    ? AppColors.success
                    : isFuture
                    ? AppColors.info
                    : AppColors.error,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isPresent
                    ? FontAwesomeIcons.check
                    : isFuture
                    ? FontAwesomeIcons.clock
                    : FontAwesomeIcons.xmark,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPresent
                        ? 'Attended'
                        : isFuture
                        ? 'Upcoming'
                        : 'Missed',
                    style: AppTextStyles.subtitle1.copyWith(
                      color: isPresent
                          ? AppColors.success
                          : isFuture
                          ? AppColors.info
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isPresent
                        ? 'You attended this meal'
                        : isFuture
                        ? 'Meal scheduled'
                        : 'You missed this meal',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNutritionalInfo(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Nutrition', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),

          // Calories Progress
          _buildNutritionProgress(
            'Calories',
            2400,
            3500, // Weekly target: 500 per day * 7 days
            AppColors.warning,
            FontAwesomeIcons.fire,
          ),

          SizedBox(height: 16.h),

          // Protein Progress
          _buildNutritionProgress(
            'Protein',
            180,
            350, // Weekly target
            AppColors.success,
            FontAwesomeIcons.dumbbell,
          ),
        ],
      ),
    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildNutritionProgress(
    String label,
    double current,
    double target,
    Color color,
    IconData icon,
  ) {
    final percentage = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '${current.toInt()}/${target.toInt()}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTime _getSelectedDate() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return startOfWeek.add(Duration(days: selectedDay));
  }
}
