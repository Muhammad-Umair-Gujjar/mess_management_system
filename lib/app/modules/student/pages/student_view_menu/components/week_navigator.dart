import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      height: ResponsiveHelper.getSpacing(context, 'xlarge') * 2.5,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
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
                      width: ResponsiveHelper.getSpacing(context, 'xlarge') * 2,
                      margin: EdgeInsets.only(
                        right: ResponsiveHelper.getSpacing(context, 'small'),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.getSpacing(context, 'xs'),
                        horizontal: ResponsiveHelper.getSpacing(context, 'xs'),
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected
                            ? null
                            : isToday
                            ? AppColors.accent.withOpacity(0.1)
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getSpacing(context, 'medium'),
                        ),
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
                                  offset: Offset(
                                    0,
                                    ResponsiveHelper.getSpacing(
                                      context,
                                      'small',
                                    ),
                                  ),
                                  blurRadius: ResponsiveHelper.getSpacing(
                                    context,
                                    'medium',
                                  ),
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
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                'body3',
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                ResponsiveHelper.getSpacing(context, 'small') *
                                0.25,
                          ),
                          Text(
                            dayDate.day.toString(),
                            style: AppTextStyles.heading5.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                'heading5',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: 100))
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.3),
          );
        },
      ),
    );
  }
}
