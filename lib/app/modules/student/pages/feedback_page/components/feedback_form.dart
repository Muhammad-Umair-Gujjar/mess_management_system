import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'medium')),
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
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getSpacing(context, 'large'),
                    ),
                  ),
                  child: Icon(
                    FontAwesomeIcons.comment,
                    size: ResponsiveHelper.getIconSize(context, 'small'),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share Your Feedback',
                        style: AppTextStyles.heading5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height:
                            ResponsiveHelper.getSpacing(context, 'xs') * 0.5,
                      ),
                      Text(
                        'Help us improve our services',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textLight,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

            // Rating Selection
            Text(
              'Rate Your Experience',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                              padding: EdgeInsets.all(
                                ResponsiveHelper.getSpacing(context, 'small'),
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? emojiData['color'].withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getSpacing(
                                    context,
                                    'medium',
                                  ),
                                ),
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
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.getResponsiveFontSize(
                                            context,
                                            mobile: 16,
                                            tablet: 22,
                                            desktop: 16,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveHelper.getSpacing(
                                      context,
                                      'small',
                                    ),
                                  ),
                                  Text(
                                    emojiData['label'],
                                    style: AppTextStyles.caption.copyWith(
                                      color: isSelected
                                          ? emojiData['color']
                                          : AppColors.textLight,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      fontSize:
                                          ResponsiveHelper.getResponsiveFontSize(
                                            context,
                                            mobile: 14,
                                            tablet: 20,
                                            desktop: 12,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate(delay: Duration(milliseconds: 100))
                            .fadeIn(duration: 300.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                  );
                }),
              ),
            ),

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Category Selection
            Text(
              'Feedback Category',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, 'large'),
                vertical: ResponsiveHelper.getSpacing(context, 'small'),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getSpacing(context, 'large'),
                ),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  style: AppTextStyles.body2,
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

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Message Input
            Text(
              'Your Message',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),

            TextFormField(
              controller: _messageController,
              maxLines: 5,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                hintText: 'Share your thoughts and suggestions...',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'large'),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'large'),
                  ),
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

            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xlarge')),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.getSpacing(context, 'medium'),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getSpacing(context, 'large'),
                    ),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: ResponsiveHelper.getSpacing(
                              context,
                              'large',
                            ),
                            height: ResponsiveHelper.getSpacing(
                              context,
                              'large',
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getSpacing(
                              context,
                              'small',
                            ),
                          ),
                          Text(
                            'Submitting...',
                            style: AppTextStyles.subtitle2.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.paperPlane,
                            size: ResponsiveHelper.getIconSize(
                              context,
                              'small',
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getSpacing(
                              context,
                              'small',
                            ),
                          ),
                          Text(
                            'Submit Feedback',
                            style: AppTextStyles.subtitle2.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, 'medium'),
            ), // Add bottom padding to prevent overflow
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3);
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
