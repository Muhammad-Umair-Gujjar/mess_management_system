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
    this.childAspectRatio = 1.0,
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

    if (isMobile && mobileCrossAxisCount != null) {
      currentCrossAxisCount = mobileCrossAxisCount!;
      currentAspectRatio = mobileAspectRatio ?? childAspectRatio;
    } else if (isTablet && tabletCrossAxisCount != null) {
      currentCrossAxisCount = tabletCrossAxisCount!;
      currentAspectRatio = tabletAspectRatio ?? childAspectRatio;
    }

    return Container(
      padding: padding,
      child: GridView.builder(
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
      ),
    );
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
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: item.color.withOpacity(0.3), width: 2),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildGradientCard(GridCardData item, int index) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
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
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: item.color.withOpacity(0.2), width: 1),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildMinimalCard(GridCardData item, int index) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: _buildCardContent(item),
      ),
    );
  }

  Widget _buildGlassmorphismCard(GridCardData item, int index) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Header with icon and trend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(item.icon, size: 16.sp, color: item.color),
            ),
            if (item.trend != null || item.trendIcon != null)
              Row(
                children: [
                  if (item.trendIcon != null)
                    Icon(
                      item.trendIcon,
                      size: 12.sp,
                      color: item.trendColor ?? AppColors.success,
                    ),
                  if (item.trend != null) ...[
                    if (item.trendIcon != null) SizedBox(width: 2.w),
                    Text(
                      item.trend!,
                      style: AppTextStyles.caption.copyWith(
                        color: item.trendColor ?? AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),

        SizedBox(height: 12.h),

        // Value
        Flexible(
          child: Text(
            item.value,
            style: AppTextStyles.heading4.copyWith(
              color: item.color,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),

        SizedBox(height: 4.h),

        // Title and subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                item.title,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (item.subtitle != null) ...[
              SizedBox(height: 2.h),
              Flexible(
                child: Text(
                  item.subtitle!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
