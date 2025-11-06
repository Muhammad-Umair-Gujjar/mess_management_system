import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(4.r),
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
                height: isSelected
                    ? (tabHeight != null ? tabHeight! + 8.h : 56.h)
                    : (tabHeight ?? 48.h),
                margin: EdgeInsets.all(2.r),
                padding: EdgeInsets.symmetric(
                  horizontal: isScrollable ? 16.w : 8.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor ?? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
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
                            size: isSelected ? 22.sp : 20.sp,
                            color: isSelected
                                ? Colors.white
                                : unselectedColor ?? AppColors.textSecondary,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Flexible(
                          child: Text(
                            tab.label,
                            style: isSelected
                                ? AppTextStyles.body2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.sp,
                                  )
                                : (unselectedTextStyle ??
                                      AppTextStyles.body2.copyWith(
                                        color:
                                            unselectedColor ??
                                            AppColors.textSecondary,
                                        fontSize: 15.sp,
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
      width: tabWidth ?? 200.w,
      padding: padding ?? EdgeInsets.all(4.r),
      child: Column(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 4.h),
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor ?? AppColors.primary
                      : unselectedBackgroundColor ?? Colors.transparent,
                  borderRadius: borderRadius ?? BorderRadius.circular(8.r),
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
                        size: 18.sp,
                        color: isSelected
                            ? selectedColor ?? Colors.white
                            : unselectedColor ?? AppColors.textSecondary,
                      ),
                    ],
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        tab.label,
                        style: isSelected
                            ? AppTextStyles.body2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17.sp,
                              )
                            : AppTextStyles.body2.copyWith(
                                color:
                                    unselectedColor ?? AppColors.textSecondary,
                                fontSize: 15.sp,
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
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
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
                padding: EdgeInsets.symmetric(vertical: 16.h),
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
                        size: 16.sp,
                        color: isSelected
                            ? selectedColor ?? AppColors.primary
                            : unselectedColor ?? AppColors.textSecondary,
                      ),
                      SizedBox(width: 8.w),
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
