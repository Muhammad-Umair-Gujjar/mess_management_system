import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: ResponsiveHelper.isMobile(context) ? null : 200,
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'small'),
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                ),
                child: Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(context, 'small'),
                  color: Colors.white,
                ),
              ),

              SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

              Text(
                value,
                style: AppTextStyles.heading5.copyWith(
                  color: color,

                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                title,
                maxLines: 1,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,

                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
