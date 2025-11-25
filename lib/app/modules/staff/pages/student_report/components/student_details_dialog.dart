import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class StudentDetailsDialog {
  static void show(BuildContext context, dynamic student) {
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
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }
}




