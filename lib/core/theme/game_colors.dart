import 'package:flutter/material.dart';

/// Fixed reading surface colors for the game screen.
///
/// The story and status panes intentionally ignore the Material color scheme.
/// Dynamic Material You tints bleed into the rendered QSP HTML and shift with
/// the system wallpaper, which makes the reading surface unstable. The game
/// text keeps a neutral, high contrast surface instead: pure black with white
/// text in dark mode, pure white with black text in light mode.
class GameColors {
  const GameColors._();

  static const Color _darkBackground = Color(0xFF000000);
  static const Color _darkForeground = Color(0xFFFFFFFF);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightForeground = Color(0xFF000000);

  /// Reading surface behind the game text.
  static Color background(Brightness brightness) =>
      brightness == Brightness.dark ? _darkBackground : _lightBackground;

  /// Text color paired with [background].
  static Color foreground(Brightness brightness) =>
      brightness == Brightness.dark ? _darkForeground : _lightForeground;
}

/// Reading surface presets selectable from the Typography settings.
///
/// Each preset defines a background, a text color and a link color so a long
/// story stays comfortable in different lighting. The `default` preset keeps the
/// original black or white surface so nothing changes for users who never open
/// the setting, and it deliberately never reads the Material color scheme:
/// dynamic Material You tints shift with the system wallpaper, which would make
/// the reading surface move under the reader. Only the explicit `materialYou`
/// preset opts into that scheme, so a wallpaper tinted surface is a choice
/// rather than the fallback.
class ReadingThemeColors {
  const ReadingThemeColors._();

  static const Color _sepiaBackground = Color(0xFFF4ECD8);
  static const Color _sepiaForeground = Color(0xFF3B2F1E);
  static const Color _sepiaLink = Color(0xFF8A5A16);

  static const Color _nightBackground = Color(0xFF10131A);
  static const Color _nightForeground = Color(0xFFC7CEDA);
  static const Color _nightLink = Color(0xFF8AB4F8);

  /// Reading surface behind the game text.
  ///
  /// [scheme] is only consulted by the opt-in `materialYou` preset. Every other
  /// preset stays independent of it, so the surface is stable by default.
  static Color background(
    String themeId,
    Brightness brightness, {
    ColorScheme? scheme,
  }) {
    switch (themeId) {
      case 'sepia':
        return _sepiaBackground;
      case 'night':
        return _nightBackground;
      case 'contrast':
        return brightness == Brightness.dark
            ? const Color(0xFF000000)
            : const Color(0xFFFFFFFF);
      case 'materialYou':
        return scheme?.surface ?? GameColors.background(brightness);
      default:
        return GameColors.background(brightness);
    }
  }

  /// Text color paired with [background].
  static Color foreground(
    String themeId,
    Brightness brightness, {
    ColorScheme? scheme,
  }) {
    switch (themeId) {
      case 'sepia':
        return _sepiaForeground;
      case 'night':
        return _nightForeground;
      case 'contrast':
        return brightness == Brightness.dark
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF000000);
      case 'materialYou':
        return scheme?.onSurface ?? GameColors.foreground(brightness);
      default:
        return GameColors.foreground(brightness);
    }
  }

  /// Link color used inside the story text.
  static Color link(
    String themeId,
    Brightness brightness,
    Color fallback, {
    ColorScheme? scheme,
  }) {
    switch (themeId) {
      case 'sepia':
        return _sepiaLink;
      case 'night':
        return _nightLink;
      case 'materialYou':
        return scheme?.primary ?? fallback;
      default:
        return fallback;
    }
  }
}