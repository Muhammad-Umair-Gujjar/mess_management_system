import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import '../models/menu.dart';
import '../../../core/utils/toast_message.dart';

class MenuService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String _menuItemsCollection = 'menu_items';
  static const String _menuTemplatesCollection = 'menu_templates';
  static const String _activeMenuScheduleCollection = 'active_menu_schedule';
  static const String _mealRatesCollection = 'meal_rates';
  static const String _menuFeedbackCollection = 'menu_feedback';
  static const String _mealCategoriesCollection = 'meal_categories';

  // Current user helper
  String get _currentUserId => _auth.currentUser?.uid ?? 'unknown';

  // ========== MENU ITEMS CRUD ==========

  /// Get all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    // MenuService - getAllMenuItems called
    try {
      final snapshot = await _firestore
          .collection(_menuItemsCollection)
          .orderBy('name')
          .get();

      final items = snapshot.docs
          .map((doc) => MenuItem.fromFirestore(doc))
          .toList();

      // MenuService - Retrieved ${items.length} menu items
      return items;
    } catch (e) {
      // MenuService - Error getting menu items: $e
      print('   Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_menuItemsCollection)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting menu items by category: $e');
      return [];
    }
  }

  /// Get menu item by ID
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      final doc = await _firestore
          .collection(_menuItemsCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return MenuItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting menu item: $e');
      return null;
    }
  }

  /// Create new menu item
  Future<String?> createMenuItem(MenuItem item) async {
    // MenuService - createMenuItem called
    print('   Item name: ${item.name}');
    print('   Item category: ${item.category}');
    print('   Item weekday: ${item.weekday}');

    try {
      // Check if a meal already exists for this category and weekday
      final existingMeal = await checkExistingMeal(item.category, item.weekday);
      if (existingMeal != null) {
        ToastMessage.error(
          '${item.weekday[0].toUpperCase()}${item.weekday.substring(1)} ${item.category} meal already exists. Update it if you want to change.',
        );
        return null;
      }

      final now = DateTime.now();
      final newItem = item.copyWith(
        createdAt: now,
        updatedAt: now,
        createdBy: _currentUserId,
        updatedBy: _currentUserId,
      );

      final docRef = await _firestore
          .collection(_menuItemsCollection)
          .add(newItem.toFirestore());

      print('✅ DEBUG: MenuService - MenuItem created with ID: ${docRef.id}');
      ToastMessage.success('Menu item created successfully');
      return docRef.id;
    } catch (e) {
      print('❌ DEBUG: MenuService - Error creating menu item: $e');
      print('   Stack trace: ${StackTrace.current}');
      ToastMessage.error('Failed to create menu item: ${e.toString()}');
      return null;
    }
  }

  /// Check if a meal already exists for a specific category and weekday
  Future<MenuItem?> checkExistingMeal(String category, String weekday) async {
    try {
      final snapshot = await _firestore
          .collection(_menuItemsCollection)
          .where('category', isEqualTo: category)
          .where('weekday', isEqualTo: weekday)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MenuItem.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print('Error checking existing meal: $e');
      return null;
    }
  }

  /// Update existing menu item
  Future<bool> updateMenuItem(MenuItem item) async {
    try {
      final updatedItem = item.copyWith(
        updatedAt: DateTime.now(),
        updatedBy: _currentUserId,
      );

      await _firestore
          .collection(_menuItemsCollection)
          .doc(item.id)
          .update(updatedItem.toFirestore());

      ToastMessage.success('Menu item updated successfully');
      return true;
    } catch (e) {
      print('Error updating menu item: $e');
      ToastMessage.error('Failed to update menu item: ${e.toString()}');
      return false;
    }
  }

  /// Delete menu item
  Future<bool> deleteMenuItem(String id) async {
    try {
      await _firestore.collection(_menuItemsCollection).doc(id).delete();

      ToastMessage.success('Menu item deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting menu item: $e');
      ToastMessage.error('Failed to delete menu item: ${e.toString()}');
      return false;
    }
  }

  // ========== MENU TEMPLATES CRUD ==========

  /// Get all menu templates
  Future<List<MenuTemplate>> getAllMenuTemplates() async {
    try {
      final snapshot = await _firestore
          .collection(_menuTemplatesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => MenuTemplate.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting menu templates: $e');
      return [];
    }
  }

  /// Get menu template by ID
  Future<MenuTemplate?> getMenuTemplateById(String id) async {
    try {
      final doc = await _firestore
          .collection(_menuTemplatesCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return MenuTemplate.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting menu template: $e');
      return null;
    }
  }

  /// Create menu template
  Future<String?> createMenuTemplate(MenuTemplate template) async {
    try {
      final docRef = await _firestore
          .collection(_menuTemplatesCollection)
          .add(template.toFirestore());

      ToastMessage.success('Menu template created successfully');
      return docRef.id;
    } catch (e) {
      print('Error creating menu template: $e');
      ToastMessage.error('Failed to create template: ${e.toString()}');
      return null;
    }
  }

  /// Update menu template
  Future<bool> updateMenuTemplate(MenuTemplate template) async {
    try {
      await _firestore
          .collection(_menuTemplatesCollection)
          .doc(template.id)
          .update(template.toFirestore());

      ToastMessage.success('Menu template updated successfully');
      return true;
    } catch (e) {
      print('Error updating menu template: $e');
      ToastMessage.error('Failed to update template: ${e.toString()}');
      return false;
    }
  }

  /// Delete menu template
  Future<bool> deleteMenuTemplate(String id) async {
    try {
      await _firestore.collection(_menuTemplatesCollection).doc(id).delete();

      ToastMessage.success('Menu template deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting menu template: $e');
      ToastMessage.error('Failed to delete template: ${e.toString()}');
      return false;
    }
  }

  // ========== ACTIVE SCHEDULE MANAGEMENT ==========

  /// Get current active schedule
  Future<ActiveMenuSchedule?> getCurrentActiveSchedule() async {
    // MenuService - getCurrentActiveSchedule called
    try {
      final snapshot = await _firestore
          .collection(_activeMenuScheduleCollection)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final schedule = ActiveMenuSchedule.fromFirestore(snapshot.docs.first);
        print(
          '✅ DEBUG: MenuService - Found active schedule: ${schedule.templateId}',
        );
        return schedule;
      }

      // MenuService - No active schedule found
      return null;
    } catch (e) {
      print('❌ DEBUG: MenuService - Error getting active schedule: $e');
      print('   Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Set active schedule
  Future<bool> setActiveSchedule(ActiveMenuSchedule schedule) async {
    try {
      // First, deactivate all existing schedules
      final existingSchedules = await _firestore
          .collection(_activeMenuScheduleCollection)
          .where('isActive', isEqualTo: true)
          .get();

      final batch = _firestore.batch();

      for (final doc in existingSchedules.docs) {
        batch.update(doc.reference, {'isActive': false});
      }

      // Add new active schedule
      final docRef = _firestore.collection(_activeMenuScheduleCollection).doc();

      batch.set(docRef, schedule.toFirestore());

      await batch.commit();

      ToastMessage.success('Active menu schedule updated successfully');
      return true;
    } catch (e) {
      print('Error setting active schedule: $e');
      ToastMessage.error('Failed to update schedule: ${e.toString()}');
      return false;
    }
  }

  /// Add menu override for specific date and meal
  Future<bool> addMenuOverride(
    DateTime date,
    String mealType,
    MenuOverride override,
  ) async {
    try {
      final activeSchedule = await getCurrentActiveSchedule();
      if (activeSchedule == null) {
        ToastMessage.error('No active schedule found');
        return false;
      }

      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final updatedOverrides = Map<String, Map<String, MenuOverride>>.from(
        activeSchedule.overrides,
      );

      if (!updatedOverrides.containsKey(dateKey)) {
        updatedOverrides[dateKey] = <String, MenuOverride>{};
      }

      updatedOverrides[dateKey]![mealType] = override;

      await _firestore
          .collection(_activeMenuScheduleCollection)
          .doc(activeSchedule.id)
          .update({
            'overrides': _convertOverridesToFirestore(updatedOverrides),
          });

      ToastMessage.success('Menu override added successfully');
      return true;
    } catch (e) {
      print('Error adding menu override: $e');
      ToastMessage.error('Failed to add override: ${e.toString()}');
      return false;
    }
  }

  Map<String, dynamic> _convertOverridesToFirestore(
    Map<String, Map<String, MenuOverride>> overrides,
  ) {
    final result = <String, dynamic>{};
    for (final dateEntry in overrides.entries) {
      final mealData = <String, dynamic>{};
      for (final mealEntry in dateEntry.value.entries) {
        mealData[mealEntry.key] = mealEntry.value.toJson();
      }
      result[dateEntry.key] = mealData;
    }
    return result;
  }

  // ========== MEAL RATES MANAGEMENT ==========

  /// Get all meal rates
  Future<List<MealRate>> getAllMealRates() async {
    try {
      final snapshot = await _firestore
          .collection(_mealRatesCollection)
          .orderBy('category')
          .get();

      return snapshot.docs.map((doc) => MealRate.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting meal rates: $e');
      return [];
    }
  }

  /// Get current rate for category
  Future<MealRate?> getCurrentRate(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_mealRatesCollection)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('effectiveFrom', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MealRate.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print('Error getting current rate: $e');
      return null;
    }
  }

  /// Update meal rate
  Future<bool> updateMealRate(MealRate rate) async {
    try {
      // Deactivate existing rates for this category
      final existingRates = await _firestore
          .collection(_mealRatesCollection)
          .where('category', isEqualTo: rate.category)
          .where('isActive', isEqualTo: true)
          .get();

      final batch = _firestore.batch();

      for (final doc in existingRates.docs) {
        batch.update(doc.reference, {'isActive': false});
      }

      // Add new rate
      final docRef = _firestore.collection(_mealRatesCollection).doc();

      batch.set(docRef, rate.toFirestore());

      await batch.commit();

      ToastMessage.success('Meal rate updated successfully');
      return true;
    } catch (e) {
      print('Error updating meal rate: $e');
      ToastMessage.error('Failed to update rate: ${e.toString()}');
      return false;
    }
  }

  // ========== WEEKLY MENU GENERATION ==========

  /// Get weekly menu for specific date
  Future<Map<String, Map<String, MenuItem?>>> getWeeklyMenu(
    DateTime startDate,
  ) async {
    try {
      // MenuService - getWeeklyMenu called for $startDate

      // Get all menu items from Firestore
      final allMenuItems = await getAllMenuItems();
      print('   Found ${allMenuItems.length} total menu items');

      // Build weekly menu by grouping items by weekday and category
      final weeklyMenu = <String, Map<String, MenuItem?>>{};
      final weekdays = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];

      for (final weekday in weekdays) {
        final mealMap = <String, MenuItem?>{};

        // Find breakfast item for this weekday
        final breakfastItem = allMenuItems.firstWhereOrNull(
          (item) =>
              item.weekday.toLowerCase() == weekday &&
              item.category.toLowerCase() == 'breakfast',
        );
        if (breakfastItem != null) {
          mealMap['breakfast'] = breakfastItem;
        }

        // Find dinner item for this weekday
        final dinnerItem = allMenuItems.firstWhereOrNull(
          (item) =>
              item.weekday.toLowerCase() == weekday &&
              item.category.toLowerCase() == 'dinner',
        );
        if (dinnerItem != null) {
          mealMap['dinner'] = dinnerItem;
        }

        weeklyMenu[weekday] = mealMap;
        print(
          '   $weekday: breakfast=${breakfastItem?.name ?? "none"}, dinner=${dinnerItem?.name ?? "none"}',
        );
      }

      print('✅ DEBUG: MenuService - Weekly menu built successfully');
      return weeklyMenu;
    } catch (e) {
      print('❌ DEBUG: MenuService - Error in getWeeklyMenu: $e');
      return _generateEmptyWeeklyMenu();
    }
  }

  MenuItem? _findMenuItem(List<MenuItem> items, String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, Map<String, MenuItem?>> _generateEmptyWeeklyMenu() {
    final weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final emptyMenu = <String, Map<String, MenuItem?>>{};

    for (final day in weekdays) {
      emptyMenu[day] = <String, MenuItem?>{'breakfast': null, 'dinner': null};
    }

    return emptyMenu;
  }

  /// Generate next week schedule
  Future<bool> generateNextWeekSchedule() async {
    try {
      final now = DateTime.now();
      final nextWeekStart = now.add(Duration(days: 7 - now.weekday + 1));
      final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));

      // Get available templates
      final templates = await getAllMenuTemplates();
      final activeTemplates = templates.where((t) => t.isActive).toList();

      if (activeTemplates.isEmpty) {
        ToastMessage.error('No active menu templates found');
        return false;
      }

      // For now, use the first active template
      final selectedTemplate = activeTemplates.first;

      final newSchedule = ActiveMenuSchedule(
        id: '',
        startDate: nextWeekStart,
        endDate: nextWeekEnd,
        templateId: selectedTemplate.id,
        weekNumber: _getWeekNumber(nextWeekStart),
        isActive: false, // Will be activated manually
        overrides: <String, Map<String, MenuOverride>>{},
        createdAt: DateTime.now(),
        createdBy: _currentUserId,
      );

      await _firestore
          .collection(_activeMenuScheduleCollection)
          .add(newSchedule.toFirestore());

      ToastMessage.success('Next week schedule generated');
      return true;
    } catch (e) {
      print('Error generating next week schedule: $e');
      ToastMessage.error('Failed to generate schedule: ${e.toString()}');
      return false;
    }
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(startOfYear).inDays;
    return (difference / 7).ceil();
  }

  // ========== MEAL CATEGORIES MANAGEMENT ==========

  /// Get all meal categories
  Future<List<MealCategory>> getAllMealCategories() async {
    try {
      final snapshot = await _firestore
          .collection(_mealCategoriesCollection)
          .orderBy('displayOrder')
          .get();

      return snapshot.docs
          .map((doc) => MealCategory.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting meal categories: $e');
      return [];
    }
  }

  /// Initialize default meal categories
  Future<bool> initializeDefaultCategories() async {
    try {
      final existingCategories = await getAllMealCategories();
      if (existingCategories.isNotEmpty) {
        return true; // Already initialized
      }

      final defaultCategories = [
        MealCategory(
          id: 'breakfast',
          name: 'Breakfast',
          displayOrder: 1,
          isActive: true,
          defaultRate: 50.0,
          updatedAt: DateTime.now(),
        ),
        MealCategory(
          id: 'dinner',
          name: 'Dinner',
          displayOrder: 2,
          isActive: true,
          defaultRate: 80.0,
          updatedAt: DateTime.now(),
        ),
      ];

      final batch = _firestore.batch();

      for (final category in defaultCategories) {
        final docRef = _firestore
            .collection(_mealCategoriesCollection)
            .doc(category.id);
        batch.set(docRef, category.toFirestore());
      }

      await batch.commit();

      print('Default meal categories initialized');
      return true;
    } catch (e) {
      print('Error initializing default categories: $e');
      return false;
    }
  }

  // ========== MENU FEEDBACK ==========

  /// Submit menu feedback
  Future<bool> submitMenuFeedback(MenuFeedback feedback) async {
    try {
      await _firestore
          .collection(_menuFeedbackCollection)
          .add(feedback.toFirestore());

      ToastMessage.success('Thank you for your feedback!');
      return true;
    } catch (e) {
      print('Error submitting feedback: $e');
      ToastMessage.error('Failed to submit feedback: ${e.toString()}');
      return false;
    }
  }

  /// Get menu feedback for item
  Future<List<MenuFeedback>> getMenuFeedback(String itemId) async {
    try {
      final snapshot = await _firestore
          .collection(_menuFeedbackCollection)
          .where('menuItemId', isEqualTo: itemId)
          .orderBy('submittedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MenuFeedback.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting menu feedback: $e');
      return [];
    }
  }

  // ========== ANALYTICS ==========

  /// Get menu analytics
  Future<Map<String, dynamic>> getMenuAnalytics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // This would typically involve complex queries for analytics
      // For now, return basic statistics
      final menuItems = await getAllMenuItems();
      final feedback = await _firestore
          .collection(_menuFeedbackCollection)
          .where(
            'mealDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('mealDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      final feedbackList = feedback.docs
          .map((doc) => MenuFeedback.fromFirestore(doc))
          .toList();

      final totalItems = menuItems.length;
      final totalFeedback = feedbackList.length;
      final averageRating = feedbackList.isEmpty
          ? 0.0
          : feedbackList.fold(0.0, (sum, f) => sum + f.rating) /
                feedbackList.length;

      return {
        'totalMenuItems': totalItems,
        'totalFeedbackCount': totalFeedback,
        'averageRating': averageRating,
        'periodStart': startDate.toIso8601String(),
        'periodEnd': endDate.toIso8601String(),
      };
    } catch (e) {
      print('Error getting menu analytics: $e');
      return {};
    }
  }

  // ========== REAL-TIME STREAMS ==========

  /// Stream of menu items
  Stream<List<MenuItem>> get menuItemsStream {
    return _firestore
        .collection(_menuItemsCollection)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList(),
        );
  }

  /// Stream of active menu schedule
  Stream<ActiveMenuSchedule?> get activeMenuScheduleStream {
    return _firestore
        .collection(_activeMenuScheduleCollection)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.isNotEmpty
              ? ActiveMenuSchedule.fromFirestore(snapshot.docs.first)
              : null,
        );
  }

  /// Stream of meal rates
  Stream<List<MealRate>> get mealRatesStream {
    return _firestore
        .collection(_mealRatesCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final rates = snapshot.docs
              .map((doc) => MealRate.fromFirestore(doc))
              .toList();
          // Client-side sorting to avoid Firebase composite index requirement
          rates.sort((a, b) => a.category.compareTo(b.category));
          return rates;
        });
  }
}
