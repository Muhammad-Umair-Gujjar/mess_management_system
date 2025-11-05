import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Row(
        children: [
          _buildCategoryIcon(),
          SizedBox(width: 16.w),
          _buildCategoryInfo(),
          _buildActiveToggle(),
          SizedBox(width: 8.w),
          _buildActionMenu(context),
        ],
      ),
    );
  }

  /// Builds the category icon container
  Widget _buildCategoryIcon() {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.adminRole.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        FontAwesomeIcons.layerGroup,
        color: AppColors.adminRole,
        size: 20.sp,
      ),
    );
  }

  /// Builds the category information (name and item count)
  Widget _buildCategoryInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category['name'] ?? 'Unknown Category',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
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
        size: 16.sp,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.pen,
              size: 16.sp,
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
              size: 16.sp,
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
