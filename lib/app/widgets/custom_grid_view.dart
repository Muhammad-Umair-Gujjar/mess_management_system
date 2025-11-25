import 'package:flutter/material.dart';
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
    this.animationDelay = const Duration(milliseconds: 300),
    this.cardStyle = CustomGridCardStyle.elevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    int currentCrossAxisCount = crossAxisCount;
    double currentAspectRatio = childAspectRatio;

    // Use responsive cross axis counts with proper fallbacks
    if (isMobile) {
      currentCrossAxisCount = mobileCrossAxisCount ?? 2;
      currentAspectRatio = mobileAspectRatio ?? childAspectRatio;
    } else if (isTablet) {
      currentCrossAxisCount = tabletCrossAxisCount ?? 3;
      currentAspectRatio = tabletAspectRatio ?? childAspectRatio;
    }

    Widget gridView = GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: currentCrossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: currentAspectRatio,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildGridCard(context, item, index);
      },
    );

    if (padding != null) {
      return Padding(padding: padding!, child: gridView);
    }

    return gridView;
  }

  Widget _buildGridCard(BuildContext context, GridCardData item, int index) {
    Widget card;

    switch (cardStyle) {
      case CustomGridCardStyle.elevated:
        card = _buildElevatedCard(context, item, index);
        break;
      case CustomGridCardStyle.outlined:
        card = _buildOutlinedCard(context, item, index);
        break;
      case CustomGridCardStyle.gradient:
        card = _buildGradientCard(context, item, index);
        break;
      case CustomGridCardStyle.minimal:
        card = _buildMinimalCard(context, item, index);
        break;
      case CustomGridCardStyle.glassmorphism:
        card = _buildGlassmorphismCard(context, item, index);
        break;
    }

    if (showAnimation) {
      card = card
          .animate(
            delay: Duration(
              milliseconds: animationDelay.inMilliseconds * index,
            ),
          )
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8));
    }

    return card;
  }

  Widget _buildElevatedCard(
    BuildContext context,
    GridCardData item,
    int index,
  ) {
    // Responsive padding and border radius
    final double cardPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 10.0,
      tablet: 16.0,
      desktop: 15.0,
    );
    final double borderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'card',
    );

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveHelper.getSpacing(context, "cardPadding"),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.1),
              blurRadius: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 16.0,
                tablet: 18.0,
                desktop: 20.0,
              ),
              offset: Offset(
                0,
                ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 4.0,
                  tablet: 7.0,
                  desktop: 6.0,
                ),
              ),
            ),
          ],
          border: Border.all(
            color: item.color.withOpacity(0.1),
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 0.8,
              tablet: 0.9,
              desktop: 1.0,
            ),
          ),
        ),
        child: _buildCardContent(context, item),
      ),
    );
  }

  Widget _buildOutlinedCard(
    BuildContext context,
    GridCardData item,
    int index,
  ) {
    // Responsive padding and border radius
    final double cardPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 24.0,
    );
    final double borderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'card',
    );

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: item.color.withOpacity(0.3),
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 1.5,
              tablet: 1.8,
              desktop: 2.0,
            ),
          ),
        ),
        child: _buildCardContent(context, item),
      ),
    );
  }

  Widget _buildGradientCard(
    BuildContext context,
    GridCardData item,
    int index,
  ) {
    // Responsive padding and border radius
    final double cardPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 24.0,
    );
    final double borderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'card',
    );

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
          border: Border.all(
            color: item.color.withOpacity(0.2),
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 0.8,
              tablet: 0.9,
              desktop: 1.0,
            ),
          ),
        ),
        child: _buildCardContent(context, item),
      ),
    );
  }

  Widget _buildMinimalCard(BuildContext context, GridCardData item, int index) {
    // Responsive border radius
    final double borderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'small',
    );

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        // Removed internal padding to make cards bigger
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: _buildCardContent(context, item),
      ),
    );
  }

  Widget _buildGlassmorphismCard(
    BuildContext context,
    GridCardData item,
    int index,
  ) {
    // Responsive padding and border radius
    final double cardPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 24.0,
    );
    final double borderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'card',
    );
    final double blurRadius = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 8.0,
      tablet: 9.0,
      desktop: 10.0,
    );

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 0.8,
              tablet: 0.9,
              desktop: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.1),
              blurRadius: blurRadius,
              offset: Offset(
                0,
                ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 3.0,
                  tablet: 3.5,
                  desktop: 4.0,
                ),
              ),
            ),
          ],
        ),
        child: _buildCardContent(context, item),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, GridCardData item) {
    if (item.customContent != null) {
      return item.customContent!;
    }

    // Responsive sizing using ResponsiveHelper
    final double iconPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 10.0,
      tablet: 9.0,
      desktop: 8.0,
    );
    final double iconSize = ResponsiveHelper.getIconSize(context, 'small');
    final double iconBorderRadius = ResponsiveHelper.getBorderRadius(
      context,
      'small',
    );
    final double trendIconSize = ResponsiveHelper.getIconSize(
      context,
      'xsmall',
    );
    final double trendFontSize = ResponsiveHelper.getFontSize(context, 'body3');
    final double valueSpacing = ResponsiveHelper.getSpacing(
      context,
      'sectionMargin',
    );
    final double valueFontSize = ResponsiveHelper.getFontSize(
      context,
      'heading5',
    );
    final double titleSpacing = ResponsiveHelper.getSpacing(
      context,
      'itemSpacing',
    );
    final double titleFontSize = ResponsiveHelper.getFontSize(context, 'body3');
    final double subtitleSpacing = ResponsiveHelper.getSpacing(context, 'xs');
    final double subtitleFontSize = ResponsiveHelper.getFontSize(
      context,
      'caption',
    );
    final double trendSpacing = ResponsiveHelper.getSpacing(context, 'xs');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and trend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getSpacing(context, 'small'),
              ),
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

        SizedBox(height: ResponsiveHelper.getSpacing(context, "small")),

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
                right: j < crossAxisCount - 1 ? crossAxisSpacing : 0,
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
        rows.add(SizedBox(height: mainAxisSpacing));
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
      height: itemHeight,
      padding: padding,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            width: itemWidth,
            margin: EdgeInsets.only(
              right: ResponsiveHelper.getSpacing(context, 'medium'),
            ),
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
