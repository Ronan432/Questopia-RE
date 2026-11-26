import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Advanced textures blur integrated as the standard blur effect.
class GlassEffect {
  GlassEffect._();

  static ImageFilter _saturationMatrix(double s) => ColorFilter.matrix(<double>[
        0.213 + 0.787 * s,
        0.715 - 0.715 * s,
        0.072 - 0.072 * s,
        0,
        0,
        0.213 - 0.213 * s,
        0.715 + 0.285 * s,
        0.072 - 0.072 * s,
        0,
        0,
        0.213 - 0.213 * s,
        0.715 - 0.715 * s,
        0.072 + 0.928 * s,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);

  static final ImageFilter _saturationFilter = _saturationMatrix(1.5);

  /// Calculates the blur sigma from a 10..100 percent setting.
  static double getSigma(double percent) {
    final intensity = (percent.clamp(10.0, 100.0)) / 100.0;
    return (intensity * 18.0).clamp(1.0, 18.0);
  }

  /// Calculates the translucent background color from a 10..100 percent setting.
  static Color getBackgroundColor(
    BuildContext context, {
    required bool enabled,
    required double percent,
    Color? baseColor,
  }) {
    final miuix = MiuixTheme.maybeOf(context);
    final theme = Theme.of(context);
    final isDark = (miuix?.brightness ?? theme.brightness) == Brightness.dark;
    final color = baseColor ?? miuix?.colors.surface ?? theme.colorScheme.surface;

    if (!enabled) return color;

    final intensity = (percent.clamp(10.0, 100.0)) / 100.0;
    final baseAlpha = (0.76 - (intensity * 0.14)).clamp(0.55, 0.85);
    final alpha = isDark ? baseAlpha : (baseAlpha - 0.05).clamp(0.48, 0.82);
    return color.withValues(alpha: alpha);
  }

  /// Wraps [child] with an advanced-texture BackdropFilter blur when [enabled].
  static Widget wrap(
    BuildContext context, {
    required Widget child,
    bool enabled = true,
    double percent = 70.0,
    Color? baseColor,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
    Border? border,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    final bg = backgroundColor ??
        getBackgroundColor(
          context,
          enabled: enabled,
          percent: percent,
          baseColor: baseColor,
        );

    final decoration = shape != null
        ? ShapeDecoration(
            color: bg,
            shape: shape,
            shadows: boxShadow,
          )
        : BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: border,
            boxShadow: boxShadow,
          );

    Widget content = DecoratedBox(
      decoration: decoration,
      child: child,
    );

    if (!enabled) {
      if (shape != null) {
        return ClipPath(
          clipper: ShapeBorderClipper(shape: shape),
          clipBehavior: clipBehavior,
          child: content,
        );
      }
      if (borderRadius != null) {
        return ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: clipBehavior,
          child: content,
        );
      }
      return content;
    }

    final sigma = getSigma(percent);
    final theme = Theme.of(context);
    final primary = MiuixTheme.maybeOf(context)?.colors.primary ?? theme.colorScheme.primary;
    final secondary =
        MiuixTheme.maybeOf(context)?.colors.secondary ?? theme.colorScheme.secondary;
    final isMonochrome = (primary == Colors.black ||
            primary == Colors.white ||
            primary == const Color(0xFF000000) ||
            primary == const Color(0xFFFFFFFF)) &&
        primary.computeLuminance() == secondary.computeLuminance();

    final ImageFilter filter = isMonochrome
        ? ImageFilter.blur(
            sigmaX: sigma,
            sigmaY: sigma,
            tileMode: TileMode.mirror,
          )
        : ImageFilter.compose(
            outer: _saturationFilter,
            inner: ImageFilter.blur(
              sigmaX: sigma,
              sigmaY: sigma,
              tileMode: TileMode.mirror,
            ),
          );

    if (shape != null) {
      return ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: filter,
          child: content,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: filter,
        child: content,
      ),
    );
  }
}
