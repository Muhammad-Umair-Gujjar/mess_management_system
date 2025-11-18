import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> feedback;
  final int index;

  const FeedbackCard({super.key, required this.feedback, required this.index});

  final List<Map<String, dynamic>> ratingEmojis = const [
    {'emoji': '😠', 'label': 'Very Poor', 'color': Color(0xFFEF4444)},
    {'emoji': '😞', 'label': 'Poor', 'color': Color(0xFFF97316)},
    {'emoji': '😐', 'label': 'Average', 'color': Color(0xFFF59E0B)},
    {'emoji': '😊', 'label': 'Good', 'color': Color(0xFF10B981)},
    {'emoji': '😍', 'label': 'Excellent', 'color': Color(0xFF059669)},
  ];

  @override
  Widget build(BuildContext context) {
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
}
