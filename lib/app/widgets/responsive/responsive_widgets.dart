import 'package:flutter/material.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/constants/responsive_constants.dart';
import '../../../core/theme/app_decorations.dart';

/// A responsive card widget that adapts padding and styling based on screen size
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final String paddingType; // 'small', 'medium', 'large'
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.paddingType = 'medium',
    this.backgroundColor,
    this.decoration,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? _getResponsivePadding(context);

    return Container(
      width: width,
      height: height,
      padding: responsivePadding,
      decoration:
          decoration ??
          AppDecorations.floatingCard().copyWith(color: backgroundColor),
      child: child,
    );
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    final spacingConfig = ResponsiveConstants.getSpacing('cardPadding');
    if (spacingConfig == null) {
      return EdgeInsets.all(16);
    }

    return ResponsiveHelper.getResponsivePadding(
      context,
      mobile: EdgeInsets.all(spacingConfig['mobile']!.toDouble()),
      tablet: EdgeInsets.all(spacingConfig['tablet']!.toDouble()),
      desktop: EdgeInsets.all(spacingConfig['desktop']!.toDouble()),
    );
  }
}

/// A responsive text widget with automatic font scaling
class ResponsiveText extends StatelessWidget {
  final String text;
  final String styleType; // 'heading1', 'heading2', etc.
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextStyle? baseStyle;

  const ResponsiveText({
    Key? key,
    required this.text,
    required this.styleType,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.baseStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveStyle = _getResponsiveTextStyle(context);

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  TextStyle _getResponsiveTextStyle(BuildContext context) {
    final typographyConfig = ResponsiveConstants.getTypography(styleType);

    if (typographyConfig == null) {
      return TextStyle(fontSize: 16, color: color, fontWeight: fontWeight);
    }

    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: typographyConfig['mobile']!,
      tablet: typographyConfig['tablet']!,
      desktop: typographyConfig['desktop']!,
    );

    return (baseStyle ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

/// A responsive icon widget with size scaling
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final String sizeType; // 'small', 'medium', 'large', 'xlarge'
  final Color? color;

  const ResponsiveIcon({
    Key? key,
    required this.icon,
    this.sizeType = 'medium',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconConfig = ResponsiveConstants.getIconSizes(sizeType);

    if (iconConfig == null) {
      return Icon(icon, size: 24, color: color);
    }

    final iconSize = ResponsiveHelper.getResponsiveIconSize(
      context,
      mobile: iconConfig['mobile']!,
      tablet: iconConfig['tablet']!,
      desktop: iconConfig['desktop']!,
    );

    return Icon(icon, size: iconSize, color: color);
  }
}

/// A responsive container with width scaling
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final String widthType; // 'form', 'dialog', 'card'
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;
  final double? height;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.widthType = 'card',
    this.padding,
    this.margin,
    this.decoration,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerConfig = ResponsiveConstants.getContainerWidth(widthType);
    double width = MediaQuery.of(context).size.width;

    if (containerConfig != null) {
      width = ResponsiveHelper.getContainerWidth(
        context,
        mobileRatio: containerConfig['mobile']!,
        tabletRatio: containerConfig['tablet']!,
        desktopRatio: containerConfig['desktop']!,
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}

/// A responsive spacing widget
class ResponsiveSpacing extends StatelessWidget {
  final String spacingType; // 'padding', 'sectionMargin', 'itemSpacing'
  final bool isVertical;

  const ResponsiveSpacing({
    Key? key,
    this.spacingType = 'sectionMargin',
    this.isVertical = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacingConfig = ResponsiveConstants.getSpacing(spacingType);

    if (spacingConfig == null) {
      return SizedBox(
        height: isVertical ? 16 : null,
        width: !isVertical ? 16 : null,
      );
    }

    final spacing = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: spacingConfig['mobile']!,
      tablet: spacingConfig['tablet']!,
      desktop: spacingConfig['desktop']!,
    );

    return SizedBox(
      height: isVertical ? spacing : null,
      width: !isVertical ? spacing : null,
    );
  }
}

/// A responsive grid view with predefined configurations
class ResponsiveGridWidget extends StatelessWidget {
  final List<Widget> children;
  final String gridType; // 'quickActions', 'statsCards', etc.
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridWidget({
    Key? key,
    required this.children,
    required this.gridType,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.shrinkWrap = true,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridConfig = ResponsiveConstants.getGridConfig(gridType);
    final spacingConfig = ResponsiveConstants.getSpacing('itemSpacing');

    if (gridConfig == null) {
      return GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics ?? const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: crossAxisSpacing ?? 12,
          mainAxisSpacing: mainAxisSpacing ?? 12,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }

    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: gridConfig['mobile']!,
      tablet: gridConfig['tablet']!,
      desktop: gridConfig['desktop']!,
    );

    final spacing = spacingConfig != null
        ? ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: spacingConfig['mobile']!,
            tablet: spacingConfig['tablet']!,
            desktop: spacingConfig['desktop']!,
          )
        : 12.0;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing ?? spacing,
        mainAxisSpacing: mainAxisSpacing ?? spacing,
        childAspectRatio: _getAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  double _getAspectRatio(BuildContext context) {
    final aspectRatioConfig =
        ResponsiveConstants.getAspectRatio(gridType) ??
        ResponsiveConstants.getAspectRatio('card');

    if (aspectRatioConfig == null) {
      return ResponsiveHelper.getCardAspectRatio(context);
    }

    return ResponsiveHelper.getValue(
      context,
      mobile: aspectRatioConfig['mobile']!,
      tablet: aspectRatioConfig['tablet']!,
      desktop: aspectRatioConfig['desktop']!,
    );
  }
}




