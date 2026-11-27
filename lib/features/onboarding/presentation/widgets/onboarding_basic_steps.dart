import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../settings/presentation/sheets/settings_picker_sheets.dart';
import '../../../settings/presentation/widgets/miuix_settings_tiles.dart';
import 'onboarding_step_layout.dart';

/// Welcome step: the title and the opening line, nothing else.
class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiuixText(
                l10n.onboardingWelcomeTitle,
                textAlign: TextAlign.center,
                style: miuix.textStyles.title2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              MiuixText(
                l10n.onboardingWelcomeBody,
                textAlign: TextAlign.center,
                style: miuix.textStyles.body2.copyWith(
                  height: 1.5,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Language step: the same language dropdown row the settings screen uses.
class OnboardingLanguageStep extends StatelessWidget {
  const OnboardingLanguageStep({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final SettingsState settings;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = SettingsPickerSheets.languageOptions(context);
    final currentIndex = options.indexWhere(
      (option) => option.$1 == settings.language,
    );

    return OnboardingStepLayout(
      title: l10n.onboardingLanguageTitle,
      description: l10n.onboardingLanguageBody,
      child: MiuixSettingsGroup(
        children: [
          miuixDropdownPreference(
            context: context,
            title: l10n.language,
            iconName: 'translate',
            items: [for (final option in options) option.$2],
            selectedIndex: currentIndex < 0 ? 0 : currentIndex,
            onSelectedIndexChange: (index) => onChanged(options[index].$1),
          ),
        ],
      ),
    );
  }
}

/// Theme step: the theme dropdown row from the settings screen. Amoled is not
/// offered because the Miuix theme renders it as the plain dark surface.
class OnboardingThemeStep extends StatelessWidget {
  const OnboardingThemeStep({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final SettingsState settings;
  final ValueChanged<ThemeModeOption> onChanged;

  static const List<ThemeModeOption> _modes = [
    ThemeModeOption.system,
    ThemeModeOption.light,
    ThemeModeOption.dark,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = switch (settings.themeMode) {
      ThemeModeOption.system => 0,
      ThemeModeOption.light => 1,
      ThemeModeOption.dark || ThemeModeOption.amoled => 2,
    };

    return OnboardingStepLayout(
      title: l10n.onboardingThemeTitle,
      description: l10n.onboardingThemeBody,
      child: MiuixSettingsGroup(
        children: [
          miuixDropdownPreference(
            context: context,
            title: l10n.theme,
            iconName: 'theme',
            items: [
              for (final mode in _modes)
                SettingsPickerSheets.themeLabel(context, mode),
            ],
            selectedIndex: selectedIndex,
            onSelectedIndexChange: (index) => onChanged(_modes[index]),
          ),
        ],
      ),
    );
  }
}
