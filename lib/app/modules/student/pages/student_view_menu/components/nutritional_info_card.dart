import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class NutritionalInfoCard extends StatelessWidget {
  final StudentController controller;

  const NutritionalInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Nutrition', style: AppTextStyles.heading5),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

          // Calories Progress
          _buildNutritionProgress(
            context,
            'Calories',
            2400,
            3500, // Weekly target: 500 per day * 7 days
            AppColors.warning,
            FontAwesomeIcons.fire,
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

          // Protein Progress
          _buildNutritionProgress(
            context,
            'Protein',
            180,
            350, // Weekly target
            AppColors.success,
            FontAwesomeIcons.dumbbell,
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideX(begin: -0.3);
  }

  Widget _buildNutritionProgress(
    BuildContext context,
    String label,
    double current,
    double target,
    Color color,
    IconData icon,
  ) {
    final percentage = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getIconSize(context, 'small'),
              color: color,
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '${current.toInt()}/${target.toInt()}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
        Container(
          height: ResponsiveHelper.getSpacing(context, 'small'),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'small') * 0.5,
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'small') * 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
