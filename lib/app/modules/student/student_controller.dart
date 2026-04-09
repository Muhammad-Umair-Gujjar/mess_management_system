import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/student.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/feedback.dart';
import '../../data/models/billing.dart';
import '../../../core/utils/toast_message.dart';
import '../../data/models/attendance.dart';
import '../../data/models/menu.dart';
import '../../data/services/dummy_data_service.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/user_service.dart';
import '../../data/services/auth_service.dart';
import '../user/user_controller.dart';
import '../../widgets/dashboard_navigation.dart';

class StudentController extends GetxController {
  final MenuService _menuService = Get.find<MenuService>();
  final UserService _userService = Get.find<UserService>();
  final UserController _userController = Get.find<UserController>();
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var isLoadingMenu = false.obs;
  var currentStudent = Rxn<Student>();
  var attendanceList = <Attendance>[].obs;
  var recentFeedbacks = <Feedback>[].obs;
  var menuItems = <MenuItem>[].obs;
  var mealRates = <MealRate>[].obs;
  var monthlyBilling = 0.0.obs;
  var currentMonthBill = Rxn<MonthlyBillRecord>();
  var billingHistory = <MonthlyBillRecord>[].obs;
  var attendanceRate = 0.0.obs;
  var currentPageIndex = 0.obs;
  var isLoadingFeedback = false.obs;
  var isSubmittingFeedback = false.obs;
  var isLoadingBilling = false.obs;
  var isGeneratingBillPdf = false.obs;

  // Enhanced menu data
  var currentWeekMenu = <String, Map<String, MenuItem?>>{}.obs;
  var activeMenuSchedule = Rxn<ActiveMenuSchedule>();
  var selectedWeekDate = DateTime.now().obs;

  final Set<String> _loadedAttendanceMonths = <String>{};
  final Set<String> _loadingAttendanceMonths = <String>{};
  late final Worker _userWatcher;

  void _attendanceDebug(String message) {
    print('[ATTENDANCE DEBUG] $message');
  }

