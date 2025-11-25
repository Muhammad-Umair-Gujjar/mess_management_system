import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/responsive/responsive_widgets.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveBorderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'medium',
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsiveBorderRadius),
      child: ResponsiveCard(
        paddingType: 'medium',
        decoration: AppDecorations.floatingCard().copyWith(
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: ResponsiveHelper.getPadding(context, 'small'),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, 'small'),
                ),
              ),
              child: ResponsiveIcon(
                icon: icon,
                color: color,
                sizeType: 'medium',
              ),
            ),

            ResponsiveSpacing(spacingType: 'sectionMargin'),

            ResponsiveText(
              text: title,
              styleType: 'subtitle1',
              fontWeight: FontWeight.bold,
            ),

            ResponsiveSpacing(spacingType: 'xs'),

            ResponsiveText(
              text: subtitle,
              styleType: 'body2',
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration:  300.ms ).slideX(begin: 0.1);
  }
}




