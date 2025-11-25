import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

/// Category card component for displaying individual categories
///
/// This widget shows:
/// - Category icon
/// - Category name and item count
/// - Active/inactive toggle switch
/// - Action menu (Edit/Delete)
class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final Function(bool) onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onToggleActive,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'large'),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          _buildCategoryIcon(context),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
          _buildCategoryInfo(context),
          _buildActiveToggle(),
          SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
          _buildActionMenu(context),
        ],
      ),
    );
  }

  /// Builds the category icon container
  Widget _buildCategoryIcon(BuildContext context) {
    return Container(
      width: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 48.0,
        tablet: 52.0,
        desktop: 56.0,
      ),
      height: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 48.0,
        tablet: 52.0,
        desktop: 56.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.adminRole.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
      ),
      child: Icon(
        FontAwesomeIcons.layerGroup,
        color: AppColors.adminRole,
        size: ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 18.0,
          tablet: 19.0,
          desktop: 20.0,
        ),
      ),
    );
  }

  /// Builds the category information (name and item count)
  Widget _buildCategoryInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category['name'] ?? 'Unknown Category',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            '${category['itemCount'] ?? 0} items',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Builds the active/inactive toggle switch
  Widget _buildActiveToggle() {
    return Switch(
      value: category['isActive'] ?? false,
      onChanged: onToggleActive,
      activeColor: AppColors.adminRole,
    );
  }

  /// Builds the action menu (Edit/Delete)
  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        FontAwesomeIcons.ellipsisVertical,
        color: AppColors.textSecondary,
        size: ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 14.0,
          tablet: 15.0,
          desktop: 16.0,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.pen,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 14.0,
                tablet: 15.0,
                desktop: 16.0,
              ),
              color: AppColors.adminRole,
            ),
            title: Text('Edit'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.trash,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 14.0,
                tablet: 15.0,
                desktop: 16.0,
              ),
              color: Colors.red,
            ),
            title: Text('Delete', style: TextStyle(color: Colors.red)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}




