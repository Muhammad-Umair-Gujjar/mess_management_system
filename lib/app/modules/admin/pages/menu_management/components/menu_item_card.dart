import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Individual menu item card component
///
/// This widget displays a single menu item with:
/// - Item image placeholder
/// - Item name, description, and details
/// - Availability status badge
/// - Price display
/// - Action buttons (Edit, Toggle availability, Delete)
class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onToggleAvailability;
  final VoidCallback onDelete;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onToggleAvailability,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: AppDecorations.floatingCard(),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Item image placeholder
            _buildItemImage(),

            SizedBox(width: 16.w),

            // Item details section
            Expanded(child: _buildItemDetails()),

            // Price and actions section
            _buildPriceAndActions(),
          ],
        ),
      ),
    );
  }

  /// Builds the item image placeholder
  Widget _buildItemImage() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.adminRole.withOpacity(0.1),
      ),
      child: Icon(
        FontAwesomeIcons.utensils,
        color: AppColors.adminRole,
        size: 24.sp,
      ),
    );
  }

  /// Builds the item details (name, description, category, etc.)
  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and availability status
        Row(
          children: [
            Expanded(
              child: Text(
                item['name'] ?? 'Unknown Item',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildAvailabilityBadge(),
          ],
        ),

        SizedBox(height: 4.h),

        // Description
        Text(
          item['description'] ?? 'No description available',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 8.h),

        // Item metadata (category, time, calories)
        _buildItemMetadata(),
      ],
    );
  }

  /// Builds the availability status badge
  Widget _buildAvailabilityBadge() {
    final bool isAvailable = item['isAvailable'] ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Unavailable',
        style: AppTextStyles.caption.copyWith(
          color: isAvailable ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the item metadata row (category, time, calories)
  Widget _buildItemMetadata() {
    return Row(
      children: [
        _buildMetadataItem(
          icon: FontAwesomeIcons.tag,
          text: item['category'] ?? 'Unknown',
        ),
        SizedBox(width: 16.w),
        _buildMetadataItem(
          icon: FontAwesomeIcons.clock,
          text: item['preparationTime'] ?? 'N/A',
        ),
        SizedBox(width: 16.w),
        _buildMetadataItem(
          icon: FontAwesomeIcons.fire,
          text: '${item['calories'] ?? 0} cal',
        ),
      ],
    );
  }

  /// Builds a single metadata item with icon and text
  Widget _buildMetadataItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: AppColors.textSecondary),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  /// Builds the price display and action buttons
  Widget _buildPriceAndActions() {
    return Column(
      children: [
        // Price display
        Text(
          '₹${(item['price'] ?? 0.0).toStringAsFixed(0)}',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.adminRole,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8.h),

        // Action buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: FontAwesomeIcons.pen,
              color: AppColors.adminRole,
              onPressed: onEdit,
              tooltip: 'Edit item',
            ),
            _buildActionButton(
              icon: (item['isAvailable'] ?? false)
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              color: (item['isAvailable'] ?? false)
                  ? Colors.orange
                  : Colors.green,
              onPressed: onToggleAvailability,
              tooltip: (item['isAvailable'] ?? false)
                  ? 'Make unavailable'
                  : 'Make available',
            ),
            _buildActionButton(
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
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16.sp),
        color: color,
        splashRadius: 20.r,
      ),
    );
  }
}
