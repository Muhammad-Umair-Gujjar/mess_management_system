import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../widgets/common/reusable_text_field.dart';

// Import all menu management components
import 'components/menu_header.dart';
import 'components/menu_tab_bar.dart';
import 'components/menu_filters.dart';
import 'components/menu_item_card.dart';
import 'components/menu_item_dialog.dart';
import 'components/category_card.dart';
import 'components/nutrition_analytics.dart';

/// Main admin menu management page
///
/// This is the refactored version that uses separate component files
/// for better code organization and maintainability.
class AdminMenuManagementPage extends StatefulWidget {
  const AdminMenuManagementPage({super.key});

  @override
  State<AdminMenuManagementPage> createState() =>
      _AdminMenuManagementPageState();
}

class _AdminMenuManagementPageState extends State<AdminMenuManagementPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _categoryController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  // Filter states
  String _selectedCategory = 'All Categories';
  String _sortBy = 'Name';
  bool _showAvailableOnly = false;

  // Sample data - In real app, this would come from a database
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Breakfast', 'itemCount': 15, 'isActive': true},
    {'id': 2, 'name': 'Lunch', 'itemCount': 25, 'isActive': true},
    {'id': 3, 'name': 'Dinner', 'itemCount': 20, 'isActive': true},
    {'id': 4, 'name': 'Snacks', 'itemCount': 12, 'isActive': true},
    {'id': 5, 'name': 'Beverages', 'itemCount': 8, 'isActive': false},
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 1,
      'name': 'Chicken Biryani',
      'description': 'Aromatic basmati rice with tender chicken pieces',
      'category': 'Lunch',
      'price': 180.0,
      'isAvailable': true,
      'calories': 450,
      'protein': 25.0,
      'carbs': 55.0,
      'fat': 12.0,
      'image': 'assets/images/biryani.jpg',
      'preparationTime': '25 mins',
      'spiceLevel': 'Medium',
    },
    {
      'id': 2,
      'name': 'Masala Dosa',
      'description': 'Crispy rice crepe with spiced potato filling',
      'category': 'Breakfast',
      'price': 80.0,
      'isAvailable': true,
      'calories': 320,
      'protein': 8.0,
      'carbs': 62.0,
      'fat': 5.0,
      'image': 'assets/images/dosa.jpg',
      'preparationTime': '15 mins',
      'spiceLevel': 'Mild',
    },
    {
      'id': 3,
      'name': 'Paneer Butter Masala',
      'description': 'Rich and creamy cottage cheese curry',
      'category': 'Dinner',
      'price': 160.0,
      'isAvailable': false,
      'calories': 380,
      'protein': 18.0,
      'carbs': 15.0,
      'fat': 28.0,
      'image': 'assets/images/paneer.jpg',
      'preparationTime': '20 mins',
      'spiceLevel': 'Medium',
    },
    {
      'id': 4,
      'name': 'Samosa',
      'description': 'Crispy triangular pastry with spiced filling',
      'category': 'Snacks',
      'price': 25.0,
      'isAvailable': true,
      'calories': 180,
      'protein': 4.0,
      'carbs': 20.0,
      'fat': 8.0,
      'image': 'assets/images/samosa.jpg',
      'preparationTime': '5 mins',
      'spiceLevel': 'Medium',
    },
    {
      'id': 5,
      'name': 'Masala Chai',
      'description': 'Traditional spiced tea with milk',
      'category': 'Beverages',
      'price': 15.0,
      'isAvailable': true,
      'calories': 80,
      'protein': 2.0,
      'carbs': 12.0,
      'fat': 3.0,
      'image': 'assets/images/chai.jpg',
      'preparationTime': '5 mins',
      'spiceLevel': 'Mild',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          MenuTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuItemsTab(),
                _buildCategoriesTab(),
                NutritionAnalytics(
                  menuItems: _menuItems,
                  categories: _categories,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the menu items tab with filters and item list
  Widget _buildMenuItemsTab() {
    return Column(
      children: [
        MenuFilters(
          searchController: _searchController,
          selectedCategory: _selectedCategory,
          sortBy: _sortBy,
          showAvailableOnly: _showAvailableOnly,
          categories: _categories,
          onCategoryChanged: (value) =>
              setState(() => _selectedCategory = value),
          onSortChanged: (value) => setState(() => _sortBy = value),
          onAvailabilityChanged: (value) =>
              setState(() => _showAvailableOnly = value),
          onSearchChanged: () => setState(() {}),
        ),
        Expanded(child: _buildMenuItemsList()),
      ],
    );
  }

  /// Builds the filtered and sorted menu items list
  Widget _buildMenuItemsList() {
    var filteredItems = _menuItems.where((item) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          item['name'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          item['description'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesCategory =
          _selectedCategory == 'All Categories' ||
          item['category'] == _selectedCategory;

      final matchesAvailability = !_showAvailableOnly || item['isAvailable'];

      return matchesSearch && matchesCategory && matchesAvailability;
    }).toList();

    // Sort items
    filteredItems.sort((a, b) {
      switch (_sortBy) {
        case 'Price':
          return a['price'].compareTo(b['price']);
        case 'Category':
          return a['category'].compareTo(b['category']);
        case 'Availability':
          return b['isAvailable'].toString().compareTo(
            a['isAvailable'].toString(),
          );
        default:
          return a['name'].compareTo(b['name']);
      }
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return MenuItemCard(
            item: item,
            onEdit: () => _showEditItemDialog(item),
            onToggleAvailability: () => _toggleItemAvailability(item),
            onDelete: () => _deleteItem(item),
          );
        },
      ),
    );
  }

  /// Builds the categories management tab
  Widget _buildCategoriesTab() {
    return Container(
      margin: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ReusableTextField(
                  controller: _categoryController,
                  hintText: 'Enter category name...',
                  prefixIcon: Icons.category,
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: _addCategory,
                child: Text('Add Category'),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryCard(
                  category: category,
                  onToggleActive: (value) {
                    setState(() {
                      category['isActive'] = value;
                    });
                  },
                  onEdit: () => _editCategory(category),
                  onDelete: () => _deleteCategory(category),
                );
              },
            ),
          ),
        ],
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
        onSave: () => _saveMenuItem(isEdit, item),
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
    _itemNameController.text = item['name'];
    _itemDescriptionController.text = item['description'];
    _itemPriceController.text = item['price'].toString();
    _caloriesController.text = item['calories'].toString();
    _proteinController.text = item['protein'].toString();
    _carbsController.text = item['carbs'].toString();
    _fatController.text = item['fat'].toString();
  }

  void _saveMenuItem(bool isEdit, [Map<String, dynamic>? existingItem]) {
    if (_itemNameController.text.isEmpty || _itemPriceController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in required fields');
      return;
    }

    final newItem = {
      'id': isEdit ? existingItem!['id'] : _menuItems.length + 1,
      'name': _itemNameController.text,
      'description': _itemDescriptionController.text,
      'category': 'Lunch', // Default category, should be dropdown
      'price': double.tryParse(_itemPriceController.text) ?? 0.0,
      'isAvailable': true,
      'calories': int.tryParse(_caloriesController.text) ?? 0,
      'protein': double.tryParse(_proteinController.text) ?? 0.0,
      'carbs': double.tryParse(_carbsController.text) ?? 0.0,
      'fat': double.tryParse(_fatController.text) ?? 0.0,
      'image': 'assets/images/default.jpg',
      'preparationTime': '15 mins',
      'spiceLevel': 'Medium',
    };

    setState(() {
      if (isEdit) {
        final index = _menuItems.indexWhere(
          (item) => item['id'] == existingItem!['id'],
        );
        if (index != -1) _menuItems[index] = newItem;
      } else {
        _menuItems.add(newItem);
      }
    });

    Navigator.of(context).pop();
    Get.snackbar(
      'Success',
      isEdit
          ? 'Menu item updated successfully'
          : 'Menu item added successfully',
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void _toggleItemAvailability(Map<String, dynamic> item) {
    setState(() {
      item['isAvailable'] = !item['isAvailable'];
    });
    Get.snackbar(
      'Updated',
      'Item ${item['isAvailable'] ? 'enabled' : 'disabled'} successfully',
    );
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
            onPressed: () {
              setState(() {
                _menuItems.removeWhere((i) => i['id'] == item['id']);
              });
              Navigator.of(context).pop();
              Get.snackbar('Deleted', 'Menu item deleted successfully');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    if (_categoryController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter category name');
      return;
    }

    setState(() {
      _categories.add({
        'id': _categories.length + 1,
        'name': _categoryController.text,
        'itemCount': 0,
        'isActive': true,
      });
      _categoryController.clear();
    });

    Get.snackbar('Success', 'Category added successfully');
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
                Get.snackbar('Success', 'Category updated successfully');
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
              setState(() {
                _categories.removeWhere((c) => c['id'] == category['id']);
              });
              Navigator.of(context).pop();
              Get.snackbar('Deleted', 'Category deleted successfully');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
