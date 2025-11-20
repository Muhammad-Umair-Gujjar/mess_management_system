import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../core/utils/toast_message.dart';
import '../../../student_controller.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
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
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  style: AppTextStyles.body2.copyWith(
                                    // Changed from caption to body2
                                    color: isSelected
                                        ? emojiData['color']
                                        : AppColors.textLight,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          mobile: 16, // Larger text on mobile
                                          tablet: 15,
                                          desktop: 14,
                                        ),
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
                onPressed: isSubmitting ? null : () => _submitFeedback(),
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

  Future<void> _submitFeedback() async {
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
