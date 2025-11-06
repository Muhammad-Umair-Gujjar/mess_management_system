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
import '../../../../core/utils/toast_message.dart';
import '../student_controller.dart';

class StudentFeedbackPage extends StatefulWidget {
  const StudentFeedbackPage({super.key});

  @override
  State<StudentFeedbackPage> createState() => _StudentFeedbackPageState();
}

class _StudentFeedbackPageState extends State<StudentFeedbackPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedRating = 5;
  String selectedCategory = 'Food Quality';
  bool isSubmitting = false;

  final List<String> categories = [
    'Food Quality',
    'Service',
    'Cleanliness',
    'Staff Behavior',
    'Facilities',
    'Other',
  ];

  final List<Map<String, dynamic>> ratingEmojis = [
    {'emoji': '😠', 'label': 'Very Poor', 'color': Color(0xFFEF4444)},
    {'emoji': '😞', 'label': 'Poor', 'color': Color(0xFFF97316)},
    {'emoji': '😐', 'label': 'Average', 'color': Color(0xFFF59E0B)},
    {'emoji': '😊', 'label': 'Good', 'color': Color(0xFF10B981)},
    {'emoji': '😍', 'label': 'Excellent', 'color': Color(0xFF059669)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: _buildMobileLayout(controller),
        desktop: _buildDesktopLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFeedbackForm(controller),
                SizedBox(height: 24.h),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: _buildRecentFeedbacks(controller),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(child: _buildFeedbackForm(controller)),
          ),
          SizedBox(width: 24.w),
          Expanded(flex: 3, child: _buildRecentFeedbacks(controller)),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: AppDecorations.floatingCard(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.comment,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Your Feedback',
                      style: AppTextStyles.heading5.copyWith(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 20,
                          tablet: 22,
                          desktop: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Help us improve our services',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Rating Selection
            Text(
              'Rate Your Experience',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final rating = index + 1;
                final emojiData = ratingEmojis[index];
                final isSelected = selectedRating == rating;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                  child:
                      Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? emojiData['color'].withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? emojiData['color']
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  emojiData['emoji'],
                                  style: TextStyle(fontSize: 32.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  emojiData['label'],
                                  style: AppTextStyles.caption.copyWith(
                                    color: isSelected
                                        ? emojiData['color']
                                        : AppColors.textLight,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate(delay: Duration(milliseconds: index * 100))
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                );
              }),
            ),

            SizedBox(height: 32.h),

            // Category Selection
            Text(
              'Feedback Category',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  style: AppTextStyles.body1,
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Message Input
            Text(
              'Your Message',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            TextFormField(
              controller: _messageController,
              maxLines: 5,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                hintText: 'Share your thoughts and suggestions...',
                hintStyle: AppTextStyles.body1.copyWith(
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your feedback message';
                }
                if (value.trim().length < 10) {
                  return 'Message should be at least 10 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () => _submitFeedback(controller),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Submitting...',
                            style: AppTextStyles.subtitle1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.paperPlane, size: 16.sp),
                          SizedBox(width: 12.w),
                          Text(
                            'Submit Feedback',
                            style: AppTextStyles.subtitle1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 20.h), // Add bottom padding to prevent overflow
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3);
  }

  Widget _buildRecentFeedbacks(StudentController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: AppDecorations.floatingCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Recent Feedbacks', style: AppTextStyles.heading5),
                  SizedBox(height: 4.h),
                  Text(
                    'Track your previous submissions',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              Icon(
                FontAwesomeIcons.history,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Feedback List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Create some dummy feedback data for demonstration
                  Builder(
                    builder: (context) {
                      final feedbacks = _getDummyFeedbacks();

                      if (feedbacks.isEmpty) {
                        return _buildEmptyFeedbackState();
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feedbacks.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) =>
                            _buildFeedbackCard(feedbacks[index], index),
                      );
                    },
                  ),
                  SizedBox(height: 20.h), // Add bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideX(begin: 0.3);
  }

  Widget _buildEmptyFeedbackState() {
    return Container(
      padding: EdgeInsets.all(40.r),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.commentSlash,
            size: 48.sp,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Feedback Yet',
            style: AppTextStyles.subtitle1.copyWith(color: AppColors.textLight),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your submitted feedbacks will appear here.',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback, int index) {
    final rating = feedback['rating'] as int;
    final ratingData = ratingEmojis[rating - 1];

    return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: ratingData['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      ratingData['emoji'],
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedback['category'],
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy').format(feedback['date']),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        feedback['status'],
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      feedback['status'],
                      style: AppTextStyles.caption.copyWith(
                        color: _getStatusColor(feedback['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Text(
                feedback['message'],
                style: AppTextStyles.body2.copyWith(height: 1.4),
              ),

              if (feedback['response'] != null) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.reply,
                            size: 12.sp,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Admin Response',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        feedback['response'],
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.2);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'reviewed':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  List<Map<String, dynamic>> _getDummyFeedbacks() {
    return [
      {
        'category': 'Food Quality',
        'rating': 4,
        'message':
            'The food quality has improved significantly. The dal rice was delicious yesterday!',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'Resolved',
        'response':
            'Thank you for your positive feedback! We\'re glad you enjoyed the meal.',
      },
      {
        'category': 'Service',
        'rating': 3,
        'message':
            'The serving time could be better. Sometimes we have to wait too long during dinner.',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'Reviewed',
        'response': null,
      },
      {
        'category': 'Cleanliness',
        'rating': 5,
        'message':
            'The dining hall is very clean and well-maintained. Great job!',
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'status': 'Resolved',
        'response':
            'We appreciate your recognition of our cleaning staff\'s efforts!',
      },
    ];
  }

  Future<void> _submitFeedback(StudentController controller) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Show success message
    ToastMessage.success('Thank you for your feedback! We\'ll review it soon.');

    // Clear form
    _messageController.clear();
    setState(() {
      selectedRating = 5;
      selectedCategory = 'Food Quality';
      isSubmitting = false;
    });
  }
}
