import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../staff_controller.dart';

class QuickActionsRow extends StatelessWidget {
  final StaffController controller;
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkAllAbsent;

  const QuickActionsRow({
    super.key,
    required this.controller,
    required this.onMarkAllPresent,
    required this.onMarkAllAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReusableButton(
          text: 'Mark All Present',
          icon: FontAwesomeIcons.check,
          type: ButtonType.success,
          size: ButtonSize.medium,
          onPressed: onMarkAllPresent,
        ),
        SizedBox(width: 12.w),
        ReusableButton(
          text: 'Mark All Absent',
          icon: FontAwesomeIcons.xmark,
          type: ButtonType.danger,
          size: ButtonSize.medium,
          onPressed: onMarkAllAbsent,
        ),
      ],
    );
  }
}
