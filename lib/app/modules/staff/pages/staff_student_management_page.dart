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
import '../../../widgets/common/reusable_text_field.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../staff_controller.dart';

class StaffStudentManagementPage extends StatefulWidget {
  const StaffStudentManagementPage({super.key});

  @override
  State<StaffStudentManagementPage> createState() =>
      _StaffStudentManagementPageState();
}

class _StaffStudentManagementPageState extends State<StaffStudentManagementPage>
    with TickerProviderStateMixin {
  int selectedTabIndex = 0;
  late AnimationController _listAnimationController;

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
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
          // Tab Selector
          _buildTabSelector(),

          SizedBox(height: 24.h),

          // Main Content
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                _buildActiveStudentsTab(controller, isMobile),
                _buildPendingApprovalsTab(controller, isMobile),
                _buildStudentStatsTab(controller, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: AppDecorations.floatingCard(),
      child: CustomTabBar(
        selectedIndex: selectedTabIndex,
        onTap: (index) {
          setState(() {
            selectedTabIndex = index;
          });
        },
        tabs: [
          CustomTabBarItem(
            label: 'Active Students',
            icon: FontAwesomeIcons.users,
          ),
          CustomTabBarItem(
            label: 'Pending Approvals',
            icon: FontAwesomeIcons.clock,
          ),
          CustomTabBarItem(
            label: 'Statistics',
            icon: FontAwesomeIcons.chartBar,
          ),
        ],
        selectedColor: Colors.white,
        unselectedColor: AppColors.textSecondary,
        selectedBackgroundColor: AppColors.success,
        unselectedBackgroundColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        selectedTextStyle: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedTextStyle: AppTextStyles.body2,
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildActiveStudentsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with search
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Students', style: AppTextStyles.heading5),
                  Obx(
                    () => Text(
                      '${controller.filteredStudents.length} students enrolled',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: isMobile ? 200.w : 300.w,
                child: ReusableTextField(
                  hintText: 'Search students...',
                  type: TextFieldType.search,
                  onChanged: controller.filterStudents,
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Students Grid/List
          Expanded(
            child: Obx(() {
              final students = controller.filteredStudents;

              if (students.isEmpty) {
                return _buildEmptyState('No active students found');
              }

              return isMobile
                  ? _buildStudentsList(students, controller)
                  : _buildStudentsGrid(students, controller);
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3);
  }

  Widget _buildStudentsGrid(
    List<dynamic> students,
    StaffController controller,
  ) {
    return GridView.builder(
      padding: EdgeInsets.all(8.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context)
            ? 1
            : ResponsiveHelper.isTablet(context)
            ? 2
            : 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.4,
      ),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentCard(student, index, controller);
      },
    );
  }

  Widget _buildStudentsList(
    List<dynamic> students,
    StaffController controller,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(8.r),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: _buildStudentListTile(student, index, controller),
        );
      },
    );
  }

  Widget _buildStudentCard(
    dynamic student,
    int index,
    StaffController controller,
  ) {
    return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: AppShadows.light,
            border: Border.all(color: AppColors.staffRole.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.staffRole.withOpacity(0.1),
                    child: Text(
                      student['name'].substring(0, 1).toUpperCase(),
                      style: AppTextStyles.heading5.copyWith(
                        color: AppColors.staffRole,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: ${student['id']}',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.doorOpen,
                    size: 14.sp,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Room: ${student['room']}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.envelope,
                    size: 14.sp,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      student['email'],
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: ReusableButton(
                      text: 'View Details',
                      type: ButtonType.outline,
                      size: ButtonSize.small,
                      onPressed: () => _showStudentDetails(student),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      FontAwesomeIcons.check,
                      size: 12.sp,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildStudentListTile(
    dynamic student,
    int index,
    StaffController controller,
  ) {
    return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.light,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.staffRole.withOpacity(0.1),
                child: Text(
                  student['name'].substring(0, 1).toUpperCase(),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.staffRole,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${student['id']} • Room: ${student['room']}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              ReusableButton(
                text: 'Details',
                type: ButtonType.ghost,
                size: ButtonSize.small,
                onPressed: () => _showStudentDetails(student),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildPendingApprovalsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Pending Approvals', style: AppTextStyles.heading5),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clock,
                      size: 12.sp,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: 6.w),
                    Obx(
                      () => Text(
                        '${controller.getPendingApprovals().length} pending',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          Expanded(
            child: Obx(() {
              final pendingStudents = controller.getPendingApprovals();

              if (pendingStudents.isEmpty) {
                return _buildEmptyState('No pending approvals');
              }

              return ListView.builder(
                itemCount: pendingStudents.length,
                itemBuilder: (context, index) {
                  final student = pendingStudents[index];
                  return _buildPendingApprovalCard(student, index, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalCard(
    dynamic student,
    int index,
    StaffController controller,
  ) {
    return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            boxShadow: AppShadows.light,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.warning.withOpacity(0.1),
                    child: Text(
                      student['name']?.substring(0, 1).toUpperCase() ?? 'S',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'] ?? 'Unknown Student',
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Registration Date: ${DateFormat('MMM d, yyyy').format(DateTime.now().subtract(Duration(days: index + 1)))}',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Pending',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: ReusableButton(
                      text: 'Approve',
                      icon: FontAwesomeIcons.check,
                      type: ButtonType.success,
                      size: ButtonSize.medium,
                      onPressed: () => _approveStudent(student, controller),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ReusableButton(
                      text: 'Reject',
                      icon: FontAwesomeIcons.xmark,
                      type: ButtonType.danger,
                      size: ButtonSize.medium,
                      onPressed: () => _rejectStudent(student, controller),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildStudentStatsTab(StaffController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Statistics', style: AppTextStyles.heading5),

          SizedBox(height: 24.h),

          // Stats Cards
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              _buildStatCard(
                'Total Students',
                '${controller.allStudents.length}',
                FontAwesomeIcons.users,
                AppColors.primary,
                0,
              ),
              _buildStatCard(
                'Active Students',
                '${controller.allStudents.where((s) => s['isApproved'] == true).length}',
                FontAwesomeIcons.userCheck,
                AppColors.success,
                200,
              ),
              _buildStatCard(
                'Pending Approval',
                '${controller.getPendingApprovals().length}',
                FontAwesomeIcons.clock,
                AppColors.warning,
                400,
              ),
              _buildStatCard(
                'This Month',
                '${(controller.allStudents.length * 0.15).round()}',
                FontAwesomeIcons.userPlus,
                AppColors.info,
                600,
              ),
            ],
          ),

          SizedBox(height: 32.h),

          Text('Recent Activities', style: AppTextStyles.heading5),

          SizedBox(height: 16.h),

          Expanded(child: _buildRecentActivitiesList()),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
          width: ResponsiveHelper.isMobile(context) ? double.infinity : 200.w,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, size: 24.sp, color: Colors.white),
              ),

              SizedBox(height: 12.h),

              Text(
                value,
                style: AppTextStyles.heading4.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildRecentActivitiesList() {
    final activities = [
      {
        'action': 'Student Approved',
        'student': 'Ali Ahmed',
        'time': '2 hours ago',
      },
      {
        'action': 'New Registration',
        'student': 'Sara Khan',
        'time': '4 hours ago',
      },
      {
        'action': 'Student Rejected',
        'student': 'Ahmed Hassan',
        'time': '1 day ago',
      },
      {
        'action': 'Profile Updated',
        'student': 'Fatima Ali',
        'time': '2 days ago',
      },
    ];

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: _getActivityColor(
                        activity['action']!,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _getActivityIcon(activity['action']!),
                      size: 16.sp,
                      color: _getActivityColor(activity['action']!),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['action']!,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          activity['student']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    activity['time']!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            )
            .animate(delay: Duration(milliseconds: 100 * index))
            .fadeIn(duration: 600.ms)
            .slideX(begin: 0.3);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.users, size: 64.sp, color: AppColors.textLight),
          SizedBox(height: 24.h),
          Text(
            message,
            style: AppTextStyles.heading5.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String action) {
    switch (action.toLowerCase()) {
      case 'student approved':
        return AppColors.success;
      case 'student rejected':
        return AppColors.error;
      case 'new registration':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action.toLowerCase()) {
      case 'student approved':
        return FontAwesomeIcons.check;
      case 'student rejected':
        return FontAwesomeIcons.xmark;
      case 'new registration':
        return FontAwesomeIcons.userPlus;
      default:
        return FontAwesomeIcons.pencil;
    }
  }

  void _showStudentDetails(dynamic student) {
    Get.dialog(
      AlertDialog(
        title: Text('Student Details', style: AppTextStyles.heading5),
        content: Container(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${student['name']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
              Text('ID: ${student['id']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
              Text('Room: ${student['room']}', style: AppTextStyles.body1),
              SizedBox(height: 8.h),
              Text('Email: ${student['email']}', style: AppTextStyles.body1),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  void _approveStudent(dynamic student, StaffController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Approve Student', style: AppTextStyles.heading5),
        content: Text('Are you sure you want to approve ${student['name']}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Approve',
            type: ButtonType.success,
            size: ButtonSize.small,
            onPressed: () {
              // controller.approveStudent(student['id']);
              Get.back();
              _showSuccessSnackbar('Student approved successfully');
            },
          ),
        ],
      ),
    );
  }

  void _rejectStudent(dynamic student, StaffController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Reject Student', style: AppTextStyles.heading5),
        content: Text('Are you sure you want to reject ${student['name']}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ReusableButton(
            text: 'Reject',
            type: ButtonType.danger,
            size: ButtonSize.small,
            onPressed: () {
              // controller.rejectStudent(student['id']);
              Get.back();
              _showSuccessSnackbar('Student rejected');
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success.withOpacity(0.1),
      colorText: AppColors.success,
      icon: Icon(FontAwesomeIcons.check, color: AppColors.success),
      duration: const Duration(seconds: 3),
    );
  }
}