  // Navigation menu items
  List<NavigationItem> get navigationItems => [
    const NavigationItem(
      icon: FontAwesomeIcons.house,
      title: 'Dashboard',
      route: '/student/home',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.calendarCheck,
      title: 'Attendance',
      route: '/student/attendance',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.receipt,
      title: 'Billing',
      route: '/student/billing',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.utensils,
      title: 'Menu',
      route: '/student/menu',
    ),
    const NavigationItem(
      icon: FontAwesomeIcons.comment,
      title: 'Feedback',
      route: '/student/feedback',
      badge: 2,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _userWatcher = ever<AppUser?>(_userController.currentUser, (user) {
      if (user == null || user.uid.isEmpty) {
        _clearAttendanceState();
        _clearFeedbackState();
        _clearBillingState();
        update();
        return;
      }

      _clearAttendanceState();
      _clearFeedbackState();
      _clearBillingState();
      ensureMonthlyAttendanceLoaded(DateTime.now());
      loadRecentFeedbacks();
      prepareBillingData();
    });

    selectedWeekDate.value = _getStartOfWeek(DateTime.now());
    loadStudentData();
    _setupRealTimeListeners();
  }

  @override
  void onClose() {
    _userWatcher.dispose();
    super.onClose();
  }

  Future<void> loadStudentData() async {
    // StudentController - loadStudentData called
    isLoading.value = true;

    // Load current student (Ali Ahmed) - using dummy data for now
    final students = DummyDataService.getStudents();
    currentStudent.value = students.firstWhere(
      (s) => s.id == '1',
      orElse: () => students.first,
    );
    print(
      '✅ DEBUG: StudentController - Loaded student: ${currentStudent.value?.name}',
    );

    _clearAttendanceState();
    await ensureMonthlyAttendanceLoaded(DateTime.now());
    await loadRecentFeedbacks(forceRefresh: true);

    // Load Firebase menu data
    await _loadFirebaseMenuData();

    // Calculate billing and attendance rate
    _calculateMonthlyBilling();
    _calculateAttendanceRate();
    await prepareBillingData();

    // StudentController - Student data loaded successfully
    isLoading.value = false;
    update();
  }

  /// Load menu data from Firebase
  Future<void> _loadFirebaseMenuData() async {
    try {
      // Load current week menu
      await loadCurrentWeekMenu();

      // Load meal rates
      await loadMealRates();

      // Load active schedule
      await _loadActiveSchedule();
    } catch (e) {
      print('Error loading Firebase menu data: $e');
      ToastMessage.error('Failed to load menu data');
    }
  }

  /// Load current week menu from Firebase
  Future<void> loadCurrentWeekMenu() async {
    print('🔵 DEBUG: StudentController - loadCurrentWeekMenu called');
    isLoadingMenu.value = true;
    try {
      final startOfWeek = selectedWeekDate.value;
      print(
        '   Week start date: ${DateFormat('yyyy-MM-dd').format(startOfWeek)}',
      );

      final weeklyMenu = await _menuService.getWeeklyMenu(startOfWeek);
      currentWeekMenu.value = weeklyMenu;

      print(
        '✅ DEBUG: StudentController - Loaded weekly menu for ${DateFormat('yyyy-MM-dd').format(startOfWeek)}',
      );
      print('   Menu days: ${weeklyMenu.keys.length}');
    } catch (e) {
      print('❌ DEBUG: StudentController - Error loading current week menu: $e');
      print('   Stack trace: ${StackTrace.current}');
      ToastMessage.error('Failed to load menu: ${e.toString()}');
    } finally {
      isLoadingMenu.value = false;
    }
  }

  /// Load meal rates from Firebase
  Future<void> loadMealRates() async {
    try {
      final rates = await _menuService.getAllMealRates();
      if (rates.isEmpty) {
        mealRates.value = DummyDataService.getMealRates();
        print('Loaded fallback meal rates: ${mealRates.length}');
      } else {
        mealRates.value = rates;
        print('Loaded ${rates.length} meal rates');
      }
    } catch (e) {
      print('Error loading meal rates: $e');
      // Fallback to dummy data if Firebase fails
      mealRates.value = DummyDataService.getMealRates();
    }
  }

  /// Load active menu schedule
  Future<void> _loadActiveSchedule() async {
    try {
      final schedule = await _menuService.getCurrentActiveSchedule();
      activeMenuSchedule.value = schedule;
      // Active schedule loaded: ${schedule?.templateId ?? 'none'}
    } catch (e) {
      print('Error loading active schedule: $e');
    }
  }

  /// Setup real-time listeners for menu updates
  void _setupRealTimeListeners() {
    // Listen to active schedule changes
    _menuService.activeMenuScheduleStream.listen(
      (schedule) {
        activeMenuSchedule.value = schedule;
        // Reload menu when schedule changes
        if (schedule != null) {
          loadCurrentWeekMenu();
        }
        print('Real-time update: Active schedule changed');
      },
      onError: (error) {
        print('Error in active schedule stream: $error');
      },
    );

    // Listen to meal rates changes
    _menuService.mealRatesStream.listen(
      (rates) {
        mealRates.value = rates;
        _calculateMonthlyBilling(); // Recalculate billing when rates change
        print('Real-time update: ${rates.length} meal rates');
      },
      onError: (error) {
        print('Error in meal rates stream: $error');
      },
    );
  }

  void _calculateMonthlyBilling() {
    final now = DateTime.now();
    final currentMonthAttendance = attendanceList
        .where(
          (a) =>
              a.date.month == now.month &&
              a.date.year == now.year &&
              a.isPresent,
        )
        .toList();

    double total = 0;
    for (final attendance in currentMonthAttendance) {
      total += _resolveAttendanceUnitPrice(attendance);
    }

    var resolvedTotal = total;
    if (resolvedTotal <= 0) {
      final existingCurrent = currentMonthBill.value;
      if (existingCurrent != null &&
          existingCurrent.monthId == _monthKey(now) &&
          existingCurrent.totalAmount > 0) {
        resolvedTotal = existingCurrent.totalAmount;
      }
    }

    monthlyBilling.value = resolvedTotal;
  }

  void _calculateAttendanceRate() {
    if (attendanceList.isEmpty) {
      attendanceRate.value = 0.0;
      return;
    }

    final presentCount = attendanceList.where((a) => a.isPresent).length;
    attendanceRate.value = (presentCount / attendanceList.length) * 100;
  }

  List<Attendance> getAttendanceForDate(DateTime date) {
    final monthKey = _monthKey(date);
    if (!_loadedAttendanceMonths.contains(monthKey) &&
        !_loadingAttendanceMonths.contains(monthKey)) {
      ensureMonthlyAttendanceLoaded(date);
    }

    return attendanceList
        .where(
          (a) =>
              a.date.day == date.day &&
              a.date.month == date.month &&
              a.date.year == date.year,
        )
        .toList();
  }

  Future<void> ensureMonthlyAttendanceLoaded(DateTime date) async {
    final uid = _resolveCurrentStudentUid();
    if (uid == null || uid.isEmpty) {
      _attendanceDebug(
        'Skipped month load because uid is empty for ${_monthKey(date)}',
      );
      return;
    }

    final month = _monthKey(date);
    _attendanceDebug('Loading month $month for uid $uid');

    if (_loadedAttendanceMonths.contains(month) ||
        _loadingAttendanceMonths.contains(month)) {
      _attendanceDebug(
        'Skipped month $month for uid $uid because it is already loaded/loading',
      );
      return;
    }

    _loadingAttendanceMonths.add(month);
    try {
      final dailyData = await _userService.getStudentMonthlyAttendance(
        userUid: uid,
        month: date,
      );

      _attendanceDebug(
        'Fetched month $month for uid $uid. Day keys: ${dailyData.keys.toList()}',
      );
      if (dailyData.isEmpty) {
        _attendanceDebug(
          'No attendance data found at students/$uid/attendance/$month',
        );
      }

      _applyMonthlyAttendance(uid, date, dailyData);
      _loadedAttendanceMonths.add(month);

      final monthRecords = attendanceList
          .where((a) => a.date.year == date.year && a.date.month == date.month)
          .length;
      _attendanceDebug(
        'After parsing month $month for uid $uid, attendanceList has $monthRecords records for that month',
      );

      _calculateMonthlyBilling();
      _calculateAttendanceRate();
      attendanceList.refresh();
      update();
    } catch (e) {
      _attendanceDebug('Error loading month $month for uid $uid: $e');
    } finally {
      _loadingAttendanceMonths.remove(month);
    }
  }

  void preloadAttendanceForDate(DateTime date) {
    ensureMonthlyAttendanceLoaded(date);
    ensureWeeklyMenuLoadedForDate(date);
  }

  Future<void> ensureWeeklyMenuLoadedForDate(DateTime date) async {
    final targetWeek = _getStartOfWeek(date);
    final currentWeek = _getStartOfWeek(selectedWeekDate.value);

    if (_isSameDate(targetWeek, currentWeek)) {
      return;
    }

    selectedWeekDate.value = targetWeek;
    await loadCurrentWeekMenu();
  }

  String? _resolveCurrentStudentUid() {
    final fromUserController = _userController.currentUser.value?.uid;
    if (fromUserController != null && fromUserController.isNotEmpty) {
      return fromUserController;
    }

    final fromFirebaseAuth = _authService.currentFirebaseUser?.uid;
    if (fromFirebaseAuth != null && fromFirebaseAuth.isNotEmpty) {
      return fromFirebaseAuth;
    }

    return null;
  }

  void _clearAttendanceState() {
    _loadedAttendanceMonths.clear();
    _loadingAttendanceMonths.clear();
    attendanceList.clear();
    attendanceRate.value = 0.0;
  }

  void _clearFeedbackState() {
    recentFeedbacks.clear();
    isLoadingFeedback.value = false;
    isSubmittingFeedback.value = false;
  }

  void _clearBillingState() {
    currentMonthBill.value = null;
    billingHistory.clear();
    isLoadingBilling.value = false;
    isGeneratingBillPdf.value = false;
    monthlyBilling.value = 0.0;
  }

  Future<void> loadRecentFeedbacks({bool forceRefresh = false}) async {
    if (isLoadingFeedback.value && !forceRefresh) {
      return;
    }

    final studentUid = _resolveCurrentStudentUid();
    if (studentUid == null || studentUid.isEmpty) {
      recentFeedbacks.clear();
      return;
    }

    isLoadingFeedback.value = true;
    try {
      final feedbacks = await _menuService.getStudentFeedbacks(studentUid);
      recentFeedbacks.assignAll(feedbacks);
      update();
    } catch (e) {
      print('Error loading student feedbacks: $e');
    } finally {
      isLoadingFeedback.value = false;
    }
  }

  void _applyMonthlyAttendance(
    String studentUid,
    DateTime monthDate,
    Map<String, dynamic> dailyData,
  ) {
    _attendanceDebug(
      'Parsing monthly data for uid $studentUid month ${_monthKey(monthDate)} with ${dailyData.length} day entries',
    );

    for (final dayEntry in dailyData.entries) {
      final day = int.tryParse(dayEntry.key);
      if (day == null) {
        _attendanceDebug(
          'Skipping day key ${dayEntry.key} because it is not numeric',
        );
        continue;
      }

      final rawDayMap = dayEntry.value;
      if (rawDayMap is! Map) {
        _attendanceDebug(
          'Skipping day $day because value is not a map: ${rawDayMap.runtimeType}',
        );
        continue;
      }

      final dayMap = Map<String, dynamic>.from(rawDayMap);
      final date = DateTime(monthDate.year, monthDate.month, day);
      _attendanceDebug('Day $day payload keys: ${dayMap.keys.toList()}');

      _upsertMealAttendanceFromMap(
        studentUid: studentUid,
        date: date,
        mealType: MealType.breakfast,
        dayMap: dayMap,
        key: 'breakfast',
      );
      _upsertMealAttendanceFromMap(
        studentUid: studentUid,
        date: date,
        mealType: MealType.dinner,
        dayMap: dayMap,
        key: 'dinner',
      );
    }
  }

  void _upsertMealAttendanceFromMap({
    required String studentUid,
    required DateTime date,
    required MealType mealType,
    required Map<String, dynamic> dayMap,
    required String key,
  }) {
    final rawMeal = dayMap[key];
    bool? isPresent;
    String? menuItemId;
    String? menuName;
    double? menuPrice;

    if (rawMeal is bool) {
      isPresent = rawMeal;
    } else if (rawMeal is Map) {
      final mealMap = Map<String, dynamic>.from(rawMeal);
      final rawIsPresent = mealMap['isPresent'];
      if (rawIsPresent is bool) {
        isPresent = rawIsPresent;
      }

      final rawMenuItemId = mealMap['menuItemId'];
      final rawMenuName = mealMap['menuName'];
      if (rawMenuItemId is String && rawMenuItemId.trim().isNotEmpty) {
        menuItemId = rawMenuItemId;
      }
      if (rawMenuName is String && rawMenuName.trim().isNotEmpty) {
        menuName = rawMenuName;
      }
      menuPrice = _toDouble(mealMap['menuPrice']);
    }

    if (isPresent == null) {
      _attendanceDebug(
        'No isPresent found for $key on ${DateFormat('yyyy-MM-dd').format(date)}. Raw value type: ${rawMeal.runtimeType}',
      );
      return;
    }

    _attendanceDebug(
      'Resolved $key attendance for ${DateFormat('yyyy-MM-dd').format(date)} as $isPresent',
    );

    attendanceList.removeWhere(
      (a) =>
          a.studentId == studentUid &&
          a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day &&
          a.mealType == mealType,
    );

    attendanceList.add(
      Attendance(
        id: 'att_${studentUid}_${date.millisecondsSinceEpoch}_${mealType.name}',
        studentId: studentUid,
        date: date,
        mealType: mealType,
        isPresent: isPresent,
        markedAt: date,
        markedBy: 'staff',
        menuItemId: menuItemId,
        menuName: menuName,
        menuPrice: menuPrice,
      ),
    );
  }

  String _monthKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Future<void> prepareBillingData({DateTime? monthDate}) async {
    final targetMonth = monthDate ?? DateTime.now();
    await ensureMonthlyAttendanceLoaded(targetMonth);

    if (mealRates.isEmpty) {
      await loadMealRates();
    }

    await _generateAndStoreMonthlyBill(targetMonth);
    await loadBillingHistory();
  }

  Future<void> loadBillingHistory({int limit = 6}) async {
    final studentUid = _resolveCurrentStudentUid();
    if (studentUid == null || studentUid.isEmpty) {
      billingHistory.clear();
      return;
    }

    isLoadingBilling.value = true;
    try {
      final history = await _userService.getStudentBillingHistory(
        studentUid: studentUid,
        limit: limit,
      );
      billingHistory.assignAll(history);

      final currentMonth = _monthKey(DateTime.now());
      final latestCurrent = history.firstWhereOrNull(
        (record) => record.monthId == currentMonth,
      );
      if (latestCurrent != null) {
        currentMonthBill.value = latestCurrent;
        monthlyBilling.value = latestCurrent.totalAmount;
      }
    } catch (e) {
      print('Error loading billing history: $e');
      billingHistory.clear();
    } finally {
      isLoadingBilling.value = false;
    }
  }

  Future<MonthlyBillRecord?> _generateAndStoreMonthlyBill(
    DateTime monthDate,
  ) async {
    final studentUid = _resolveCurrentStudentUid();
    if (studentUid == null || studentUid.isEmpty) {
      return null;
    }

    final monthId = _monthKey(monthDate);
    final monthAttendance = attendanceList
        .where(
          (a) =>
              a.date.year == monthDate.year &&
              a.date.month == monthDate.month &&
              a.isPresent,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final existing = await _userService.getStudentMonthlyBill(
      studentUid: studentUid,
      monthId: monthId,
    );

    final items = monthAttendance.map((attendance) {
      final fallbackMenu = getMenuForDate(attendance.date, attendance.mealType);
      final menuName =
          (attendance.menuName != null && attendance.menuName!.trim().isNotEmpty)
          ? attendance.menuName!
          : (fallbackMenu?.name ?? _defaultMealName(attendance.mealType));
      final menuItemId = attendance.menuItemId ?? fallbackMenu?.id;
      final unitPrice = _resolveAttendanceUnitPrice(attendance);

      return BillLineItem(
        date: attendance.date,
        mealType: attendance.mealType.name,
        menuItemId: menuItemId,
        menuName: menuName,
        unitPrice: unitPrice,
        pricingSource: _pricingSource(attendance),
      );
    }).toList();

    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice,
    );
    final breakfastCount = monthAttendance
        .where((a) => a.mealType == MealType.breakfast)
        .length;
    final dinnerCount = monthAttendance
        .where((a) => a.mealType == MealType.dinner)
        .length;

    final appUser = _userController.currentUser.value;
    final studentData = _userController.currentStudentData.value;

    final record = MonthlyBillRecord(
      id: monthId,
      monthId: monthId,
      studentUid: studentUid,
      studentName: appUser?.fullName ?? currentStudent.value?.name ?? 'Student',
      studentEmail: appUser?.email ?? '',
      rollNumber: studentData?.rollNumber ?? 'N/A',
      hostel: studentData?.hostel ?? 'N/A',
      roomNumber: studentData?.roomNumber ?? 'N/A',
      presentMeals: monthAttendance.length,
      breakfastCount: breakfastCount,
      dinnerCount: dinnerCount,
      totalAmount: totalAmount,
      status: existing?.status ?? 'generated',
      generatedAt: existing?.generatedAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      items: items,
    );

    await _userService.upsertStudentMonthlyBill(studentUid: studentUid, bill: record);

    currentMonthBill.value = record;
    monthlyBilling.value = totalAmount;
    return record;
  }

  double _resolveAttendanceUnitPrice(Attendance attendance) {
    final snapshotPrice = attendance.menuPrice;
    if (snapshotPrice != null && snapshotPrice > 0) {
      return snapshotPrice;
    }

    final fallbackMenu = getMenuForDate(attendance.date, attendance.mealType);
    final fallbackMenuPrice = fallbackMenu?.price;
    if (fallbackMenuPrice != null && fallbackMenuPrice > 0) {
      return fallbackMenuPrice;
    }

    final mealRate = getRateForMealType(attendance.mealType.name);
    if (mealRate != null && mealRate.rate > 0) {
      return mealRate.rate;
    }

    return _defaultUnitPrice(attendance.mealType);
  }

  String _pricingSource(Attendance attendance) {
    final snapshotPrice = attendance.menuPrice;
    if (snapshotPrice != null && snapshotPrice > 0) {
      return 'attendance-menu';
    }
    return 'meal-rate';
  }

  String _defaultMealName(MealType mealType) {
    return mealType == MealType.breakfast ? 'Breakfast' : 'Dinner';
  }

  Future<void> downloadCurrentBillPdf() async {
    if (isGeneratingBillPdf.value) {
      return;
    }

    isGeneratingBillPdf.value = true;
    try {
      final bill = currentMonthBill.value ?? await _generateAndStoreMonthlyBill(DateTime.now());
      if (bill == null) {
        ToastMessage.error('No bill data available to export.');
        return;
      }

      final pdf = pw.Document();
      final monthLabel = _displayMonthFromMonthId(bill.monthId);
      final generatedOn = DateFormat('dd MMM yyyy, hh:mm a').format(bill.updatedAt);

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text(
              'Hostel Mess Monthly Bill',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Billing Month: $monthLabel'),
            pw.Text('Generated On: $generatedOn'),
            pw.SizedBox(height: 16),
            pw.Text(
              'Student Details',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                _pdfRow('Name', bill.studentName),
                _pdfRow('Email', bill.studentEmail),
                _pdfRow('Roll Number', bill.rollNumber),
                _pdfRow('Hostel', bill.hostel),
                _pdfRow('Room Number', bill.roomNumber),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Summary',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                _pdfRow('Present Meals', '${bill.presentMeals}'),
                _pdfRow('Breakfast Count', '${bill.breakfastCount}'),
                _pdfRow('Dinner Count', '${bill.dinnerCount}'),
                _pdfRow('Total Amount', 'Rs ${bill.totalAmount.toStringAsFixed(0)}'),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Bill Items',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5),
              headers: ['Date', 'Meal', 'Menu Item', 'Price'],
              data: bill.items.map((item) {
                return [
                  DateFormat('dd MMM yyyy').format(item.date),
                  _capitalize(item.mealType),
                  item.menuName,
                  'Rs ${item.unitPrice.toStringAsFixed(0)}',
                ];
              }).toList(),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final filename = 'bill_${bill.monthId}_${bill.rollNumber}.pdf';
      await Printing.sharePdf(bytes: bytes, filename: filename);
      ToastMessage.success('Billing PDF generated successfully.');
    } catch (e) {
      print('Error generating billing PDF: $e');
      ToastMessage.error('Failed to generate billing PDF.');
    } finally {
      isGeneratingBillPdf.value = false;
    }
  }

  pw.TableRow _pdfRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value),
        ),
      ],
    );
  }

  String _displayMonthFromMonthId(String monthId) {
    final parsed = DateTime.tryParse('$monthId-01');
    if (parsed == null) {
      return monthId;
    }
    return DateFormat('MMMM yyyy').format(parsed);
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  /// Get menu for specific date and meal type from Firebase data
  MenuItem? getMenuForDate(DateTime date, MealType mealType) {
    final dayKey = DateFormat(
      'EEEE',
    ).format(date).toLowerCase(); // monday, tuesday, etc.
    final mealTypeStr = mealType.name; // 'breakfast' or 'dinner'

    return currentWeekMenu[dayKey]?[mealTypeStr];
  }

  /// Get meal rate for specific meal type
  MealRate? getRateForMealType(String mealType) {
    final normalizedMeal = mealType.trim().toLowerCase();

    final fromLiveRates = mealRates.firstWhereOrNull((rate) {
      final category = rate.category.trim().toLowerCase();
      final type = rate.mealType.name.toLowerCase();
      return rate.isActive && (category == normalizedMeal || type == normalizedMeal);
    });

    if (fromLiveRates != null) {
      return fromLiveRates;
    }

    return DummyDataService.getMealRates().firstWhereOrNull((rate) {
      final category = rate.category.trim().toLowerCase();
      final type = rate.mealType.name.toLowerCase();
      return rate.isActive && (category == normalizedMeal || type == normalizedMeal);
    });
  }

  double _defaultUnitPrice(MealType mealType) {
    final dummyRate = DummyDataService.getMealRates().firstWhereOrNull(
      (rate) => rate.mealType == mealType && rate.rate > 0,
    );

    if (dummyRate != null) {
      return dummyRate.rate;
    }

    return mealType == MealType.breakfast ? 25 : 40;
  }

  /// Navigate to different week
  Future<void> navigateToWeek(DateTime weekStart) async {
    selectedWeekDate.value = _getStartOfWeek(weekStart);
    await loadCurrentWeekMenu();
  }

  /// Get current week dates
  List<DateTime> getCurrentWeekDates() {
    final startOfWeek = selectedWeekDate.value;
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  /// Get start of week (Monday)
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Navigate to previous week
  Future<void> navigateToPreviousWeek() async {
    final previousWeek = selectedWeekDate.value.subtract(
      const Duration(days: 7),
    );
    await navigateToWeek(previousWeek);
  }

  /// Navigate to next week
  Future<void> navigateToNextWeek() async {
    final nextWeek = selectedWeekDate.value.add(const Duration(days: 7));
    await navigateToWeek(nextWeek);
  }

  /// Navigate to current week
  Future<void> navigateToCurrentWeek() async {
    await navigateToWeek(DateTime.now());
  }

  /// Get week display string
  String getWeekDisplayString() {
    final startOfWeek = selectedWeekDate.value;
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startFormat = DateFormat('MMM dd');
    final endFormat = DateFormat('MMM dd, yyyy');

    return '${startFormat.format(startOfWeek)} - ${endFormat.format(endOfWeek)}';
  }

  /// Check if current week is selected
  bool isCurrentWeekSelected() {
    final now = DateTime.now();
    final currentWeekStart = _getStartOfWeek(now);
    return selectedWeekDate.value.difference(currentWeekStart).inDays == 0;
  }

  /// Submit general feedback using Firebase
  Future<bool> submitFeedback({
    required int rating,
    required String comment,
    required String category,
    String menuItemId = '',
    DateTime? mealDate,
    List<String> tags = const [],
  }) async {
    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) {
      ToastMessage.error('Please enter your feedback message.');
      return false;
    }

    final studentUid = _resolveCurrentStudentUid();
    if (studentUid == null || studentUid.isEmpty) {
      ToastMessage.error(
        'Unable to identify student account. Please login again.',
      );
      return false;
    }

    isSubmittingFeedback.value = true;

    try {
      final studentName = _userController.currentUser.value?.fullName;
      final feedback = Feedback(
        id: '',
        studentId: studentUid,
        studentName: (studentName == null || studentName.trim().isEmpty)
            ? (currentStudent.value?.name ?? 'Student')
            : studentName,
        rating: rating,
        comment: trimmedComment,
        submittedAt: DateTime.now(),
        category: category,
        status: 'pending',
      );

      final success = await _menuService.submitStudentFeedback(feedback);

      if (success) {
        await loadRecentFeedbacks(forceRefresh: true);
        ToastMessage.success(
          'Thank you for your feedback! We\'ll review it soon.',
        );
        return true;
      } else {
        ToastMessage.error('Failed to submit feedback. Please try again.');
        return false;
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      ToastMessage.error('Failed to submit feedback: ${e.toString()}');
      return false;
    } finally {
      isSubmittingFeedback.value = false;
    }
  }

  Map<String, int> getTodaysStats() {
    final today = DateTime.now();
    final todayAttendance = getAttendanceForDate(today);

    return {
      'breakfastAttended': todayAttendance
          .where((a) => a.mealType == MealType.breakfast && a.isPresent)
          .length,
      'dinnerAttended': todayAttendance
          .where((a) => a.mealType == MealType.dinner && a.isPresent)
          .length,
    };
  }

  Map<String, int> getMonthlyStats() {
    final now = DateTime.now();
    final monthlyAttendance = attendanceList
        .where((a) => a.date.month == now.month && a.date.year == now.year)
        .toList();

    final presentCount = monthlyAttendance.where((a) => a.isPresent).length;
    final missedCount = monthlyAttendance.where((a) => !a.isPresent).length;
    final breakfastCount = monthlyAttendance
        .where((a) => a.mealType == MealType.breakfast && a.isPresent)
        .length;
    final dinnerCount = monthlyAttendance
        .where((a) => a.mealType == MealType.dinner && a.isPresent)
        .length;
    final possibleMeals = monthlyAttendance.length;

    return {
      'attendedMeals': presentCount,
      'breakfastCount': breakfastCount,
      'dinnerCount': dinnerCount,
      'totalPossible': possibleMeals,
      'missedMeals': missedCount,
    };
  }

  Map<String, dynamic> getStudentStats() {
    return {
      'currentBill': monthlyBilling.value.toInt(),
      'attendancePercentage': attendanceRate.value.toInt(),
      'pendingDues': 150, // Mock value
      'daysRemaining': 15, // Mock value
    };
  }

  Map<String, Map<String, dynamic>> getTodaysMenu() {
    // Mock today's menu data
    return {
      'Breakfast': {
        'items': ['Idli', 'Sambhar', 'Chutney', 'Tea'],
      },
      'Dinner': {
        'items': ['Rice', 'Dal', 'Sabji', 'Roti'],
      },
    };
  }

  List<Map<String, dynamic>> getRecentActivities() {
    // Mock recent activities data
    return [
      {
        'title': 'Breakfast Attendance Marked',
        'description': 'You attended breakfast today',
        'time': '2h ago',
        'type': 'attendance',
      },
      {
        'title': 'Bill Payment Due',
        'description': 'Monthly bill payment is due',
        'time': '1d ago',
        'type': 'payment',
      },
      {
        'title': 'Menu Updated',
        'description': 'This week\'s menu has been updated',
        'time': '2d ago',
        'type': 'meal',
      },
      {
        'title': 'Feedback Submitted',
        'description': 'Your feedback has been received',
        'time': '3d ago',
        'type': 'complaint',
      },
    ];
  }

  // Navigation methods
  void changePage(int index) {
    currentPageIndex.value = index;
  }

  String getCurrentPageTitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Attendance';
      case 2:
        return 'Billing';
      case 3:
        return 'Menu';
      case 4:
        return 'Feedback';
      default:
        return 'Dashboard';
    }
  }

  String getCurrentPageSubtitle() {
    switch (currentPageIndex.value) {
      case 0:
        return 'Your meal management overview';
      case 1:
        return 'Track your meal attendance';
      case 2:
        return 'View your monthly billing';
      case 3:
        return 'Weekly meal menu';
      case 4:
        return 'Share your feedback';
      default:
        return 'Welcome to Hostel Mess Management';
    }
  }
}
