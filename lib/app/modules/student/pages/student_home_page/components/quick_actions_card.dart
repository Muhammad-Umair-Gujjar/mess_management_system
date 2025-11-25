import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/responsive_constants.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/custom_grid_view.dart';
import '../../../../../widgets/responsive/responsive_widgets.dart';
import '../../../student_controller.dart';

class QuickActionsCard extends StatelessWidget {
  final StudentController controller;

  const QuickActionsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      paddingType: 'medium',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          ResponsiveSpacing(spacingType: 'sectionMargin'),
          _buildActionsGrid(context),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ResponsiveIcon(
          icon: FontAwesomeIcons.bolt,
          sizeType: 'medium',
          color: AppColors.warning,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        ResponsiveText(
          text: 'Quick Actions',
          styleType: 'heading5',
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    final actions = _getQuickActions();
    final gridConfig = ResponsiveConstants.getGridConfig('quickActions')!;

    // Convert actions to GridCardData format
    final gridData = actions
        .map(
          (action) => GridCardData(
            title: action['title'],
            value: '', // Not used for action cards
            icon: action['icon'],
            color: action['color'],
            onTap: action['onTap'],
            customContent: _buildQuickActionContent(action),
          ),
        )
        .toList();

    return CustomGridView(
      data: gridData,
      crossAxisCount: gridConfig['desktop']!, // Desktop: 2 columns
      tabletCrossAxisCount: gridConfig['tablet']!, // Tablet: 4 columns
      mobileCrossAxisCount: gridConfig['mobile']!, // Mobile: 2 columns
      crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 8,
        tablet: 12,
        desktop: 16,
      ),
      mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 8,
        tablet: 12,
        desktop: 16,
      ),
      childAspectRatio: 1.2,
      mobileAspectRatio: 1.3,
      tabletAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cardStyle: CustomGridCardStyle.minimal,
      showAnimation: true,
    );
  }

  List<Map<String, dynamic>> _getQuickActions() {
    return [
      {
        'title': 'View Menu',
        'icon': FontAwesomeIcons.utensils,
        'color': AppColors.secondary,
        'onTap': () => Get.toNamed('/student/menu'),
      },
      {
        'title': 'View Attendance',
        'icon': FontAwesomeIcons.calendarCheck,
        'color': AppColors.success,
        'onTap': () => Get.toNamed('/student/attendance'),
      },
      {
        'title': 'Bills',
        'icon': FontAwesomeIcons.creditCard,
        'color': AppColors.info,
        'onTap': () => Get.toNamed('/student/payment'),
      },
      {
        'title': 'Complaint',
        'icon': FontAwesomeIcons.exclamationTriangle,
        'color': AppColors.warning,
        'onTap': () => Get.toNamed('/student/complaint'),
      },
    ];
  }

  Widget _buildQuickActionContent(Map<String, dynamic> action) {
    return Builder(
      builder: (context) {
        final iconConfig = ResponsiveConstants.getIconSizes('medium')!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: iconConfig['mobile']! + 8,
                tablet: iconConfig['tablet']! + 8,
                desktop: iconConfig['desktop']! + 8,
              ),
              height: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: iconConfig['mobile']! + 8,
                tablet: iconConfig['tablet']! + 8,
                desktop: iconConfig['desktop']! + 8,
              ),
              decoration: BoxDecoration(
                color: action['color'],
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getValue(
                    context,
                    mobile: 6.0,
                    tablet: 8.0,
                    desktop: 10.0,
                  ),
                ),
              ),
              child: ResponsiveIcon(
                icon: action['icon'],
                sizeType: 'medium',
                color: Colors.white,
              ),
            ),
            ResponsiveSpacing(spacingType: 'itemSpacing'),
            Flexible(
              child: ResponsiveText(
                text: action['title'],
                styleType: 'body3',
                color: action['color'],
                fontWeight: FontWeight.w600,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
