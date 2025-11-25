import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../student_controller.dart';
import 'feedback_card.dart';

class RecentFeedbacks extends StatelessWidget {
  final StudentController controller;

  const RecentFeedbacks({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
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
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'small') * 0.5,
                  ),
                  Text(
                    'Track your previous submissions',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              if (ResponsiveHelper.isDesktop(context))
                Icon(
                  FontAwesomeIcons.history,
                  color: AppColors.primary,
                  size: ResponsiveHelper.getIconSize(context, 'medium'),
                ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

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
                        separatorBuilder: (context, index) => SizedBox(
                          height: ResponsiveHelper.getSpacing(
                            context,
                            'medium',
                          ),
                        ),
                        itemBuilder: (context, index) => FeedbackCard(
                          feedback: feedbacks[index],
                          index: index,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, 'medium'),
                  ), // Add bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideX(begin: 0.3);
  }

  Widget _buildEmptyFeedbackState() {
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xlarge')),
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.inbox,
              size: ResponsiveHelper.getIconSize(context, 'xlarge'),
              color: AppColors.textLight,
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
            Text(
              'No feedbacks yet',
              style: AppTextStyles.heading5.copyWith(
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
            Text(
              'Your submitted feedbacks will appear here.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
