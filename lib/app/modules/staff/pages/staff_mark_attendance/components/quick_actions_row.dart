import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? _buildMobileLayout(context)
        : _buildDesktopLayout(context);
  }

  /// Mobile layout - compact buttons with smaller text
  Widget _buildMobileLayout(BuildContext context) {
    return Row(
    
      children: [
        ReusableButton(
          text: 'Mark All Present',
          icon: FontAwesomeIcons.check,
          type: ButtonType.success,
          size: ButtonSize.small,
          onPressed: onMarkAllPresent,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
        ReusableButton(
          text: 'Mark All Absent',
          icon: FontAwesomeIcons.xmark,
          type: ButtonType.danger,
          size: ButtonSize.small,
          onPressed: onMarkAllAbsent,
        ),
      ],
    );
  }

  /// Desktop layout - original horizontal layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        ReusableButton(
          text: 'Mark All Present',
          icon: FontAwesomeIcons.check,
          type: ButtonType.success,
          size: ButtonSize.medium,
          onPressed: onMarkAllPresent,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
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




