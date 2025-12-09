import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/toast_message.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../widgets/common/reusable_text_field.dart';
import '../../../../widgets/custom_tab_bar.dart';
import '../../../../data/models/menu.dart';
import '../../../../data/models/attendance.dart';

// Import Firebase admin controller
import '../../controllers/admin_menu_controller.dart';

// Import all menu management components
import 'components/menu_header.dart';
import 'components/menu_filters.dart';
import 'components/menu_item_card.dart';
import 'components/menu_item_dialog.dart';
import 'components/category_card.dart';
import 'components/nutrition_analytics.dart';


class AdminMenuManagementPage extends StatefulWidget {
  const AdminMenuManagementPage({super.key});

  @override
  State<AdminMenuManagementPage> createState() =>
      _AdminMenuManagementPageState();
}

class _AdminMenuManagementPageState extends State<AdminMenuManagementPage> {
  // Firebase controller
  late AdminMenuController controller;

  // Form controllers
  final _searchController = TextEditingController();
  final _categoryController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize Firebase controller
    controller = Get.put(AdminMenuController());

    // Setup search controller listener
    _searchController.addListener(() {
      controller.updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _itemPriceController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Column(
        children: [
          MenuHeader(onAddItem: () => _showAddItemDialog()),

          // Tab bar
          Obx(
            () => Container(
              margin: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getSpacing(context, 'medium'),
              ),
              decoration: AppDecorations.floatingCard(),
              child: CustomTabBar(
                selectedIndex: controller.selectedTabIndex.value,
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context, 'medium'),
                ),
                tabHeight: 45,
                onTap: (index) => controller.updateSelectedTab(index),
                tabs: [
                  CustomTabBarItem(
                    label: 'Menu Items',
                    icon: FontAwesomeIcons.plateWheat,
                  ),
                  CustomTabBarItem(
                    label: 'Categories',
                    icon: FontAwesomeIcons.layerGroup,
                  ),
                  CustomTabBarItem(
                    label: 'Nutrition',
                    icon: FontAwesomeIcons.heartPulse,
                  ),
                ],
                selectedColor: AppColors.adminRole,
                unselectedColor: AppColors.textSecondary,
                selectedBackgroundColor: AppColors.adminRole,
                unselectedBackgroundColor: Colors.transparent,
                showIndicator: true,
                indicatorColor: AppColors.adminRole,
                indicatorHeight: 3,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return IndexedStack(
                index: controller.selectedTabIndex.value,
                children: [
                  _buildMenuItemsTab(),
                  _buildCategoriesTab(),
                  _buildNutritionTab(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds the menu items tab with filters and item list
  Widget _buildMenuItemsTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => MenuFilters(
            searchController: _searchController,
            selectedCategory: controller.selectedCategory.value,
            sortBy: controller.sortBy.value,
            categories: controller.categoriesWithCounts,
            onCategoryChanged: (value) =>
                controller.updateSelectedCategory(value),
            onSortChanged: (value) => controller.updateSortBy(value),
            onSearchChanged: () =>
                controller.updateSearchQuery(_searchController.text),
          ),
        ),
        Expanded(child: _buildMenuItemsList()),
      ],
    );
  }

  /// Builds the filtered and sorted menu items list
  Widget _buildMenuItemsList() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
      ),
      child: Obx(() {
        final filteredItems = controller.filteredMenuItems;

        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return MenuItemCard(
              item: item.toJson(), // Convert MenuItem to Map for compatibility
              onEdit: () => _showEditItemDialog(item.toJson()),
              onDelete: () => _deleteItem(item.toJson()),
            );
          },
        );
      }),
    );
  }

  /// Builds the categories management tab
  Widget _buildCategoriesTab() {
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ReusableTextField(
                  controller: _categoryController,
                  hintText: 'Enter category name...',
                  prefixIcon: Icons.category,
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              ElevatedButton(
                onPressed: _addCategory,
                child: Text('Add Category'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                    vertical: ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.categoriesWithCounts.length > 1
                    ? controller.categoriesWithCounts.length - 1
                    : 0, // Exclude 'All Categories'
                itemBuilder: (context, index) {
                  final category = controller
                      .categoriesWithCounts[index + 1]; // Skip 'All Categories'
                  return CategoryCard(
                    category: category,
                    onToggleActive: (value) => _toggleCategoryActive(category),
                    onEdit: () => _editCategory(category),
                    onDelete: () => _deleteCategory(category),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the nutrition analytics tab
  Widget _buildNutritionTab() {
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
      child: Obx(
        () => NutritionAnalytics(
          menuItems: controller.filteredMenuItems
              .map((item) => item.toJson())
              .toList(),
          categories: controller.categoriesWithCounts,
        ),
      ),
    );
  }

  // Dialog methods
  void _showAddItemDialog() {
    _clearItemForm();
    _showItemDialog('Add New Menu Item', false);
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    _populateItemForm(item);
    _showItemDialog('Edit Menu Item', true, item);
  }

  void _showItemDialog(
    String title,
    bool isEdit, [
    Map<String, dynamic>? item,
  ]) {
    showDialog(
      context: context,
      builder: (context) => MenuItemDialog(
        title: title,
        isEdit: isEdit,
        itemNameController: _itemNameController,
        itemDescriptionController: _itemDescriptionController,
        itemPriceController: _itemPriceController,
        caloriesController: _caloriesController,
        proteinController: _proteinController,
        carbsController: _carbsController,
        fatController: _fatController,
        initialCategory: isEdit && item != null ? item['category'] : null,
        initialWeekday: isEdit && item != null ? item['weekday'] : null,
        onSave: (category, weekday) =>
            _saveMenuItem(isEdit, item, category, weekday),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _clearItemForm() {
    _itemNameController.clear();
    _itemDescriptionController.clear();
    _itemPriceController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }

  void _populateItemForm(Map<String, dynamic> item) {
    _itemNameController.text = item['name'] ?? '';
    _itemDescriptionController.text = item['description'] ?? '';
    _itemPriceController.text = item['price']?.toString() ?? '';

    // Handle nutritional information from nested object
    final nutritionalInfo = item['nutritionalInfo'];
    if (nutritionalInfo is Map<String, dynamic>) {
      _caloriesController.text = nutritionalInfo['calories']?.toString() ?? '0';
      _proteinController.text = nutritionalInfo['protein']?.toString() ?? '0';
      _carbsController.text = nutritionalInfo['carbs']?.toString() ?? '0';
      _fatController.text = nutritionalInfo['fat']?.toString() ?? '0';
    } else {
      // Fallback to direct fields if not nested
      _caloriesController.text = item['calories']?.toString() ?? '0';
      _proteinController.text = item['protein']?.toString() ?? '0';
      _carbsController.text = item['carbs']?.toString() ?? '0';
      _fatController.text = item['fat']?.toString() ?? '0';
    }
  }

  void _saveMenuItem(
    bool isEdit,
    Map<String, dynamic>? existingItem,
    String category,
    String weekday,
  ) async {
    if (_itemNameController.text.isEmpty || _itemPriceController.text.isEmpty) {
      ToastMessage.error('Please fill in required fields');
      return;
    }

    try {
      if (isEdit) {
        // Implement edit functionality
        if (existingItem == null || existingItem['id'] == null) {
          ToastMessage.error('Invalid item data for editing');
          return;
        }

        final updatedItem = MenuItem(
          id: existingItem['id'],
          name: _itemNameController.text,
          description: _itemDescriptionController.text,
          price: double.tryParse(_itemPriceController.text) ?? 0.0,
          category: category,
          weekday: weekday.toLowerCase(),
          nutritionalInfo: NutritionalInfo(
            calories: double.tryParse(_caloriesController.text) ?? 0.0,
            protein: double.tryParse(_proteinController.text) ?? 0.0,
            carbs: double.tryParse(_carbsController.text) ?? 0.0,
            fat: double.tryParse(_fatController.text) ?? 0.0,
            fiber: 0.0,
            sodium: 0.0,
          ),
          preparationTime: existingItem['preparationTime'] ?? '15 mins',
          spiceLevel: SpiceLevel.mild, // Default
          allergens: [],
          isVegetarian: existingItem['isVegetarian'] ?? false,
          isVegan: existingItem['isVegan'] ?? false,
          isGlutenFree: existingItem['isGlutenFree'] ?? false,
          isActive: existingItem['isActive'] ?? true,
          createdAt:
              DateTime.tryParse(existingItem['createdAt'] ?? '') ??
              DateTime.now(),
          createdBy: existingItem['createdBy'] ?? 'admin',
          updatedAt: DateTime.now(),
          updatedBy: 'admin',
          mealType: category.toLowerCase() == 'breakfast'
              ? MealType.breakfast
              : MealType.dinner,
        );

        await controller.updateMenuItem(updatedItem);
      } else {
        await controller.createMenuItem(
          name: _itemNameController.text,
          description: _itemDescriptionController.text,
          price: double.tryParse(_itemPriceController.text) ?? 0.0,
          category: category,
          weekday: weekday,
          calories: double.tryParse(_caloriesController.text) ?? 0.0,
          protein: double.tryParse(_proteinController.text) ?? 0.0,
          carbs: double.tryParse(_carbsController.text) ?? 0.0,
          fat: double.tryParse(_fatController.text) ?? 0.0,
          fiber: 0.0,
          sodium: 0.0,
        );
      }

      ToastMessage.success(
        'Menu item ${isEdit ? 'updated' : 'added'} successfully',
      );
      Navigator.of(context).pop();
    } catch (e) {
      ToastMessage.error('Error saving menu item: $e');
    }
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await controller.deleteMenuItem(item['id'], item['name']);
                Navigator.of(context).pop();
              } catch (e) {
                ToastMessage.error('Error deleting item: $e');
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addCategory() async {
    if (_categoryController.text.isEmpty) {
      ToastMessage.error('Please enter category name');
      return;
    }

    // TODO: Implement category creation in controller
    ToastMessage.success('Category management needs to be implemented');
    _categoryController.clear();
  }

  void _toggleCategoryActive(Map<String, dynamic> category) {
    // TODO: Implement toggle category active in controller
    ToastMessage.success('Category toggle needs to be implemented');
  }

  void _editCategory(Map<String, dynamic> category) {
    _categoryController.text = category['name'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: ReusableTextField(
          controller: _categoryController,
          hintText: 'Category Name',
          prefixIcon: Icons.category,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _categoryController.clear();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_categoryController.text.isNotEmpty) {
                setState(() {
                  category['name'] = _categoryController.text;
                });
                Navigator.of(context).pop();
                _categoryController.clear();
                ToastMessage.success('Category updated successfully');
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category['name']}" category?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement category deletion in controller
              Navigator.of(context).pop();
              ToastMessage.success('Category deletion needs to be implemented');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
