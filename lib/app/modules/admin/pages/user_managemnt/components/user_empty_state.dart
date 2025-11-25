import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive_helper.dart';

class UserEmptyState extends StatelessWidget {
  const UserEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.users,
            size: ResponsiveHelper.getIconSize(context, 'large'),
            color: AppColors.textLight.withOpacity(0.5),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          Text(
            'No users found',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            'Try adjusting your search criteria',
            style: AppTextStyles.body2.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}




