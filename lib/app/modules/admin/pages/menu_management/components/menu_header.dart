import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';

/// Header component for the Menu Management page
///
/// This widget displays the page title, description, and an "Add New Item" button.
/// It provides a clean, professional header for the admin menu management interface.
class MenuHeader extends StatelessWidget {
  final VoidCallback onAddItem;

  const MenuHeader({super.key, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          // Icon container with admin role styling
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context, 'small'),
            ),
            decoration: BoxDecoration(
              color: AppColors.adminRole.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 12.0,
                  tablet: 14.0,
                  desktop: 16.0,
                ),
              ),
            ),
            child: Icon(
              FontAwesomeIcons.utensils,
              color: AppColors.adminRole,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 24.0,
                tablet: 24.0,
                desktop: 24.0,
              ),
            ),
          ),

          SizedBox(width: ResponsiveHelper.getSpacing(context, 'large')),

          // Title and description section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menu Management',
                  style: AppTextStyles.heading5.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
                Text(
                  'Manage menu categories, items, and nutritional information',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Add new item button
          Flexible(
            child: ReusableButton(
              text: 'Add New Item',
              onPressed: onAddItem,
              type: ButtonType.primary,
              size: ButtonSize.medium,
              icon: FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
    );
  }
}




