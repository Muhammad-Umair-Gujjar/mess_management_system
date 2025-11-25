import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/responsive/responsive_widgets.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      paddingType: 'medium',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveIcon(icon: icon, sizeType: 'medium', color: color),
              ResponsiveText(
                text: value,
                styleType: 'heading4',
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          ResponsiveSpacing(spacingType: 'itemSpacing'),

          ResponsiveText(
            text: title,
            styleType: 'body2',
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    ).animate().fadeIn(duration:  300.ms ).scale(begin: const Offset(0.95, 0.95));
  }
}




