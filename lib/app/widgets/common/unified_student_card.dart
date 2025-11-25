import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import 'reusable_button.dart';

enum StudentCardType {
  details, // Shows details with "View Details" button
  attendance, // Shows attendance toggle buttons
  simple, // Simple display only
}

class UnifiedStudentCard extends StatelessWidget {
  final dynamic student;
  final int index;
  final StudentCardType type;

  // For details type
  final VoidCallback? onViewDetails;

  // For attendance type
  final bool? isPresent;
  final Function(bool)? onAttendanceChanged;

  // Optional styling
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const UnifiedStudentCard({
    super.key,
    required this.student,
    required this.index,
    required this.type,
    this.onViewDetails,
    this.isPresent,
    this.onAttendanceChanged,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveBorderRadius = ResponsiveHelper.getBorderRadius(
      context,
      type == StudentCardType.details ? 'large' : 'card',
    );

    return Container(
          padding:
              padding ?? ResponsiveHelper.getPadding(context, 'cardPadding'),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
            border: _getBorder(context),
            boxShadow: AppShadows.light,
          ),
          child: _buildCardContent(),
        )
         .animate(delay: Duration(milliseconds: 50)) 
        .fadeIn(duration:  300.ms )
        .slideX(begin: type == StudentCardType.attendance ? 0.3 : 0.0)
        .scale(
          begin: type == StudentCardType.details
              ? const Offset(0.8, 0.8)
              : null,
        );
  }

  Border? _getBorder(BuildContext context) {
    final borderWidth = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 1.5,
      tablet: 2.0,
      desktop: 2.0,
    );

    if (type == StudentCardType.attendance && isPresent != null) {
      final color = isPresent!
          ? AppColors.success.withOpacity(0.5)
          : AppColors.error.withOpacity(0.5);
      return Border.all(color: color, width: borderWidth);
    }

    if (borderColor != null) {
      return Border.all(color: borderColor!.withOpacity(0.1));
    }

    if (type == StudentCardType.details) {
      return Border.all(color: AppColors.staffRole.withOpacity(0.1));
    }

    return null;
  }

  Widget _buildCardContent() {
    if (type == StudentCardType.attendance) {
      return _buildAttendanceLayout();
    } else {
      return _buildDetailsLayout();
    }
  }

  Widget _buildAttendanceLayout() {
    return Row(
      children: [
        _buildStudentAvatar(),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student['name'] ?? '',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'ID: ${student['id']} • Room: ${student['room']}',
                style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ),
        _buildAttendanceToggle(),
      ],
    );
  }

  Widget _buildDetailsLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStudentAvatar(),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] ?? '',
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
        SizedBox(height: 16.0),
        _buildStudentDetails(),
        if (type == StudentCardType.details) ...[
          const Spacer(),
          _buildActionButtons(),
        ],
      ],
    );
  }

  Widget _buildStudentAvatar() {
    final name = student['name'] ?? '';
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return CircleAvatar(
      radius: type == StudentCardType.details ? 24.0 : 24.0,
      backgroundColor: AppColors.staffRole.withOpacity(0.1),
      child: Text(
        initial,
        style:
            (type == StudentCardType.details
                    ? AppTextStyles.heading5
                    : AppTextStyles.body1)
                .copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.staffRole,
                ),
      ),
    );
  }

  Widget _buildStudentDetails() {
    return Column(
      children: [
        if (type == StudentCardType.details && student['room'] != null) ...[
          Row(
            children: [
              Icon(
                FontAwesomeIcons.doorOpen,
                size: 14.0,
                color: AppColors.textLight,
              ),
              SizedBox(width: 8.0),
              Text(
                'Room: ${student['room']}',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
        if (type == StudentCardType.details && student['email'] != null) ...[
          Row(
            children: [
              Icon(
                FontAwesomeIcons.envelope,
                size: 14.0,
                color: AppColors.textLight,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  student['email'] ?? '',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ReusableButton(
            text: 'View Details',
            type: ButtonType.outline,
            size: ButtonSize.small,
            onPressed: onViewDetails,
          ),
        ),
        SizedBox(width: 8.0),
        Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Icon(
            FontAwesomeIcons.check,
            size: 12.0,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceToggle() {
    return Row(
      children: [
        // Status Indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: isPresent == null
                ? AppColors.textLight.withOpacity(0.1)
                : isPresent!
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            isPresent == null
                ? 'Not Marked'
                : isPresent!
                ? 'Present'
                : 'Absent',
            style: AppTextStyles.caption.copyWith(
              color: isPresent == null
                  ? AppColors.textLight
                  : isPresent!
                  ? AppColors.success
                  : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(width: 12.0),

        // Toggle Buttons
        Row(
          children: [
            GestureDetector(
              onTap: () => onAttendanceChanged?.call(true),
              child: AnimatedContainer(
                duration: const  Duration(milliseconds: 300) ,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isPresent == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 16.0,
                  color: isPresent == true ? Colors.white : AppColors.success,
                ),
              ),
            ),

            SizedBox(width: 8.0),

            GestureDetector(
              onTap: () => onAttendanceChanged?.call(false),
              child: AnimatedContainer(
                duration: const  Duration(milliseconds: 300) ,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isPresent == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  size: 16.0,
                  color: isPresent == false ? Colors.white : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}




