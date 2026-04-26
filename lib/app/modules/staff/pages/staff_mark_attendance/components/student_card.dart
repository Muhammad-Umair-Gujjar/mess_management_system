import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../staff_controller.dart';

class StudentCard extends StatelessWidget {
  final dynamic student;
  final StaffController controller;
  final int index;
  final String selectedMeal;
  final DateTime selectedDay;

  const StudentCard({
    super.key,
    required this.student,
    required this.controller,
    required this.index,
    required this.selectedMeal,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reading messOffVersion makes this widget rebuild whenever mess-off changes
      controller.messOffVersion.value;
      final isMessOff = controller.isStudentMessedOff(
        student['id'],
        selectedDay,
        meal: selectedMeal,
      );
      final isPresent = controller.isStudentPresent(
        student['id'],
        selectedMeal,
        selectedDay,
      );
      return _buildCard(context, isMessOff, isPresent);
    });
  }

  Widget _buildCard(BuildContext context, bool isMessOff, bool? isPresent) {
    return Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'small'),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            border: Border.all(
              color: isMessOff
                  ? AppColors.warning.withOpacity(0.5)
                  : isPresent == null
                  ? AppColors.textLight.withOpacity(0.2)
                  : isPresent
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.error.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              // Student Avatar
              CircleAvatar(
                radius: ResponsiveHelper.getSpacing(context, 'large'),
                backgroundColor: AppColors.staffRole.withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.staffRole,
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

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
              isMessOff
                  ? _buildMessOffBadge(context)
                  : _buildAttendanceToggle(context, isPresent),

              SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),

              // Mess-off toggle button
              GestureDetector(
                onTap: () => _showMessOffDialog(context),
                child: Tooltip(
                  message: isMessOff ? 'Remove Mess Off' : 'Set Mess Off',
                  child: Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getSpacing(context, 'xsmall'),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(
                        isMessOff ? 0.2 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getSpacing(context, 'xsmall'),
                      ),
                    ),
                    child: Icon(
                      Icons.no_meals,
                      size: ResponsiveHelper.getIconSize(context, 'small'),
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildAttendanceToggle(BuildContext context, bool? isPresent) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status Indicator — hidden on mobile to save horizontal space
        if (!isMobile) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, 'small'),
              vertical: ResponsiveHelper.getSpacing(context, 'xs'),
            ),
            decoration: BoxDecoration(
              color: isPresent == null
                  ? AppColors.textLight.withOpacity(0.1)
                  : isPresent
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
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
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        ],
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                selectedMeal,
                selectedDay,
                true,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'xsmall'),
                ),
                decoration: BoxDecoration(
                  color: isPresent == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'xsmall'),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                  color: isPresent == true ? Colors.white : AppColors.success,
                ),
              ),
            ),

            SizedBox(width: ResponsiveHelper.getSpacing(context, 'xsmall')),

            GestureDetector(
              onTap: () => controller.markAttendance(
                student['id'],
                selectedMeal,
                selectedDay,
                false,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'xsmall'),
                ),
                decoration: BoxDecoration(
                  color: isPresent == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'xsmall'),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                  color: isPresent == false ? Colors.white : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessOffDialog(BuildContext context) {
    // State for new mess-off entry
    DateTime startDate = selectedDay;
    DateTime endDate = selectedDay.add(const Duration(days: 1));
    List<String> newMeals = ['breakfast', 'dinner'];

    // State for editing an existing record
    String? editingId;
    DateTime? editEndDate;
    List<String> editMeals = [];

    final fmt = (DateTime d) => '${d.day}/${d.month}/${d.year}';
    const allMealLabels = ['breakfast', 'dinner'];

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final existingRecords = controller.getStudentMessOffRecords(
            student['id'],
          );

          Widget mealChips(
            List<String> selected,
            void Function(String, bool) onChanged,
          ) {
            return Wrap(
              spacing: 4,
              runSpacing: 8,
              children: allMealLabels.map((meal) {
                final isSelected = selected.contains(meal);
                return FilterChip(
                  label: Text(
                    meal[0].toUpperCase() + meal.substring(1),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? AppColors.warning
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (v) => onChanged(meal, v),
                  selectedColor: AppColors.warning.withOpacity(0.18),
                  checkmarkColor: AppColors.warning,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            );
          }

          return AlertDialog(
            title: Text(
              'Mess Off — ${student['name']}',
              style: AppTextStyles.heading5,
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Existing records ──────────────────────────────────
                    if (existingRecords.isNotEmpty) ...[
                      Text(
                        'Active Mess-Off Periods:',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...existingRecords.map((record) {
                        final isEditing = editingId == record.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: isEditing
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Start date — read-only
                                    Text(
                                      'Start: ${fmt(record.startDate)}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // End date — editable
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: ctx,
                                          initialDate: editEndDate!,
                                          firstDate: record.startDate,
                                          lastDate: DateTime.now().add(
                                            const Duration(days: 90),
                                          ),
                                        );
                                        if (picked != null) {
                                          setState(() => editEndDate = picked);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'End: ',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                          Text(
                                            fmt(editEndDate!),
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.edit_calendar,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Meals:',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    mealChips(editMeals, (meal, v) {
                                      setState(() {
                                        if (v) {
                                          editMeals.add(meal);
                                        } else {
                                          editMeals.remove(meal);
                                        }
                                      });
                                    }),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              setState(() => editingId = null),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (editMeals.isEmpty) {
                                              ToastMessage.error(
                                                'Select at least one meal',
                                              );
                                              return;
                                            }
                                            await controller
                                                .updateStudentMessOff(
                                                  student['id'],
                                                  record.id,
                                                  editEndDate!,
                                                  List.from(editMeals),
                                                );
                                            setState(() => editingId = null);
                                            ToastMessage.success(
                                              'Mess off updated',
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.warning,
                                            foregroundColor: Colors.white,
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${fmt(record.startDate)} → ${fmt(record.endDate)}',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: AppColors.warning,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          if (record.meals.isNotEmpty)
                                            Text(
                                              record.meals
                                                  .map(
                                                    (m) =>
                                                        m[0].toUpperCase() +
                                                        m.substring(1),
                                                  )
                                                  .join(', '),
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Edit button
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        editingId = record.id;
                                        editEndDate = record.endDate;
                                        editMeals = List.from(
                                          record.meals.isEmpty
                                              ? allMealLabels
                                              : record.meals,
                                        );
                                      }),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    // Remove button
                                    GestureDetector(
                                      onTap: () async {
                                        Get.back();
                                        await controller.removeStudentMessOff(
                                          student['id'],
                                          record.id,
                                        );
                                        ToastMessage.success(
                                          'Mess off removed',
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      }),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                    ],

                    // ── New mess-off (hidden while editing an existing record) ─
                    if (editingId == null) ...[
                      Text(
                        'Set New Mess Off:',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('Start Date', style: AppTextStyles.body2),
                        subtitle: Text(
                          fmt(startDate),
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.calendar_today, size: 18),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: startDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 1),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 90),
                            ),
                          );
                          if (picked != null)
                            setState(() => startDate = picked);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('End Date', style: AppTextStyles.body2),
                        subtitle: Text(
                          fmt(endDate),
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.calendar_today, size: 18),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: endDate,
                            firstDate: startDate,
                            lastDate: DateTime.now().add(
                              const Duration(days: 90),
                            ),
                          );
                          if (picked != null) setState(() => endDate = picked);
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Meals:',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      mealChips(newMeals, (meal, v) {
                        setState(() {
                          if (v) {
                            newMeals.add(meal);
                          } else {
                            newMeals.remove(meal);
                          }
                        });
                      }),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            // Bottom actions only shown when NOT in edit mode
            actions: editingId != null
                ? null
                : [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (endDate.isBefore(startDate)) {
                          ToastMessage.error(
                            'End date must be after start date',
                          );
                          return;
                        }
                        if (newMeals.isEmpty) {
                          ToastMessage.error('Select at least one meal');
                          return;
                        }
                        Get.back();
                        await controller.setStudentMessOff(
                          student['id'],
                          startDate,
                          endDate,
                          meals: newMeals,
                        );
                        ToastMessage.success('Mess off set successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
          );
        },
      ),
    );
  }

  Widget _buildMessOffBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'small'),
        vertical: ResponsiveHelper.getSpacing(context, 'xs'),
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'small'),
        ),
        border: Border.all(color: AppColors.warning.withOpacity(0.5)),
      ),
      child: Text(
        'Mess Off',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
