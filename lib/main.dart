import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'core/error/crash_reporter.dart';
import 'core/helpers/platform_helper.dart';
import 'core/l10n/app_localizations.dart';
import 'core/providers/settings_provider.dart';
import 'core/theme/miuix_design.dart';
import 'core/theme/questopia_theme.dart';
import 'features/library/presentation/library_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!isDesktopPlatform) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  if (isDesktopPlatform) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(1100, 750),
        minimumSize: Size(650, 500),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
  CrashReporter.install();
  runApp(
    const ProviderScope(
      child: QuestopiaApp(),
    ),
  );
}

class QuestopiaApp extends ConsumerWidget {
  const QuestopiaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final mode = switch (settings.themeMode) {
      ThemeModeOption.light => ThemeMode.light,
      ThemeModeOption.dark || ThemeModeOption.amoled => ThemeMode.dark,
      ThemeModeOption.system => ThemeMode.system,
    };
    final isAmoled = settings.themeMode == ThemeModeOption.amoled;
    final useDynamic = settings.themeColor == 'dynamic';

    Locale? appLocale;
    if (settings.language != 'system' && settings.language.isNotEmpty) {
      appLocale = Locale(settings.language);
    }

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          locale: appLocale,
          theme: QuestopiaTheme.light(
            accent: settings.themeColor,
            dynamicScheme: useDynamic ? _toFlutterScheme(lightDynamic) : null,
          ),
          darkTheme: QuestopiaTheme.dark(
            accent: settings.themeColor,
            amoled: isAmoled,
            dynamicScheme: useDynamic ? _toFlutterScheme(darkDynamic) : null,
          ),
          themeMode: mode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MiuixDesignTheme(
            child: child ?? const SizedBox.shrink(),
          ),
          home: settings.isOnboardingCompleted
              ? const LibraryScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}

ColorScheme? _toFlutterScheme(dynamic s) {
  if (s == null) return null;
  if (s is ColorScheme) return s;
  return ColorScheme(
    brightness: s.brightness as Brightness,
    primary: s.primary as Color,
    onPrimary: s.onPrimary as Color,
    primaryContainer: s.primaryContainer as Color?,
    onPrimaryContainer: s.onPrimaryContainer as Color?,
    secondary: s.secondary as Color,
    onSecondary: s.onSecondary as Color,
    secondaryContainer: s.secondaryContainer as Color?,
    onSecondaryContainer: s.onSecondaryContainer as Color?,
    tertiary: s.tertiary as Color?,
    onTertiary: s.onTertiary as Color?,
    tertiaryContainer: s.tertiaryContainer as Color?,
    onTertiaryContainer: s.onTertiaryContainer as Color?,
    error: s.error as Color,
    onError: s.onError as Color,
    errorContainer: s.errorContainer as Color?,
    onErrorContainer: s.onErrorContainer as Color?,
    surface: s.surface as Color,
    onSurface: s.onSurface as Color,
    surfaceContainerLowest: s.surfaceContainerLowest as Color?,
    surfaceContainerLow: s.surfaceContainerLow as Color?,
    surfaceContainer: s.surfaceContainer as Color?,
    surfaceContainerHigh: s.surfaceContainerHigh as Color?,
    surfaceContainerHighest: s.surfaceContainerHighest as Color?,
    onSurfaceVariant: s.onSurfaceVariant as Color?,
    outline: s.outline as Color?,
    outlineVariant: s.outlineVariant as Color?,
  );
}
