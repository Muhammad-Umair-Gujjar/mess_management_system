import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/toast_message.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../widgets/common/reusable_button.dart';
import '../../staff_controller.dart';
import 'components/meal_selector_card.dart';
import 'components/attendance_marking_view.dart';
import 'components/calendar_view.dart';

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
      duration: const Duration(milliseconds: 300),
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
          MealSelectorCard(
            selectedTabIndex: selectedTabIndex,
            selectedMeal: _selectedMeal,
            onTabChanged: (index) => setState(() => selectedTabIndex = index),
            onMealChanged: (meal) => setState(() => _selectedMeal = meal),
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

          // Main Content
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                AttendanceMarkingView(
                  controller: controller,
                  isMobile: isMobile,
                  selectedMeal: _selectedMeal,
                  selectedDay: _selectedDay,
                  onMarkAllPresent: () => _showMarkAllDialog(controller, true),
                  onMarkAllAbsent: () => _showMarkAllDialog(controller, false),
                ),
                CalendarView(
                  controller: controller,
                  selectedDay: _selectedDay,
                  focusedDay: _focusedDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                  },
                ),
              ],
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
}
