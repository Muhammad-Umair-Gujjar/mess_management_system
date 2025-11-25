import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

class CustomTabBarItem {
  final String label;
  final IconData? icon;
  final Widget? customWidget;

  CustomTabBarItem({required this.label, this.icon, this.customWidget});
}

class CustomTabBar extends StatelessWidget {
  final List<CustomTabBarItem> tabs;
  final int selectedIndex;
  final Function(int) onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final bool showIcons;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final double? tabHeight;
  final BorderRadius? borderRadius;
  final bool showIndicator;
  final Color? indicatorColor;
  final double? indicatorHeight;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final String? selectedIconSize;
  final String? unselectedIconSize;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.showIcons = true,
    this.isScrollable = false,
    this.padding,
    this.tabHeight,
    this.borderRadius,
    this.showIndicator = true,
    this.indicatorColor,
    this.indicatorHeight,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedIconSize,
    this.unselectedIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xs') / 2),
      child: Row(
        mainAxisSize: isScrollable ? MainAxisSize.min : MainAxisSize.max,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];

          return Expanded(
            flex: isScrollable ? 0 : 1,
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: tabHeight ?? 56.0,
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, 'xs') / 4,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                  vertical: ResponsiveHelper.getSpacing(context, 'small'),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor ?? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getSpacing(context, 'small'),
                  ),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            (selectedBackgroundColor ?? AppColors.primary),
                            (selectedBackgroundColor ?? AppColors.primary)
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                (selectedBackgroundColor ?? AppColors.primary)
                                    .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child:
                    tab.customWidget ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showIcons && tab.icon != null) ...[
                          Icon(
                            tab.icon,
                            size: isSelected
                                ? ResponsiveHelper.getIconSize(
                                    context,
                                    selectedIconSize ?? 'small',
                                  )
                                : ResponsiveHelper.getIconSize(
                                    context,
                                    unselectedIconSize ?? 'small',
                                  ),
                            color: isSelected
                                ? Colors.white
                                : unselectedColor ?? AppColors.textSecondary,
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getSpacing(
                              context,
                              'small',
                            ),
                          ),
                        ],
                        Flexible(
                          child: Text(
                            tab.label,
                            style: isSelected
                                ? AppTextStyles.body2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  )
                                : (unselectedTextStyle ??
                                      AppTextStyles.body2.copyWith(
                                        color:
                                            unselectedColor ??
                                            AppColors.textSecondary,
                                      )),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Alternative vertical tab bar
class CustomVerticalTabBar extends StatelessWidget {
  final List<CustomTabBarItem> tabs;
  final int selectedIndex;
  final Function(int) onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final bool showIcons;
  final EdgeInsetsGeometry? padding;
  final double? tabWidth;
  final BorderRadius? borderRadius;

  const CustomVerticalTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.showIcons = true,
    this.padding,
    this.tabWidth,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tabWidth ?? ResponsiveHelper.getSpacing(context, 'xlarge') * 5,
      padding:
          padding ?? EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'xs')),
      child: Column(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: ResponsiveHelper.getSpacing(context, 'xs'),
            ),
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
                  vertical: ResponsiveHelper.getSpacing(context, 'small'),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor ?? AppColors.primary
                      : unselectedBackgroundColor ?? Colors.transparent,
                  borderRadius:
                      borderRadius ??
                      BorderRadius.circular(
                        ResponsiveHelper.getSpacing(context, 'small'),
                      ),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            (selectedBackgroundColor ?? AppColors.primary),
                            (selectedBackgroundColor ?? AppColors.primary)
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    if (showIcons && tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: ResponsiveHelper.getIconSize(context, 'small'),
                        color: isSelected
                            ? selectedColor ?? Colors.white
                            : unselectedColor ?? AppColors.textSecondary,
                      ),
                    ],
                    SizedBox(
                      width: ResponsiveHelper.getSpacing(context, 'small'),
                    ),
                    Flexible(
                      child: Text(
                        tab.label,
                        style: isSelected
                            ? AppTextStyles.body2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              )
                            : AppTextStyles.body2.copyWith(
                                color:
                                    unselectedColor ?? AppColors.textSecondary,
                              ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Tab bar with underline indicator (like traditional TabBar)
class CustomUnderlineTabBar extends StatelessWidget {
  final List<CustomTabBarItem> tabs;
  final int selectedIndex;
  final Function(int) onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double? indicatorHeight;
  final EdgeInsetsGeometry? padding;
  final bool showIcons;

  const CustomUnderlineTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.padding,
    this.showIcons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, 'medium'),
          ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textLight.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getSpacing(context, 'medium'),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? indicatorColor ?? AppColors.primary
                          : Colors.transparent,
                      width: indicatorHeight ?? 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showIcons && tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: ResponsiveHelper.getIconSize(context, 'small'),
                        color: isSelected
                            ? selectedColor ?? AppColors.primary
                            : unselectedColor ?? AppColors.textSecondary,
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(context, 'small'),
                      ),
                    ],
                    Flexible(
                      child: Text(
                        tab.label,
                        style: AppTextStyles.body2.copyWith(
                          color: isSelected
                              ? selectedColor ?? AppColors.primary
                              : unselectedColor ?? AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}




