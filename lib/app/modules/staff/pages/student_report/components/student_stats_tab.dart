import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../staff_controller.dart';
import 'stats_cards_grid.dart';

class StudentStatsTab extends StatelessWidget {
  final StaffController controller;
  final bool isMobile;

  const StudentStatsTab({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student Statistics', style: AppTextStyles.heading5),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

            // Stats Cards
            StatsCardsGrid(controller: controller),
          ],
        ),
      ),
    );
  }
}




