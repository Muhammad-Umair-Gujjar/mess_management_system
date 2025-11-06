import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mess_management/core/constants/app_colors.dart';
import 'package:mess_management/core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

class GridCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? trend;
  final IconData? trendIcon;
  final Color? trendColor;
  final VoidCallback? onTap;
  final Widget? customContent;
  final LinearGradient? gradient;
  final List<Color>? backgroundColors;

  GridCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
    this.trendIcon,
    this.trendColor,
    this.onTap,
    this.customContent,
    this.gradient,
    this.backgroundColors,
  });
}

class CustomGridView extends StatelessWidget {
  final List<GridCardData> data;
  final int crossAxisCount;
  final int? mobileCrossAxisCount;
  final int? tabletCrossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final double? mobileAspectRatio;
  final double? tabletAspectRatio;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool showAnimation;
  final Duration animationDelay;
  final CustomGridCardStyle cardStyle;

  const CustomGridView({
    Key? key,
    required this.data,
    this.crossAxisCount = 2,
    this.mobileCrossAxisCount,
    this.tabletCrossAxisCount,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.childAspectRatio = 1.2,
    this.mobileAspectRatio,
    this.tabletAspectRatio,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.showAnimation = true,
    this.animationDelay = const Duration(milliseconds: 100),
    this.cardStyle = CustomGridCardStyle.elevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    int currentCrossAxisCount = crossAxisCount;
    double currentAspectRatio = childAspectRatio;

    // Always use 2 columns for mobile, 3 for tablet, ignoring overrides
    if (isMobile) {
      currentCrossAxisCount = 2;
      currentAspectRatio = mobileAspectRatio ?? childAspectRatio;
    } else if (isTablet) {
      currentCrossAxisCount = 3;
      currentAspectRatio = tabletAspectRatio ?? childAspectRatio;
    }

    Widget gridView = GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: currentCrossAxisCount,
        crossAxisSpacing: crossAxisSpacing.w,
        mainAxisSpacing: mainAxisSpacing.h,
        childAspectRatio: currentAspectRatio,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildGridCard(item, index);
      },
    );

    if (padding != null) {
      return Padding(padding: padding!, child: gridView);
    }

