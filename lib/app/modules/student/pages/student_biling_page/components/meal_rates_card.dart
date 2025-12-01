import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mess_management/app/data/models/attendance.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../data/models/menu.dart';
import '../../../student_controller.dart';

class MealRatesCard extends StatelessWidget {
  final StudentController controller;
  final AnimationController countAnimationController;

  const MealRatesCard({
    super.key,
    required this.controller,
    required this.countAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          _buildRatesList(context),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text('Current Meal Rates', style: AppTextStyles.heading5),
        const Spacer(),
        if (!ResponsiveHelper.isMobile(context))
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, 'small'),
              vertical: ResponsiveHelper.getSpacing(context, 'small') * 0.5,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getSpacing(context, 'medium'),
              ),
            ),
            child: Text(
              'From Dec 2024',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatesList(BuildContext context) {
    return Column(
      children: controller.mealRates
          .map(
            (rate) => _MealRateItem(
              rate: rate,
              index: controller.mealRates.indexOf(rate),
              countAnimationController: countAnimationController,
            ),
          )
          .toList(),
    );
  }
}

class _MealRateItem extends StatelessWidget {
  final MealRate rate;
  final int index;
  final AnimationController countAnimationController;

  const _MealRateItem({
    required this.rate,
    required this.index,
    required this.countAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    final mealIcon = rate.mealType == MealType.breakfast
        ? FontAwesomeIcons.sun
        : FontAwesomeIcons.moon;
    final mealName = rate.mealType == MealType.breakfast
        ? 'Breakfast'
        : 'Dinner';
    final mealColor = rate.mealType == MealType.breakfast
        ? AppColors.warning
        : AppColors.info;

    return Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getSpacing(context, 'medium'),
          ),
          decoration: BoxDecoration(
            color: mealColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getSpacing(context, 'medium'),
            ),
            border: Border.all(color: mealColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              _buildMealIcon(context, mealIcon, mealColor),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
              _buildMealInfo(mealName, mealColor),
              _buildAnimatedRate(mealColor),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildMealIcon(
    BuildContext context,
    IconData mealIcon,
    Color mealColor,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'small')),
      decoration: BoxDecoration(
        color: mealColor,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getSpacing(context, 'small'),
        ),
      ),
      child: Icon(
        mealIcon,
        size: ResponsiveHelper.getIconSize(context, 'large'),
        color: Colors.white,
      ),
    );
  }

  Widget _buildMealInfo(String mealName, Color mealColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: AppTextStyles.subtitle1.copyWith(
              color: mealColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Per meal cost',
            style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRate(Color mealColor) {
    return AnimatedBuilder(
      animation: countAnimationController,
      builder: (context, child) {
        final animatedValue = Tween<double>(begin: 0, end: rate.rate)
            .animate(
              CurvedAnimation(
                parent: countAnimationController,
                curve: Interval(0.3, 1.0, curve: Curves.easeOut),
              ),
            )
            .value;

        return Text(
          '${animatedValue.toStringAsFixed(0)} Rs',
          style: AppTextStyles.heading4.copyWith(
            color: mealColor,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }
}
