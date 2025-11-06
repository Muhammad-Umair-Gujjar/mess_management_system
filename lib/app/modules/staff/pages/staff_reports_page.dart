import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../widgets/common/reusable_button.dart';

import '../staff_controller.dart';

class StaffReportsPage extends StatefulWidget {
  const StaffReportsPage({super.key});

  @override
  State<StaffReportsPage> createState() => _StaffReportsPageState();
}

class _StaffReportsPageState extends State<StaffReportsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  // String _selectedReportType = 'attendance';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: Column(
        children: [
          // Header with Date Filters
          _buildHeader(isMobile),

          SizedBox(height: 24.h),

          // Report Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAttendanceReportsTab(controller, isMobile),
                _buildBillingReportsTab(controller, isMobile),
                _buildMenuAnalyticsTab(controller, isMobile),
                _buildStudentReportsTab(controller, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Title and Export
          Row(
            children: [
              Text('Reports & Analytics', style: AppTextStyles.heading5),
              const Spacer(),
              if (!isMobile) ...[
                _buildDatePicker(
                  'From',
                  _startDate,
                  (date) => _startDate = date,
                ),
                SizedBox(width: 16.w),
                _buildDatePicker('To', _endDate, (date) => _endDate = date),
                SizedBox(width: 16.w),
              ],
              ReusableButton(
                text: 'Export Data',
                icon: FontAwesomeIcons.download,
                type: ButtonType.primary,
                size: ButtonSize.medium,
                onPressed: _exportReports,
              ),
            ],
          ),

          if (isMobile) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'From',
                    _startDate,
                    (date) => _startDate = date,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDatePicker(
                    'To',
                    _endDate,
                    (date) => _endDate = date,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 20.h),

          // Tab Selector
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isMobile,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(4.r),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.body2,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: _buildTabItem(
                    FontAwesomeIcons.userCheck,
                    'Attendance',
                  ),
                ),
                Tab(child: _buildTabItem(FontAwesomeIcons.receipt, 'Billing')),
                Tab(
                  child: _buildTabItem(
                    FontAwesomeIcons.chartLine,
                    'Menu Analytics',
                  ),
                ),
                Tab(child: _buildTabItem(FontAwesomeIcons.users, 'Students')),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildTabItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(date, onChanged),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.calendar,
              size: 14.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceReportsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Summary Cards
          _buildAttendanceSummaryCards(isMobile),

          SizedBox(height: 24.h),

          // Attendance Chart and Details
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart Section
                Expanded(flex: 2, child: _buildAttendanceChart()),

                if (!isMobile) ...[
                  SizedBox(width: 24.w),
                  // Details Section
                  Expanded(flex: 1, child: _buildAttendanceDetails()),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildAttendanceSummaryCards(bool isMobile) {
    final summaryData = [
      {
        'title': 'Total Students',
        'value': '234',
        'icon': FontAwesomeIcons.users,
        'color': AppColors.primary,
      },
      {
        'title': 'Present Today',
        'value': '201',
        'icon': FontAwesomeIcons.userCheck,
        'color': AppColors.success,
      },
      {
        'title': 'Absent Today',
        'value': '33',
        'icon': FontAwesomeIcons.userXmark,
        'color': AppColors.error,
      },
      {
        'title': 'Attendance Rate',
        'value': '86%',
        'icon': FontAwesomeIcons.chartLine,
        'color': AppColors.warning,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: isMobile ? 1.5 : 1.7,
      ),
      itemCount: summaryData.length,
      itemBuilder: (context, index) {
        final data = summaryData[index];
        return _buildSummaryCard(
          data['title'] as String,
          data['value'] as String,
          data['icon'] as IconData,
          data['color'] as Color,
          index,
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    int index,
  ) {
    return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(icon, size: 14.sp, color: color),
                  ),
                  const Spacer(),
                  Icon(
                    FontAwesomeIcons.arrowTrendUp,
                    size: 10.sp,
                    color: color,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.heading5.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 1.h),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildAttendanceChart() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Attendance Trend', style: AppTextStyles.heading5),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient.scale(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartLine,
                      size: 48.sp,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Chart will be displayed here',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetails() {
    final recentAttendance = [
      {
        'name': 'John Doe',
        'room': 'A-201',
        'status': 'Present',
        'time': '08:30 AM',
      },
      {'name': 'Jane Smith', 'room': 'B-105', 'status': 'Absent', 'time': '-'},
      {
        'name': 'Mike Johnson',
        'room': 'A-302',
        'status': 'Present',
        'time': '08:45 AM',
      },
      {
        'name': 'Sarah Wilson',
        'room': 'C-201',
        'status': 'Present',
        'time': '08:25 AM',
      },
    ];

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Attendance', style: AppTextStyles.heading5),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: recentAttendance.length,
              itemBuilder: (context, index) {
                final record = recentAttendance[index];
                final isPresent = record['status'] == 'Present';

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isPresent
                          ? AppColors.success.withOpacity(0.3)
                          : AppColors.error.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              record['name']!,
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? AppColors.success
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              record['status']!,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.doorOpen,
                            size: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            record['room']!,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                          if (isPresent) ...[
                            SizedBox(width: 12.w),
                            Icon(
                              FontAwesomeIcons.clock,
                              size: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              record['time']!,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingReportsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Billing Summary
          _buildBillingSummaryCards(isMobile),

          SizedBox(height: 24.h),

          // Billing Details
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildRevenueChart()),
                if (!isMobile) ...[
                  SizedBox(width: 24.w),
                  Expanded(flex: 1, child: _buildPaymentStatus()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSummaryCards(bool isMobile) {
    final billingData = [
      {
        'title': 'Monthly Revenue',
        'value': '₹2,45,600',
        'icon': FontAwesomeIcons.indianRupee,
        'color': AppColors.success,
      },
      {
        'title': 'Pending Bills',
        'value': '₹45,200',
        'icon': FontAwesomeIcons.clock,
        'color': AppColors.warning,
      },
      {
        'title': 'Overdue Amount',
        'value': '₹12,300',
        'icon': FontAwesomeIcons.exclamation,
        'color': AppColors.error,
      },
      {
        'title': 'Collection Rate',
        'value': '94%',
        'icon': FontAwesomeIcons.percentage,
        'color': AppColors.info,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: isMobile ? 1.4 : 1.6,
      ),
      itemCount: billingData.length,
      itemBuilder: (context, index) {
        final data = billingData[index];
        return _buildSummaryCard(
          data['title'] as String,
          data['value'] as String,
          data['icon'] as IconData,
          data['color'] as Color,
          index,
        );
      },
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Revenue Trends', style: AppTextStyles.heading5),
              const Spacer(),
              DropdownButton<String>(
                value: 'monthly',
                items: ['weekly', 'monthly', 'quarterly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.successGradient.scale(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.chartBar,
                        size: 36.sp,
                        color: AppColors.success.withOpacity(0.5),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Revenue chart will be displayed here',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus() {
    final paymentData = [
      {'status': 'Paid', 'count': 187, 'color': AppColors.success},
      {'status': 'Pending', 'count': 34, 'color': AppColors.warning},
      {'status': 'Overdue', 'count': 13, 'color': AppColors.error},
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Payment Status',
            style: AppTextStyles.heading5.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 12.h),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentData.length,
              itemBuilder: (context, index) {
                final data = paymentData[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: (data['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: data['color'] as Color,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            '${data['count']}',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          data['status'] as String,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${((data['count'] as int) / 234 * 100).toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: data['color'] as Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuAnalyticsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Menu Analytics', style: AppTextStyles.heading5),
          SizedBox(height: 24.h),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.chartPie,
                    size: 64.sp,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Menu Analytics Coming Soon',
                    style: AppTextStyles.heading5.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentReportsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Reports', style: AppTextStyles.heading5),
          SizedBox(height: 24.h),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.userGraduate,
                    size: 64.sp,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Student Reports Coming Soon',
                    style: AppTextStyles.heading5.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    DateTime currentDate,
    Function(DateTime) onChanged,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        onChanged(pickedDate);
      });
    }
  }

  void _exportReports() {
    Get.snackbar(
      'Export Started',
      'Your report is being generated and will be downloaded shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success.withOpacity(0.1),
      colorText: AppColors.success,
      icon: Icon(FontAwesomeIcons.download, color: AppColors.success),
      duration: const Duration(seconds: 3),
    );
  }
}
