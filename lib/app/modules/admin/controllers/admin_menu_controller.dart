import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/attendance.dart';
import '../../../data/services/menu_service.dart';
import '../../../../core/utils/toast_message.dart';

class AdminMenuController extends GetxController {
  final MenuService _menuService = Get.find<MenuService>();

  // Observables
  var menuItems = <MenuItem>[].obs;
  var menuTemplates = <MenuTemplate>[].obs;
  var mealRates = <MealRate>[].obs;
  var mealCategories = <MealCategory>[].obs;
  var activeSchedule = Rxn<ActiveMenuSchedule>();
  var isLoading = false.obs;
  var isCreatingItem = false.obs;
  var isUpdatingItem = false.obs;
  var isDeletingItem = false.obs;

  // Tab and filter states
  var selectedTabIndex = 0.obs;
  var selectedCategory = 'All Categories'.obs;
  var searchQuery = ''.obs;
  var sortBy = 'Name'.obs;

  // Filtered lists
  List<MenuItem> get filteredMenuItems {
    var items = menuItems.where((item) => item.isActive).toList();

    // Apply category filter
    if (selectedCategory.value != 'All Categories') {
      items = items
          .where(
            (item) => item.category == selectedCategory.value.toLowerCase(),
          )
          .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      items = items
          .where(
            (item) =>
                item.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                item.description.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'Name':
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Category':
        items.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Calories':
        items.sort(
          (a, b) =>
              a.nutritionalInfo.calories.compareTo(b.nutritionalInfo.calories),
        );
        break;
      case 'Created Date':
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return items;
  }

  // Categories with item counts
  List<Map<String, dynamic>> get categoriesWithCounts {
    final categories = <Map<String, dynamic>>[];

    // Add "All Categories" option first
    categories.add({
      'id': 'all',
      'name': 'All Categories',
      'itemCount': menuItems.length,
      'isActive': true,
    });

    // Count items for Breakfast and Dinner categories directly from menu items
    final breakfastCount = menuItems
        .where(
          (item) => item.category.toLowerCase() == 'breakfast' && item.isActive,
        )
        .length;

    final dinnerCount = menuItems
        .where(
          (item) => item.category.toLowerCase() == 'dinner' && item.isActive,
        )
        .length;

    // Add hardcoded categories with actual counts
    categories.add({
      'id': 'breakfast',
      'name': 'Breakfast',
      'itemCount': breakfastCount,
      'isActive': true,
    });

    categories.add({
      'id': 'dinner',
      'name': 'Dinner',
      'itemCount': dinnerCount,
      'isActive': true,
    });

    return categories;
  }

  // Nutrition analytics
  Map<String, dynamic> get nutritionAnalytics {
    final items = filteredMenuItems;

    if (items.isEmpty) {
      return {
        'totalItems': 0,
        'averageCalories': 0.0,
        'averageProtein': 0.0,
        'averageCarbs': 0.0,
        'averageFat': 0.0,
        'vegetarianCount': 0,
        'veganCount': 0,
        'glutenFreeCount': 0,
      };
    }

    final totalCalories = items.fold(
      0.0,
      (sum, item) => sum + item.nutritionalInfo.calories,
    );
    final totalProtein = items.fold(
      0.0,
      (sum, item) => sum + item.nutritionalInfo.protein,
    );
    final totalCarbs = items.fold(
      0.0,
      (sum, item) => sum + item.nutritionalInfo.carbs,
    );
    final totalFat = items.fold(
      0.0,
      (sum, item) => sum + item.nutritionalInfo.fat,
    );

    final vegetarianCount = items.where((item) => item.isVegetarian).length;
    final veganCount = items.where((item) => item.isVegan).length;
    final glutenFreeCount = items.where((item) => item.isGlutenFree).length;

    return {
      'totalItems': items.length,
      'averageCalories': totalCalories / items.length,
      'averageProtein': totalProtein / items.length,
      'averageCarbs': totalCarbs / items.length,
      'averageFat': totalFat / items.length,
      'vegetarianCount': vegetarianCount,
      'veganCount': veganCount,
      'glutenFreeCount': glutenFreeCount,
      'vegetarianPercentage': (vegetarianCount / items.length) * 100,
      'veganPercentage': (veganCount / items.length) * 100,
      'glutenFreePercentage': (glutenFreeCount / items.length) * 100,
    };
  }

  @override
  void onInit() async {
    super.onInit();
    await loadAllData();
    _setupRealTimeListeners();
  }

  // ========== DATA LOADING ==========

  /// Load all data
  Future<void> loadAllData() async {
    // AdminMenuController - loadAllData called
    isLoading.value = true;

    try {
      await Future.wait([
        loadMenuItems(),
        loadMenuTemplates(),
        loadMealRates(),
        loadMealCategories(),
        loadActiveSchedule(),
      ]);
      // AdminMenuController - All data loaded successfully
    } catch (e) {
      // AdminMenuController - Error loading data: $e
      ToastMessage.error('Failed to load menu data');
    } finally {
      isLoading.value = false;
      // AdminMenuController - loadAllData completed
    }
  }

  /// Load menu items from Firebase
  Future<void> loadMenuItems() async {
    try {
      final items = await _menuService.getAllMenuItems();
      menuItems.value = items;
      // Loaded ${items.length} menu items
    } catch (e) {
      print('Error loading menu items: $e');
      ToastMessage.error('Failed to load menu items');
    }
  }

  /// Load menu templates
  Future<void> loadMenuTemplates() async {
    try {
      final templates = await _menuService.getAllMenuTemplates();
      menuTemplates.value = templates;
      // Loaded ${templates.length} menu templates
    } catch (e) {
      print('Error loading menu templates: $e');
      ToastMessage.error('Failed to load menu templates');
    }
  }

  /// Load meal rates
  Future<void> loadMealRates() async {
    try {
      final rates = await _menuService.getAllMealRates();
      mealRates.value = rates;
      // Loaded ${rates.length} meal rates
    } catch (e) {
      print('Error loading meal rates: $e');
      ToastMessage.error('Failed to load meal rates');
    }
  }

  /// Load meal categories
  Future<void> loadMealCategories() async {
    try {
      final categories = await _menuService.getAllMealCategories();
      if (categories.isEmpty) {
        // Initialize default categories if none exist
        await _menuService.initializeDefaultCategories();
        final defaultCategories = await _menuService.getAllMealCategories();
        mealCategories.value = defaultCategories;
      } else {
        mealCategories.value = categories;
      }
      print('Loaded ${mealCategories.length} meal categories');
    } catch (e) {
      print('Error loading meal categories: $e');
      ToastMessage.error('Failed to load meal categories');
    }
  }

  /// Load active schedule
  Future<void> loadActiveSchedule() async {
    try {
      final schedule = await _menuService.getCurrentActiveSchedule();
      activeSchedule.value = schedule;
      // Active schedule loaded: ${schedule?.templateId ?? 'none'}
    } catch (e) {
      print('Error loading active schedule: $e');
      ToastMessage.error('Failed to load active schedule');
    }
  }

  // ========== REAL-TIME LISTENERS ==========

  void _setupRealTimeListeners() {
    // Listen to menu items changes
    _menuService.menuItemsStream.listen(
      (items) {
        menuItems.value = items;
        // Real-time update: ${items.length} menu items
      },
      onError: (error) {
        print('Error in menu items stream: $error');
      },
    );

    // Listen to active schedule changes
    _menuService.activeMenuScheduleStream.listen(
      (schedule) {
        activeSchedule.value = schedule;
        // Real-time update: Active schedule changed
      },
      onError: (error) {
        print('Error in active schedule stream: $error');
      },
    );

    // Listen to meal rates changes
    _menuService.mealRatesStream.listen(
      (rates) {
        mealRates.value = rates;
        // Real-time update: ${rates.length} meal rates
      },
      onError: (error) {
        print('Error in meal rates stream: $error');
      },
    );
  }

  // ========== MENU ITEMS MANAGEMENT ==========

  /// Create new menu item
  Future<void> createMenuItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required String weekday,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required double sodium,
    String imageUrl = '',
    String preparationTime = '15 mins',
    SpiceLevel spiceLevel = SpiceLevel.mild,
    List<String> allergens = const [],
    bool isVegetarian = false,
    bool isVegan = false,
    bool isGlutenFree = false,
  }) async {
    // AdminMenuController - createMenuItem called
    print('  Name: $name');
    print('  Description: $description');
    print('  Price: $price');
    print('  Category: $category');
    print('  Weekday: $weekday');
    print('  Calories: $calories');

    isCreatingItem.value = true;

    try {
      final nutritionalInfo = NutritionalInfo(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: fiber,
        sodium: sodium,
      );

      final mealType = category == 'breakfast'
          ? MealType.breakfast
          : MealType.dinner;

      final newItem = MenuItem(
        id: '', // Will be set by Firestore
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        category: category,
        weekday: weekday.toLowerCase(),
        nutritionalInfo: nutritionalInfo,
        preparationTime: preparationTime,
        spiceLevel: spiceLevel,
        allergens: allergens,
        isVegetarian: isVegetarian,
        isVegan: isVegan,
        isGlutenFree: isGlutenFree,
        isActive: true,
        createdAt: DateTime.now(),
        createdBy: 'admin', // TODO: Get actual user ID from auth service
        updatedAt: DateTime.now(),
        updatedBy: 'admin', // TODO: Get actual user ID from auth service
        mealType: mealType,
      );

      final itemId = await _menuService.createMenuItem(newItem);

      if (itemId != null) {
        print(
          '✅ DEBUG: AdminMenuController - Menu item created successfully with ID: $itemId',
        );
        ToastMessage.success('Menu item "$name" created successfully');
        await loadMenuItems(); // Refresh the list
      } else {
        print(
          '❌ DEBUG: AdminMenuController - Failed to create menu item - no ID returned',
        );
        ToastMessage.error('Failed to create menu item');
      }
    } catch (e) {
      print('❌ DEBUG: AdminMenuController - Error creating menu item: $e');
      print('   Stack trace: ${StackTrace.current}');
      ToastMessage.error('Failed to create menu item: ${e.toString()}');
    } finally {
      print('🔵 DEBUG: AdminMenuController - createMenuItem completed');
      isCreatingItem.value = false;
    }
  }

