import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Advanced textures blur integrated as the standard blur effect.
class GlassEffect {
  GlassEffect._();

  /// Calculates the blur sigma from a 10..100 percent setting.
  static double getSigma(double percent) {
    final intensity = (percent.clamp(10.0, 100.0)) / 100.0;
    return (intensity * 10.0).clamp(1.0, 10.0);
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
    final baseAlpha = (0.76 + (intensity * 0.14)).clamp(0.68, 0.90);
    final alpha = isDark ? baseAlpha : (baseAlpha - 0.05).clamp(0.55, 0.88);
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

    final sigma = enabled ? getSigma(percent) : 0.0;
    final ImageFilter filter = ImageFilter.blur(
      sigmaX: sigma,
      sigmaY: sigma,
    );

    // Keep the exact same widget hierarchy whether the blur is on or off.
    // Swapping between a plain DecoratedBox and a clipped BackdropFilter
    // rebuilds the whole child subtree when the setting is toggled, which
    // shows up as a visible flicker on the bars. A zero sigma filter is a
    // no-op while the opaque background hides it completely.
    final content = DecoratedBox(
      decoration: decoration,
      child: child,
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
