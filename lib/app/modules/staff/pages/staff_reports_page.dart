import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/toast_message.dart';
import '../../../widgets/common/reusable_button.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../../../widgets/custom_grid_view.dart';

import '../staff_controller.dart';

class StaffReportsPage extends StatefulWidget {
  const StaffReportsPage({super.key});

  @override
  State<StaffReportsPage> createState() => _StaffReportsPageState();
}

class _StaffReportsPageState extends State<StaffReportsPage> {
  int _selectedTabIndex = 0;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

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

          SizedBox(height: 24.0),

          // Report Tabs
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
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
      padding: EdgeInsets.all(20.0),
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
                SizedBox(width: 16.0),
                _buildDatePicker('To', _endDate, (date) => _endDate = date),
                SizedBox(width: 16.0),
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
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'From',
                    _startDate,
                    (date) => _startDate = date,
                  ),
                ),
                SizedBox(width: 16.0),
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

          SizedBox(height: 20.0),

          // Tab Selector
          CustomTabBar(
            tabs: [
              CustomTabBarItem(
                label: 'Attendance',
                icon: FontAwesomeIcons.userCheck,
              ),
              CustomTabBarItem(
                label: 'Billing',
                icon: FontAwesomeIcons.receipt,
              ),
              CustomTabBarItem(
                label: 'Menu Analytics',
                icon: FontAwesomeIcons.chartLine,
              ),
              CustomTabBarItem(label: 'Students', icon: FontAwesomeIcons.users),
            ],
            selectedIndex: _selectedTabIndex,
            onTap: (index) => setState(() => _selectedTabIndex = index),
            selectedColor: Colors.white,
            selectedBackgroundColor: AppColors.staffRole,
            unselectedColor: AppColors.textSecondary,
            showIcons: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
  }

  Widget _buildDatePicker(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(date, onChanged),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.calendar,
              size: 14.0,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.0),
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
      padding: EdgeInsets.all(24.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Summary Cards
          _buildAttendanceSummaryCards(isMobile),

          SizedBox(height: 24.0),

          // Attendance Chart and Details
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart Section
                Expanded(flex: 2, child: _buildAttendanceChart()),

                if (!isMobile) ...[
                  SizedBox(width: 24.0),
                  // Details Section
                  Expanded(flex: 1, child: _buildAttendanceDetails()),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.3);
  }

  Widget _buildAttendanceSummaryCards(bool isMobile) {
    final gridData = [
      GridCardData(
        title: 'Total Students',
        value: '234',
        icon: FontAwesomeIcons.users,
        color: AppColors.primary,
        trend: '+5%',
        trendIcon: FontAwesomeIcons.arrowTrendUp,
        trendColor: AppColors.success,
      ),
      GridCardData(
        title: 'Present Today',
        value: '201',
        icon: FontAwesomeIcons.userCheck,
        color: AppColors.success,
        trend: '+3%',
        trendIcon: FontAwesomeIcons.arrowTrendUp,
        trendColor: AppColors.success,
      ),
      GridCardData(
        title: 'Absent Today',
        value: '33',
        icon: FontAwesomeIcons.userXmark,
        color: AppColors.error,
        trend: '-2%',
        trendIcon: FontAwesomeIcons.arrowTrendDown,
        trendColor: AppColors.error,
      ),
      GridCardData(
        title: 'Attendance Rate',
        value: '86%',
        icon: FontAwesomeIcons.chartLine,
        color: AppColors.warning,
        trend: '+1%',
        trendIcon: FontAwesomeIcons.arrowTrendUp,
        trendColor: AppColors.success,
      ),
    ];

    return CustomGridView(
      data: gridData,
      crossAxisCount: 4, // Desktop: 4 columns
      mobileCrossAxisCount: 1, // Mobile: 1 column for better readability
      tabletCrossAxisCount: 2, // Tablet: 2 columns
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.6, // Desktop aspect ratio
      mobileAspectRatio: 2.0, // Mobile: wider cards for better content display
      tabletAspectRatio: 1.7, // Tablet: wider cards
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cardStyle: CustomGridCardStyle.gradient,
      showAnimation: true,
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Attendance Trend', style: AppTextStyles.heading5),
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient.scale(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartLine,
                      size: 48.0,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.0),
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
      padding: EdgeInsets.all(20.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Attendance', style: AppTextStyles.heading5),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: recentAttendance.length,
              itemBuilder: (context, index) {
                final record = recentAttendance[index];
                final isPresent = record['status'] == 'Present';

                return Container(
                  margin: EdgeInsets.only(bottom: 12.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
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
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? AppColors.success
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              record['status']!,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.doorOpen,
                            size: 10.0,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            record['room']!,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10.0,
                            ),
                          ),
                          if (isPresent) ...[
                            SizedBox(width: 12.0),
                            Icon(
                              FontAwesomeIcons.clock,
                              size: 10.0,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              record['time']!,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10.0,
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
      padding: EdgeInsets.all(24.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        children: [
          // Billing Summary
          _buildBillingSummaryCards(isMobile),

          SizedBox(height: 24.0),

          // Billing Details
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildRevenueChart()),
                if (!isMobile) ...[
                  SizedBox(width: 24.0),
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
    final gridData = [
      GridCardData(
        title: 'Monthly Revenue',
        value: 'Rs2,45,600',
        icon: FontAwesomeIcons.indianRupeeSign,
        color: AppColors.success,
        trend: '+12%',
        trendIcon: FontAwesomeIcons.arrowTrendUp,
        trendColor: AppColors.success,
      ),
      GridCardData(
        title: 'Pending Bills',
        value: 'Rs45,200',
        icon: FontAwesomeIcons.clock,
        color: AppColors.warning,
        trend: '-5%',
        trendIcon: FontAwesomeIcons.arrowTrendDown,
        trendColor: AppColors.error,
      ),
      GridCardData(
        title: 'Overdue Amount',
        value: 'Rs12,300',
        icon: FontAwesomeIcons.exclamation,
        color: AppColors.error,
        trend: '-8%',
        trendIcon: FontAwesomeIcons.arrowTrendDown,
        trendColor: AppColors.success,
      ),
      GridCardData(
        title: 'Collection Rate',
        value: '94%',
        icon: FontAwesomeIcons.percent,
        color: AppColors.info,
        trend: '+3%',
        trendIcon: FontAwesomeIcons.arrowTrendUp,
        trendColor: AppColors.success,
      ),
    ];

    return CustomGridView(
      data: gridData,
      crossAxisCount: 4, // Desktop: 4 columns
      mobileCrossAxisCount: 1, // Mobile: 1 column for better readability
      tabletCrossAxisCount: 2, // Tablet: 2 columns
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.6, // Desktop aspect ratio
      mobileAspectRatio: 2.0, // Mobile: wider cards for better content display
      tabletAspectRatio: 1.7, // Tablet: wider cards
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cardStyle: CustomGridCardStyle.gradient,
      showAnimation: true,
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: EdgeInsets.all(20.0),
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
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.successGradient.scale(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.chartBar,
                        size: 36.0,
                        color: AppColors.success.withOpacity(0.5),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Revenue chart will be displayed here',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
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
      padding: EdgeInsets.all(16.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Payment Status',
            style: AppTextStyles.heading5.copyWith(fontSize: 14.0),
          ),
          SizedBox(height: 12.0),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentData.length,
              itemBuilder: (context, index) {
                final data = paymentData[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: (data['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: data['color'] as Color,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Center(
                          child: Text(
                            '${data['count']}',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          data['status'] as String,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${((data['count'] as int) / 100).toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: data['color'] as Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
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
      padding: EdgeInsets.all(24.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Menu Analytics', style: AppTextStyles.heading5),
          SizedBox(height: 24.0),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.chartPie,
                    size: 64.0,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  SizedBox(height: 24.0),
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
      padding: EdgeInsets.all(24.0),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Reports', style: AppTextStyles.heading5),
          SizedBox(height: 24.0),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.userGraduate,
                    size: 64.0,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  SizedBox(height: 24.0),
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
    ToastMessage.success(
      'Your report is being generated and will be downloaded shortly.',
    );
  }
}
