import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AdminRateConfigurationPage extends StatelessWidget {
  const AdminRateConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(40.r),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.indianRupee,
                size: 64.sp,
                color: AppColors.adminRole,
              ),
              SizedBox(height: 24.h),
              Text(
                'Rate Configuration',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.adminRole,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Meal rate configuration system coming soon!',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
