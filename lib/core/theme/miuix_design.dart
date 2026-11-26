import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/platform_helper.dart';
import '../providers/settings_provider.dart';

bool shouldUseMiuixDesign(SettingsState settings) =>
    isAndroidPlatform && settings.isMiuixDesignEnabled;

class MiuixDesignTheme extends ConsumerWidget {
  const MiuixDesignTheme({super.key, required this.child});

  final Widget child;

  static const _seedColors = <String, Color>{
    'blue': Color(0xFF0061A4),
    'green': Color(0xFF2E6C38),
    'orange': Color(0xFF924C00),
    'purple': Color(0xFF77539D),
    'pink': Color(0xFF9B4061),
    'teal': Color(0xFF006A6A),
    'amber': Color(0xFFFBBD00),
    'monochrome': Color(0xFF757575),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDynamic = settings.isMiuixDynamicColor;
    final mode = switch (settings.themeMode) {
      ThemeModeOption.light =>
        isDynamic ? MiuixColorSchemeMode.monetLight : MiuixColorSchemeMode.light,
      ThemeModeOption.dark || ThemeModeOption.amoled =>
        isDynamic ? MiuixColorSchemeMode.monetDark : MiuixColorSchemeMode.dark,
      ThemeModeOption.system => isDynamic
          ? MiuixColorSchemeMode.monetSystem
          : MiuixColorSchemeMode.system,
    };
    final isDark = switch (settings.themeMode) {
      ThemeModeOption.light => false,
      ThemeModeOption.dark || ThemeModeOption.amoled => true,
      ThemeModeOption.system => null,
    };
    final keyColor = isDynamic ? null : _seedColors[settings.themeColor];

    return MiuixThemeController(
      colorSchemeMode: mode,
      isDark: isDark,
      keyColor: keyColor,
      child: Builder(
        builder: (miuixCtx) {
          final materialTheme = Theme.of(miuixCtx);
          final miuixData = MiuixTheme.of(miuixCtx);
          final colors = miuixData.colors;
          final scheme = ColorScheme.fromSeed(
            seedColor: colors.primary,
            brightness: miuixData.brightness,
          ).copyWith(
            primary: colors.primary,
            onPrimary: colors.onPrimary,
            surface: colors.surface,
            onSurface: colors.onSurface,
            error: colors.error,
            onError: colors.onError,
            outline: colors.outline,
          );
          final baseTextStyle =
              (materialTheme.textTheme.bodyMedium ?? const TextStyle())
                  .copyWith(
            fontFamily: 'MiSans',
            decoration: TextDecoration.none,
            color: colors.onSurface,
          );

          return Theme(
            data: materialTheme.copyWith(
              colorScheme: scheme,
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              textTheme: materialTheme.textTheme.apply(fontFamily: 'MiSans'),
            ),
            child: DefaultTextStyle(
              style: baseTextStyle,
              child: Material(
                type: MaterialType.transparency,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
