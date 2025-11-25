import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';

class TodaysMenuCard extends StatelessWidget {
  final StudentController controller;

  const TodaysMenuCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'cardPadding'),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildMealCard(
            context,
            '🌅 Breakfast',
            'Aloo Paratha, Curd, Pickle',
            '8:00 AM - 10:00 AM',
            AppColors.warning,
          ),
          SizedBox(
            height: ResponsiveHelper.getSpacing(context, 'sectionMargin'),
          ),
          _buildMealCard(
            context,
            '🌙 Dinner',
            'Dal Rice, Sabzi, Roti, Salad',
            '7:00 PM - 9:00 PM',
            AppColors.info,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.utensils,
          color: AppColors.accent,
          size: ResponsiveHelper.getIconSize(context, 'medium'),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'itemSpacing')),
        Text(
          'Today\'s Menu',
          style: AppTextStyles.heading5.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => controller.changePage(3), // Navigate to menu page
          child: Text(
            'View All',
            style: AppTextStyles.button.copyWith(
              color: AppColors.primary,
              fontSize: ResponsiveHelper.getFontSize(context, 'button'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String meal,
    String items,
    String time,
    Color color,
  ) {
    return Container(
      padding: ResponsiveHelper.getPadding(context, 'sectionMargin'),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, 'large'),
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal, style: AppTextStyles.subtitle1.copyWith(color: color)),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(items, style: AppTextStyles.body2),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(time, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
