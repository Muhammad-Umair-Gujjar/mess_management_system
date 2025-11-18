import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/menu.dart';

class MealDetails extends StatelessWidget {
  final MenuItem menuItem;

  const MealDetails({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
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
}
