import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

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
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Expanded(
            child: ListView(
              children: [
                _buildAverageNutritionCard(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildCategoryNutritionCard(context),
                SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
                _buildPopularItemsCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the section title
  Widget _buildSectionTitle(BuildContext context) {
    return Text(
      'Nutritional Overview',
      style: AppTextStyles.heading5.copyWith(color: AppColors.textPrimary),
    );
  }

  /// Builds the average nutrition statistics card
  Widget _buildAverageNutritionCard(BuildContext context) {
    if (menuItems.isEmpty) {
      return _buildEmptyCard(context, 'No menu items available');
    }

    final avgCalories = _calculateAverage(menuItems, 'calories');
    final avgProtein = _calculateAverage(menuItems, 'protein');
    final avgCarbs = _calculateAverage(menuItems, 'carbs');
    final avgFat = _calculateAverage(menuItems, 'fat');

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Nutritional Values',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          Row(
            children: [
              Expanded(
                child: _buildNutritionStat(
                  context,
                  'Calories',
                  avgCalories.round(),
                  'kcal',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildNutritionStat(
                  context,
                  'Protein',
                  avgProtein,
                  'g',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildNutritionStat(
                  context,
                  'Carbs',
                  avgCarbs,
                  'g',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildNutritionStat(
                  context,
                  'Fat',
                  avgFat,
                  'g',
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds nutrition by category card
  Widget _buildCategoryNutritionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition by Category',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          ..._buildCategoryNutritionList(context),
        ],
      ),
    );
  }

  /// Builds category nutrition list
  List<Widget> _buildCategoryNutritionList(BuildContext context) {
    return [
      for (final category in categories.take(4))
        _buildCategoryNutritionBar(context, category),
    ];
  }

  /// Builds popular items nutrition card
  Widget _buildPopularItemsCard(BuildContext context) {
    final popularItems = menuItems.take(3).toList();

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Items - Detailed Nutrition',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          ...popularItems.map(
            (item) => _buildDetailedNutritionRow(context, item),
          ),
        ],
      ),
    );
  }

  /// Builds a single nutrition statistic
  Widget _buildNutritionStat(
    BuildContext context,
    String label,
    dynamic value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      margin: EdgeInsets.only(
        right: ResponsiveHelper.getSpacing(context, 'small'),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${value is double ? value.toStringAsFixed(1) : value}',
            maxLines: 1,
            style: AppTextStyles.heading5.copyWith(
              
            overflow: TextOverflow.ellipsis,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
          Text(unit, style: AppTextStyles.caption.copyWith(color: color)),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a nutrition progress bar for a category
  Widget _buildCategoryNutritionBar(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    final categoryItems = menuItems
        .where((item) => item['category'] == category['name'])
        .toList();

    if (categoryItems.isEmpty) return const SizedBox.shrink();

    final avgCalories =
        categoryItems.fold<double>(
          0.0,
          (sum, item) => sum + (item['calories'] ?? 0),
        ) /
        categoryItems.length;

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category['name'] ?? 'Unknown',
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${avgCalories.round()} kcal avg',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          LinearProgressIndicator(
            value: (avgCalories / 500).clamp(
              0.0,
              1.0,
            ), // Assuming 500 kcal as max
            backgroundColor: AppColors.textLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              category['color'] ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds detailed nutrition row for an item
  Widget _buildDetailedNutritionRow(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textLight),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'] ?? 'Unknown Item',
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Row(
            children: [
              _buildNutritionDetail(
                context,
                'Cal',
                item['calories'],
                Colors.orange,
              ),
              _buildNutritionDetail(
                context,
                'Protein',
                item['protein'],
                Colors.red,
              ),
              _buildNutritionDetail(
                context,
                'Carbs',
                item['carbs'],
                Colors.blue,
              ),
              _buildNutritionDetail(context, 'Fat', item['fat'], Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a small nutrition detail
  Widget _buildNutritionDetail(
    BuildContext context,
    String label,
    dynamic value,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${value ?? 0}',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  /// Builds an empty state card
  Widget _buildEmptyCard(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getSpacing(context, 'extra_large'),
      ),
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
  double _calculateAverage(List<Map<String, dynamic>> items, String field) {
    if (items.isEmpty) return 0.0;

    final total = items.fold<double>(
      0.0,
      (sum, item) => sum + (item[field] ?? 0),
    );

    return total / items.length;
  }
}




