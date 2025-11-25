import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class MealCountCards extends StatelessWidget {
  final StudentController controller;
  final AnimationController countAnimationController;

  const MealCountCards({
    super.key,
    required this.controller,
    required this.countAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    final stats = controller.getMonthlyStats();

    return Row(
      children: [
        Expanded(
          child: _MealCountCard(
            title: 'Breakfast',
            count: stats['breakfastCount'] ?? 0,
            icon: FontAwesomeIcons.sun,
            color: AppColors.warning,
            delay: 0,
            countAnimationController: countAnimationController,
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
        Expanded(
          child: _MealCountCard(
            title: 'Dinner',
            count: stats['dinnerCount'] ?? 0,
            icon: FontAwesomeIcons.moon,
            color: AppColors.info,
            delay: 100,
            countAnimationController: countAnimationController,
          ),
        ),
      ],
    );
  }
}

class _MealCountCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final int delay;
  final AnimationController countAnimationController;

  const _MealCountCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.delay,
    required this.countAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'large'),
          ),
          decoration: AppDecorations.floatingCard(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'medium'),
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                ),
                child: Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(context, 'medium'),
                  color: color,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
              AnimatedBuilder(
                animation: countAnimationController,
                builder: (context, child) {
                  final animatedValue =
                      Tween<double>(begin: 0, end: count.toDouble())
                          .animate(
                            CurvedAnimation(
                              parent: countAnimationController,
                              curve: const Interval(
                                0.2,
                                1.0,
                                curve: Curves.elasticOut,
                              ),
                            ),
                          )
                          .value;

                  return Text(
                    animatedValue.toInt().toString(),
                    style: TextStyle(
                      color: color,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 28,
                        tablet: 26,
                        desktop: 24,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
              Text(
                title,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
