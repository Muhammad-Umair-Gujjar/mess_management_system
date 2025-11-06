import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/toast_message.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/reusable_button.dart';
import '../../../widgets/common/reusable_text_field.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../staff_controller.dart';

class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  State<StaffAttendancePage> createState() => _StaffAttendancePageState();
}

class _StaffAttendancePageState extends State<StaffAttendancePage>
    with TickerProviderStateMixin {
  int selectedTabIndex = 0;
  late AnimationController _markAllController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedMeal = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _markAllController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _markAllController.dispose();
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
          // Meal Type Selector
          _buildMealSelector(),

          SizedBox(height: 24.h),

          // Main Content
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                _buildAttendanceMarkingView(controller, isMobile),
                _buildCalendarView(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSelector() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          Expanded(
            child: CustomTabBar(
              selectedIndex: selectedTabIndex,
              onTap: (index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              tabs: [
                CustomTabBarItem(
                  label: 'Mark Attendance',
                  icon: FontAwesomeIcons.userCheck,
                ),
                CustomTabBarItem(
                  label: 'Calendar View',
                  icon: FontAwesomeIcons.calendar,
                ),
              ],
              selectedColor: Colors.white,
              unselectedColor: AppColors.textSecondary,
              selectedBackgroundColor: AppColors.staffRole,
              unselectedBackgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              selectedTextStyle: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedTextStyle: AppTextStyles.body2,
            ),
          ),
          SizedBox(width: 20.w),
          _buildMealTypeChips(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildMealTypeChips() {
    return Row(
      children: ['Breakfast', 'Dinner'].map((meal) {
        final isSelected = _selectedMeal == meal;
        final color = meal == 'Breakfast' ? AppColors.warning : AppColors.info;

        return GestureDetector(
          onTap: () => setState(() => _selectedMeal = meal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(left: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: [color, color.withOpacity(0.8)])
                  : null,
              color: isSelected ? null : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  meal == 'Breakfast'
                      ? FontAwesomeIcons.sun
                      : FontAwesomeIcons.moon,
                  size: 14.sp,
                  color: isSelected ? Colors.white : color,
                ),
                SizedBox(width: 6.w),
                Text(
                  meal,
                  style: AppTextStyles.body2.copyWith(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceMarkingView(
    StaffController controller,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mark $_selectedMeal Attendance',
                    style: AppTextStyles.heading5,
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay),
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildQuickActions(controller),
            ],
          ),

          SizedBox(height: 24.h),

          // Search and Filter
          _buildSearchAndFilter(controller),

          SizedBox(height: 20.h),

          // Students List
          Expanded(child: _buildStudentsList(controller, isMobile)),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildQuickActions(StaffController controller) {
    return Row(
      children: [
        ReusableButton(
          text: 'Mark All Present',
          icon: FontAwesomeIcons.check,
          type: ButtonType.success,
          size: ButtonSize.medium,
          onPressed: () => _showMarkAllDialog(controller, true),
        ),
        SizedBox(width: 12.w),
        ReusableButton(
          text: 'Mark All Absent',
          icon: FontAwesomeIcons.xmark,
          type: ButtonType.danger,
          size: ButtonSize.medium,
          onPressed: () => _showMarkAllDialog(controller, false),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(StaffController controller) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ReusableTextField(
            hintText: 'Search students by name or ID...',
            type: TextFieldType.search,
            onChanged: controller.filterStudents,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            value: 'All',
            items: ['All', 'Present', 'Absent', 'Not Marked'].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) => controller.filterByStatus(value ?? 'All'),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsList(StaffController controller, bool isMobile) {
    return Obx(() {
      final filteredStudents = controller.filteredStudents;

      if (filteredStudents.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return _buildStudentCard(student, controller, index);
        },
      );
    });
  }

  Widget _buildStudentCard(
    dynamic student,
    StaffController controller,
    int index,
  ) {
    final isPresent = controller.isStudentPresent(
      student['id'],
      _selectedMeal,
      _selectedDay,
    );

    return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isPresent == null
                  ? AppColors.textLight.withOpacity(0.2)
                  : isPresent
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.error.withOpacity(0.5),
              width: 2.w,
            ),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              // Student Avatar
              CircleAvatar(
                radius: 24.r,
                backgroundColor: _getRoleColor().withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getRoleColor(),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${student['id']} • Room: ${student['room']}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Status
              _buildAttendanceToggle(student, controller, isPresent),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildAttendanceToggle(
    dynamic student,
    StaffController controller,
    bool? isPresent,
  ) {
    return Row(
      children: [
        // Status Indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isPresent == null
                ? AppColors.textLight.withOpacity(0.1)
                : isPresent
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            isPresent == null
                ? 'Not Marked'
                : isPresent
                ? 'Present'
                : 'Absent',
            style: AppTextStyles.caption.copyWith(
              color: isPresent == null
                  ? AppColors.textLight
                  : isPresent
                  ? AppColors.success
                  : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Toggle Buttons
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                _selectedMeal,
                _selectedDay,
                true,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isPresent == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 16.sp,
                  color: isPresent == true ? Colors.white : AppColors.success,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                _selectedMeal,
                _selectedDay,
                false,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isPresent == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  size: 16.sp,
                  color: isPresent == false ? Colors.white : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.users, size: 64.sp, color: AppColors.textLight),
          SizedBox(height: 24.h),
          Text(
            'No students found',
            style: AppTextStyles.heading5.copyWith(color: AppColors.textLight),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filter criteria',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(StaffController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Calendar Header
          Text('Attendance Overview', style: AppTextStyles.heading5),
          SizedBox(height: 24.h),

          // Calendar
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) => controller.getEventsForDay(day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.error,
                ),
                holidayTextStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.error,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 16.sp,
                ),
                rightChevronIcon: Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 16.sp,
                ),
                titleTextStyle: AppTextStyles.heading5,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkAllDialog(StaffController controller, bool isPresent) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Mark All ${isPresent ? 'Present' : 'Absent'}',
          style: AppTextStyles.heading5,
        ),
        content: Text(
          'Are you sure you want to mark all students as ${isPresent ? 'present' : 'absent'} for $_selectedMeal on ${DateFormat('MMM d, yyyy').format(_selectedDay)}?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Confirm',
            type: isPresent ? ButtonType.success : ButtonType.danger,
            size: ButtonSize.small,
            onPressed: () {
              controller.markAllAttendance(
                _selectedMeal,
                _selectedDay,
                isPresent,
              );
              Get.back();
              _showSuccessSnackbar(isPresent);
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(bool isPresent) {
    ToastMessage.success(
      'All students marked as ${isPresent ? 'present' : 'absent'}',
    );
  }

  Color _getRoleColor() => AppColors.staffRole;
}
