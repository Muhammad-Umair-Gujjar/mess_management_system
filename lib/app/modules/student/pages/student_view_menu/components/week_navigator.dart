import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class WeekNavigator extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  const WeekNavigator({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      height: 90.h,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context).horizontal,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final dayDate = startOfWeek.add(Duration(days: index));
          final isSelected = selectedDay == index;
          final isToday =
              dayDate.day == now.day &&
              dayDate.month == now.month &&
              dayDate.year == now.year;

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child:
                Container(
                      width: 70.w,
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 4.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected
                            ? null
                            : isToday
                            ? AppColors.accent.withOpacity(0.1)
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isToday && !isSelected
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 8.h),
                                  blurRadius: 16.r,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            weekDays[index],
                            style: AppTextStyles.body2.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            dayDate.day.toString(),
                            style: AppTextStyles.heading5.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: index * 100))
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: 0.3),
          );
        },
      ),
    );
  }
}