  /// Update existing menu item
  Future<void> updateMenuItem(MenuItem item) async {
    isUpdatingItem.value = true;

    try {
      final success = await _menuService.updateMenuItem(item);

      if (success) {
        ToastMessage.success('Menu item "${item.name}" updated successfully');
        await loadMenuItems(); // Refresh the list
      }
    } catch (e) {
      print('Error updating menu item: $e');
      ToastMessage.error('Failed to update menu item: ${e.toString()}');
    } finally {
      isUpdatingItem.value = false;
    }
  }

  /// Delete menu item
  Future<void> deleteMenuItem(String itemId, String itemName) async {
    isDeletingItem.value = true;

    try {
      final success = await _menuService.deleteMenuItem(itemId);

      if (success) {
        ToastMessage.success('Menu item "$itemName" deleted successfully');
        await loadMenuItems(); // Refresh the list
      }
    } catch (e) {
      print('Error deleting menu item: $e');
      ToastMessage.error('Failed to delete menu item: ${e.toString()}');
    } finally {
      isDeletingItem.value = false;
    }
  }

  // ========== MENU TEMPLATES MANAGEMENT ==========

  /// Create menu template
  Future<void> createMenuTemplate({
    required String name,
    required Map<String, DayMenu> meals,
  }) async {
    isLoading.value = true;

    try {
      final newTemplate = MenuTemplate(
        id: '', // Will be set by Firestore
        name: name,
        isActive: true,
        createdAt: DateTime.now(),
        createdBy: 'admin', // TODO: Get actual user ID from auth service
        meals: meals,
      );

      final templateId = await _menuService.createMenuTemplate(newTemplate);

      if (templateId != null) {
        ToastMessage.success('Menu template "$name" created successfully');
        await loadMenuTemplates();
      }
    } catch (e) {
      print('Error creating menu template: $e');
      ToastMessage.error('Failed to create template: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Activate menu template for current week
  Future<void> activateMenuTemplate(
    String templateId,
    DateTime startDate,
  ) async {
    isLoading.value = true;

    try {
      final endDate = startDate.add(const Duration(days: 6));

      final newSchedule = ActiveMenuSchedule(
        id: '', // Will be set by Firestore
        startDate: startDate,
        endDate: endDate,
        templateId: templateId,
        weekNumber: _getWeekNumber(startDate),
        isActive: true,
        overrides: <String, Map<String, MenuOverride>>{},
        createdAt: DateTime.now(),
        createdBy: 'admin', // TODO: Get actual user ID from auth service
      );

      final success = await _menuService.setActiveSchedule(newSchedule);

      if (success) {
        ToastMessage.success('Menu template activated for this week');
        await loadActiveSchedule();
      }
    } catch (e) {
      print('Error activating menu template: $e');
      ToastMessage.error('Failed to activate template: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(startOfYear).inDays;
    return (difference / 7).ceil();
  }

  // ========== MENU OVERRIDES ==========

  /// Add menu override for specific date and meal
  Future<void> addMenuOverride({
    required DateTime date,
    required String mealType,
    required String itemId,
    required String reason,
    String customName = '',
    String customDescription = '',
  }) async {
    isLoading.value = true;

    try {
      final override = MenuOverride(
        itemId: itemId,
        customName: customName,
        customDescription: customDescription,
        reason: reason,
        updatedBy: 'admin', // TODO: Get actual user ID from auth service
        updatedAt: DateTime.now(),
      );

      final success = await _menuService.addMenuOverride(
        date,
        mealType,
        override,
      );

      if (success) {
        ToastMessage.success('Menu override added successfully');
        await loadActiveSchedule();
      }
    } catch (e) {
      print('Error adding menu override: $e');
      ToastMessage.error('Failed to add override: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ========== MEAL RATES MANAGEMENT ==========

  /// Update meal rate
  Future<void> updateMealRate({
    required String category,
    required double rate,
    String notes = '',
  }) async {
    isLoading.value = true;

    try {
      final mealType = category == 'breakfast'
          ? MealType.breakfast
          : MealType.dinner;

      final newRate = MealRate(
        id: '', // Will be set by Firestore
        category: category,
        rate: rate,
        effectiveFrom: DateTime.now(),
        isActive: true,
        createdAt: DateTime.now(),
        createdBy: 'admin', // TODO: Get actual user ID from auth service
        updatedAt: DateTime.now(),
        updatedBy: 'admin', // TODO: Get actual user ID from auth service
        notes: notes,
        mealType: mealType,
      );

      final success = await _menuService.updateMealRate(newRate);

      if (success) {
        ToastMessage.success('$category rate updated to ₹$rate');
        await loadMealRates();
      }
    } catch (e) {
      print('Error updating meal rate: $e');
      ToastMessage.error('Failed to update rate: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ========== FILTERS AND SEARCH ==========

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Update selected category
  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  /// Update sort option
  void updateSortBy(String sortOption) {
    sortBy.value = sortOption;
  }

  /// Update selected tab
  void updateSelectedTab(int index) {
    selectedTabIndex.value = index;
  }

  // ========== UTILITY METHODS ==========

  /// Get menu item by ID
  MenuItem? getMenuItemById(String id) {
    try {
      return menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get current rate for meal type
  MealRate? getCurrentRate(String category) {
    return MealRate.getCurrentRate(category, mealRates);
  }

  /// Check if item exists in current week menu
  bool isItemInCurrentWeek(String itemId) {
    if (activeSchedule.value == null) return false;

    // This would require checking the template and overrides
    // For now, return false - can be implemented later
    return false;
  }

  /// Generate sample data for testing (only if no data exists)
  Future<void> generateSampleData() async {
    if (menuItems.isNotEmpty) {
      ToastMessage.info('Sample data already exists');
      return;
    }

    isLoading.value = true;

    try {
      // Create sample menu items
      final sampleItems = [
        {
          'name': 'Chicken Biryani',
          'description': 'Aromatic basmati rice with tender chicken pieces',
          'price': 65.0,
          'category': 'dinner',
          'calories': 450.0,
          'protein': 25.0,
          'carbs': 55.0,
          'fat': 12.0,
          'fiber': 3.0,
          'sodium': 800.0,
          'preparationTime': '25 mins',
          'spiceLevel': SpiceLevel.medium,
          'isVegetarian': false,
        },
        {
          'name': 'Masala Dosa',
          'description': 'Crispy rice crepe with spiced potato filling',
          'price': 35.0,
          'category': 'breakfast',
          'calories': 320.0,
          'protein': 8.0,
          'carbs': 62.0,
          'fat': 5.0,
          'fiber': 4.0,
          'sodium': 600.0,
          'preparationTime': '15 mins',
          'spiceLevel': SpiceLevel.mild,
          'isVegetarian': true,
        },
        {
          'name': 'Paneer Butter Masala',
          'description': 'Rich and creamy cottage cheese curry',
          'price': 55.0,
          'category': 'dinner',
          'calories': 380.0,
          'protein': 18.0,
          'carbs': 15.0,
          'fat': 28.0,
          'fiber': 2.0,
          'sodium': 900.0,
          'preparationTime': '20 mins',
          'spiceLevel': SpiceLevel.medium,
          'isVegetarian': true,
        },
      ];

      for (final itemData in sampleItems) {
        await createMenuItem(
          name: itemData['name'] as String,
          description: itemData['description'] as String,
          price: itemData['price'] as double,
          category: itemData['category'] as String,
          weekday: 'monday', // Default weekday for sample data
          calories: itemData['calories'] as double,
          protein: itemData['protein'] as double,
          carbs: itemData['carbs'] as double,
          fat: itemData['fat'] as double,
          fiber: itemData['fiber'] as double,
          sodium: itemData['sodium'] as double,
          preparationTime: itemData['preparationTime'] as String,
          spiceLevel: itemData['spiceLevel'] as SpiceLevel,
          isVegetarian: itemData['isVegetarian'] as bool,
        );
      }

      // Create sample meal rates
      await updateMealRate(
        category: 'breakfast',
        rate: 50.0,
        notes: 'Default breakfast rate',
      );
      await updateMealRate(
        category: 'dinner',
        rate: 80.0,
        notes: 'Default dinner rate',
      );

      ToastMessage.success('Sample data generated successfully');
    } catch (e) {
      print('Error generating sample data: $e');
      ToastMessage.error('Failed to generate sample data');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Clean up any subscriptions if needed
    super.onClose();
  }
}
