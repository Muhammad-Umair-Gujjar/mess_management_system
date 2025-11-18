import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../student_controller.dart';
import 'feedback_card.dart';

class RecentFeedbacks extends StatelessWidget {
  final StudentController controller;

  const RecentFeedbacks({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                        itemBuilder: (context, index) => FeedbackCard(
                          feedback: feedbacks[index],
                          index: index,
                        ),
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
}