    return gridView;
  }

  Widget _buildGridCard(GridCardData item, int index) {
    Widget card;

    switch (cardStyle) {
      case CustomGridCardStyle.elevated:
        card = _buildElevatedCard(item, index);
        break;
      case CustomGridCardStyle.outlined:
        card = _buildOutlinedCard(item, index);
        break;
      case CustomGridCardStyle.gradient:
        card = _buildGradientCard(item, index);
        break;
      case CustomGridCardStyle.minimal:
        card = _buildMinimalCard(item, index);
        break;
      case CustomGridCardStyle.glassmorphism:
        card = _buildGlassmorphismCard(item, index);
        break;
    }

    if (showAnimation) {
      card = card
          .animate(
            delay: Duration(
              milliseconds: animationDelay.inMilliseconds * index,
            ),
          )
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.8, 0.8));
    }

    return card;
  }

  Widget _buildElevatedCard(GridCardData item, int index) {
    // Responsive padding for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double cardPadding = isMobile ? 24.r : 18.r;
    final double borderRadius = isMobile ? 20.r : 16.r;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: item.color.withOpacity(0.1), width: 1),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildOutlinedCard(GridCardData item, int index) {
    // Responsive padding for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double cardPadding = isMobile ? 24.r : 18.r;
    final double borderRadius = isMobile ? 20.r : 16.r;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: item.color.withOpacity(0.3), width: 2),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildGradientCard(GridCardData item, int index) {
    // Responsive padding for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double cardPadding = isMobile ? 24.r : 18.r;
    final double borderRadius = isMobile ? 20.r : 16.r;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          gradient:
              item.gradient ??
              LinearGradient(
                colors:
                    item.backgroundColors ??
                    [item.color.withOpacity(0.1), item.color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: item.color.withOpacity(0.2), width: 1),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildMinimalCard(GridCardData item, int index) {
    // Responsive padding for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double cardPadding = isMobile ? 24.r : 18.r;
    final double borderRadius = isMobile ? 16.r : 12.r;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildGlassmorphismCard(GridCardData item, int index) {
    // Responsive padding for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double cardPadding = isMobile ? 24.r : 18.r;
    final double borderRadius = isMobile ? 20.r : 16.r;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildCardContent(GridCardData item) {
    if (item.customContent != null) {
      return item.customContent!;
    }

    // Responsive sizing for mobile devices
    final isMobile = ScreenUtil().screenWidth < 600;
    final double iconPadding = isMobile ? 12.r : 8.r;
    final double iconSize = isMobile ? 32.sp : 25.sp;
    final double iconBorderRadius = isMobile ? 12.r : 8.r;
    final double trendIconSize = isMobile ? 24.sp : 20.sp;
    final double trendFontSize = isMobile ? 18.sp : 16.sp;
    final double valueSpacing = isMobile ? 18.h : 14.h;
    final double valueFontSize = isMobile ? 32.sp : 25.sp;
    final double titleSpacing = isMobile ? 8.h : 6.h;
    final double titleFontSize = isMobile ? 24.sp : 20.sp;
    final double subtitleSpacing = isMobile ? 4.h : 3.h;
    final double subtitleFontSize = isMobile ? 18.sp : 16.sp;
    final double trendSpacing = isMobile ? 4.w : 3.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and trend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(iconBorderRadius),
              ),
              child: Icon(item.icon, size: iconSize, color: item.color),
            ),
            if (item.trend != null || item.trendIcon != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.trendIcon != null)
                    Icon(
                      item.trendIcon,
                      size: trendIconSize,
                      color: item.trendColor ?? AppColors.success,
                    ),
                  if (item.trend != null) ...[
                    if (item.trendIcon != null) SizedBox(width: trendSpacing),
                    Text(
                      item.trend!,
                      style: AppTextStyles.caption.copyWith(
                        color: item.trendColor ?? AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: trendFontSize,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),

        SizedBox(height: valueSpacing),

        // Value
        Text(
          item.value,
          style: AppTextStyles.heading4.copyWith(
            color: item.color,
            fontWeight: FontWeight.bold,
            fontSize: valueFontSize,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),

        SizedBox(height: titleSpacing),

        // Title and subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: titleFontSize,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (item.subtitle != null) ...[
              SizedBox(height: subtitleSpacing),
              Text(
                item.subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: subtitleFontSize,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

enum CustomGridCardStyle {
  elevated,
  outlined,
  gradient,
  minimal,
  glassmorphism,
}

// Alternative: Staggered grid layout
class CustomStaggeredGridView extends StatelessWidget {
  final List<GridCardData> data;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final CustomGridCardStyle cardStyle;

  const CustomStaggeredGridView({
    Key? key,
    required this.data,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.cardStyle = CustomGridCardStyle.elevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(children: _buildRows()),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    for (int i = 0; i < data.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount && i + j < data.length; j++) {
        rowChildren.add(
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: j < crossAxisCount - 1 ? crossAxisSpacing.w : 0,
              ),
              child: CustomGridView(
                data: [data[i + j]],
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                cardStyle: cardStyle,
                showAnimation: false,
              ),
            ),
          ),
        );
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );

      if (i + crossAxisCount < data.length) {
        rows.add(SizedBox(height: mainAxisSpacing.h));
      }
    }
    return rows;
  }
}

// Horizontal scrollable grid
class CustomHorizontalGridView extends StatelessWidget {
  final List<GridCardData> data;
  final double itemWidth;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final CustomGridCardStyle cardStyle;

  const CustomHorizontalGridView({
    Key? key,
    required this.data,
    this.itemWidth = 200.0,
    this.itemHeight = 150.0,
    this.padding,
    this.cardStyle = CustomGridCardStyle.elevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight.h,
      padding: padding,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            width: itemWidth.w,
            margin: EdgeInsets.only(right: 16.w),
            child: CustomGridView(
              data: [data[index]],
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              cardStyle: cardStyle,
            ),
          );
        },
      ),
    );
  }
}
