import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class UserEmptyState extends StatelessWidget {
  const UserEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.users,
            size: 64.sp,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            'No users found',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search criteria',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
