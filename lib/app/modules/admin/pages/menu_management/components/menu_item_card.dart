import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

/// Individual menu item card component
//
class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'large'),
      ),
      decoration: AppDecorations.floatingCard(),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
        child: ResponsiveHelper.isMobile(context)
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  /// Builds the mobile layout with vertical organization
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Image, name, price and availability
        Row(
          children: [
            _buildItemImage(context),
            SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? 'Unknown Item',
                          style: AppTextStyles.heading5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['description'] ?? 'No description available',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(item['price'] ?? 0.0).toStringAsFixed(0)} Rs',
                        style: AppTextStyles.heading5.copyWith(
                          color: AppColors.adminRole,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        // Bottom row: Metadata and actions
        Row(
          children: [
            Expanded(child: _buildItemMetadata(context)),
            _buildMobileActionButtons(context),
          ],
        ),
      ],
    );
  }

  /// Builds the desktop/tablet layout with horizontal organization
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Item image placeholder
        _buildItemImage(context),

        SizedBox(width: ResponsiveHelper.getSpacing(context, 'medium')),

        // Item details section
        Expanded(child: _buildItemDetails(context)),

        // Price and actions section
        _buildPriceAndActions(context),
      ],
    );
  }

  /// Builds compact action buttons for mobile
  Widget _buildMobileActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context,
          icon: FontAwesomeIcons.pen,
          color: AppColors.adminRole,
          onPressed: onEdit,
          tooltip: 'Edit item',
        ),
        _buildActionButton(
          context,
          icon: FontAwesomeIcons.trash,
          color: Colors.red,
          onPressed: onDelete,
          tooltip: 'Delete item',
        ),
      ],
    );
  }

  /// Builds the item image placeholder
  Widget _buildItemImage(BuildContext context) {
    return Container(
      width: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 65.0,
        tablet: 75.0,
        desktop: 85.0,
      ),
      height: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 65.0,
        tablet: 75.0,
        desktop: 85.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 12.0,
            tablet: 14.0,
            desktop: 16.0,
          ),
        ),
        color: AppColors.adminRole.withOpacity(0.1),
      ),
      child: Icon(
        FontAwesomeIcons.utensils,
        color: AppColors.adminRole,
        size: ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 23.0,
          tablet: 25.0,
          desktop: 28.0,
        ),
      ),
    );
  }

  /// Builds the item details (name, description, category, etc.)
  Widget _buildItemDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and availability status
        Row(
          children: [
            Expanded(
              child: Text(
                item['name'] ?? 'Unknown Item',
                style: AppTextStyles.heading5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'xsmall')),

        // Description
        Text(
          item['description'] ?? 'No description available',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // Item metadata (category, time, calories)
        _buildItemMetadata(context),
      ],
    );
  }

  /// Builds the item metadata row (category, weekday, calories)
  Widget _buildItemMetadata(BuildContext context) {
    String weekday = item['weekday'] ?? 'monday';
    String capitalizedWeekday =
        weekday.substring(0, 1).toUpperCase() + weekday.substring(1);

    return ResponsiveHelper.isMobile(context)
        ? Wrap(
            spacing: ResponsiveHelper.getSpacing(context, 'small'),
            runSpacing: ResponsiveHelper.getSpacing(context, 'xs'),
            children: [
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.tag,
                text: item['category'] ?? 'Unknown',
              ),
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.calendar,
                text: capitalizedWeekday,
              ),
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.fire,
                text: '${_getCalories(item)} cal',
              ),
            ],
          )
        : Row(
            children: [
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.tag,
                text: item['category'] ?? 'Unknown',
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.calendar,
                text: capitalizedWeekday,
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              _buildMetadataItem(
                context,
                icon: FontAwesomeIcons.fire,
                text: '${_getCalories(item)} cal',
              ),
            ],
          );
  }

  /// Helper method to get calories from nutritionalInfo
  int _getCalories(Map<String, dynamic> item) {
    final nutritionalInfo = item['nutritionalInfo'];
    if (nutritionalInfo is Map<String, dynamic>) {
      return (nutritionalInfo['calories'] ?? 0).round();
    }
    // Fallback to direct calories field
    return (item['calories'] ?? 0).round();
  }

  /// Builds a single metadata item with icon and text
  Widget _buildMetadataItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 10.0,
            tablet: 11.0,
            desktop: 12.0,
          ),
          color: AppColors.textSecondary,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'xs')),
        Text(
          text,
        
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  /// Builds the price display and action buttons
  Widget _buildPriceAndActions(BuildContext context) {
    return Column(
      children: [
        // Price display
        Text(
          '${(item['price'] ?? 0.0).toStringAsFixed(0)} Rs',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.adminRole,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),

        // Action buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              context,
              icon: FontAwesomeIcons.pen,
              color: AppColors.adminRole,
              onPressed: onEdit,
              tooltip: 'Edit item',
            ),
            _buildActionButton(
              context,
              icon: FontAwesomeIcons.trash,
              color: Colors.red,
              onPressed: onDelete,
              tooltip: 'Delete item',
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a single action button with tooltip
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 13.0,
            tablet: 15.0,
            desktop: 16.0,
          ),
        ),
        color: color,
        splashRadius: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 18.0,
          tablet: 19.0,
          desktop: 20.0,
        ),
      ),
    );
  }
}
