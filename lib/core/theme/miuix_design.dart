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
    final seed = materialTheme.colorScheme.primary;
    return MiuixTheme(
      data: MiuixThemeData.of(
        materialTheme.brightness,
        lightColors: miuixColorsFromSeed(seed: seed, dark: false),
        darkColors: miuixColorsFromSeed(seed: seed, dark: true),
      ),
      child: child,
    );
  }
}
