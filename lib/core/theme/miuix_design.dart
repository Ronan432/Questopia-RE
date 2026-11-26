import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../helpers/platform_helper.dart';
import '../providers/settings_provider.dart';

bool shouldUseMiuixDesign(SettingsState settings) =>
    isAndroidPlatform && settings.isMiuixDesignEnabled;

class MiuixDesignTheme extends StatelessWidget {
  const MiuixDesignTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final miuixData = MiuixThemeData.of(materialTheme.brightness);
    final colors = miuixData.colors;
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: materialTheme.brightness,
    ).copyWith(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.onSurface,
      error: colors.error,
      onError: colors.onError,
      outline: colors.outline,
    );
    return MiuixTheme(
      data: miuixData,
      child: Theme(
        data: materialTheme.copyWith(colorScheme: scheme),
        child: child,
      ),
    );
  }
}
