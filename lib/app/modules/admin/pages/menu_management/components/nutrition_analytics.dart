import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Nutrition analytics component
///
/// This widget displays nutritional analysis including:
/// - Average nutritional values across all menu items
/// - Category-wise nutrition comparison
/// - Popular items detailed nutrition breakdown
class NutritionAnalytics extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;
  final List<Map<String, dynamic>> categories;

  const NutritionAnalytics({
    super.key,
    required this.menuItems,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView(
              children: [
                _buildAverageNutritionCard(),
                SizedBox(height: 16.h),
                _buildCategoryNutritionCard(),
                SizedBox(height: 16.h),
                _buildPopularItemsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the section title
  Widget _buildSectionTitle() {
    return Text(
      'Nutritional Overview',
      style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
    );
  }

  /// Builds the average nutrition statistics card
  Widget _buildAverageNutritionCard() {
    if (menuItems.isEmpty) {
      return _buildEmptyCard('No menu items available');
    }

    final avgCalories = _calculateAverage('calories');
    final avgProtein = _calculateAverage('protein');
    final avgCarbs = _calculateAverage('carbs');
    final avgFat = _calculateAverage('fat');

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Nutritional Values',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildNutritionStat(
                  'Calories',
                  avgCalories.round(),
                  'kcal',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildNutritionStat(
                  'Protein',
                  avgProtein,
                  'g',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildNutritionStat('Carbs', avgCarbs, 'g', Colors.blue),
              ),
              Expanded(
                child: _buildNutritionStat('Fat', avgFat, 'g', Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds nutrition by category card
  Widget _buildCategoryNutritionCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition by Category',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          ...categories.take(4).map((category) {
            return _buildCategoryNutritionBar(category);
          }).toList(),
        ],
      ),
    );
  }

  /// Builds popular items nutrition card
  Widget _buildPopularItemsCard() {
    final popularItems = menuItems.take(3).toList();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Items - Detailed Nutrition',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          ...popularItems.map((item) => _buildDetailedNutritionRow(item)),
        ],
      ),
    );
  }

  /// Builds a single nutrition statistic
  Widget _buildNutritionStat(
    String label,
    dynamic value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            '${value is double ? value.toStringAsFixed(1) : value}',
            style: AppTextStyles.heading4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(unit, style: AppTextStyles.caption.copyWith(color: color)),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a nutrition progress bar for a category
  Widget _buildCategoryNutritionBar(Map<String, dynamic> category) {
    final categoryItems = menuItems
        .where((item) => item['category'] == category['name'])
        .toList();

    if (categoryItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final avgCalories =
        categoryItems.fold<double>(
          0.0,
          (sum, item) => sum + (item['calories'] ?? 0),
        ) /
        categoryItems.length;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category['name'] ?? 'Unknown',
              style: AppTextStyles.body1,
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: (avgCalories / 500).clamp(
                0.0,
                1.0,
              ), // Normalize to 500 calories
              backgroundColor: Colors.grey.withOpacity(0.2),
              color: AppColors.adminRole,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${avgCalories.round()} cal avg',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a detailed nutrition row for an item
  Widget _buildDetailedNutritionRow(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unknown Item',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item['category'] ?? 'Unknown Category',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildMiniNutritionStat(
              '${item['calories'] ?? 0}',
              'cal',
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildMiniNutritionStat(
              '${item['protein'] ?? 0}g',
              'protein',
              Colors.red,
            ),
          ),
          Expanded(
            child: _buildMiniNutritionStat(
              '${item['carbs'] ?? 0}g',
              'carbs',
              Colors.blue,
            ),
          ),
          Expanded(
            child: _buildMiniNutritionStat(
              '${item['fat'] ?? 0}g',
              'fat',
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a mini nutrition statistic
  Widget _buildMiniNutritionStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  /// Builds an empty state card
  Widget _buildEmptyCard(String message) {
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: AppDecorations.floatingCard(),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  /// Calculates average value for a nutrition field
  double _calculateAverage(String field) {
    if (menuItems.isEmpty) return 0.0;

    final total = menuItems.fold<double>(
      0.0,
      (sum, item) => sum + (item[field] ?? 0),
    );

    return total / menuItems.length;
  }
}
