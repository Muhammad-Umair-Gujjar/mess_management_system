import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mess_management/app/data/models/attendance.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';

class MealHeader extends StatelessWidget {
  final MenuItem menuItem;

  const MealHeader({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
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
                    mobile: 22,
                    tablet: 24,
                    desktop: 24,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                DateFormat('EEEE, MMM dd').format(menuItem.date),
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textLight,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 16,
                    tablet: 16,
                    desktop: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
