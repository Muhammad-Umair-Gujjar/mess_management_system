import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_theme.dart';

class StudentDetailsDialog {
  static void show(BuildContext context, dynamic student) {
    Get.dialog(
      AlertDialog(
        title: Text('Student Details', style: AppTextStyles.heading5),
        content: Container(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${student['name']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
              Text('ID: ${student['id']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
              Text('Room: ${student['room']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
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
