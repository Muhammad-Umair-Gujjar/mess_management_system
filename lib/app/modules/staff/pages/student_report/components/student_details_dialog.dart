import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../staff_controller.dart';

class StudentDetailsDialog {
  static void show(BuildContext context, dynamic student) {
    final StaffController controller = Get.find<StaffController>();
    Get.dialog(
      AlertDialog(
        title: Text('Student Details', style: AppTextStyles.heading5),
        content: Container(
          width: ResponsiveHelper.getComponentDimension(context, 'dialogWidth'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${student['name']}', style: AppTextStyles.body1),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),
              Text('ID: ${student['id']}', style: AppTextStyles.body1),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),
              Text('Room: ${student['room']}', style: AppTextStyles.body1),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),
              Text('Email: ${student['email']}', style: AppTextStyles.body1),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    _showSetMessOffDialog(context, student, controller);
                  },
                  icon: const Icon(Icons.no_meals),
                  label: const Text('Set Mess Off'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: BorderSide(color: AppColors.warning),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  static Future<void> _showSetMessOffDialog(
    BuildContext context,
    dynamic student,
    StaffController controller,
  ) async {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));

    await Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: Text('Set Mess Off', style: AppTextStyles.heading5),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student: ${student['name']}', style: AppTextStyles.body2),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Start Date', style: AppTextStyles.body2),
                  subtitle: Text(
                    '${startDate.day}/${startDate.month}/${startDate.year}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: startDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('End Date', style: AppTextStyles.body2),
                  subtitle: Text(
                    '${endDate.day}/${endDate.month}/${endDate.year}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: endDate,
                      firstDate: startDate,
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (endDate.isBefore(startDate)) {
                    ToastMessage.error('End date must be after start date');
                    return;
                  }
                  Get.back();
                  await controller.setStudentMessOff(
                    student['id'],
                    startDate,
                    endDate,
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
}
