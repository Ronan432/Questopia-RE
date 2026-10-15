import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/window_title_bar.dart';
import 'onboarding_option_card.dart';
import 'onboarding_step_layout.dart';

/// Welcome step: logo, application name and a one line description.
class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              const QuestopiaLogoIcon(size: 96),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.onboardingWelcomeBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Language step: automatic, English or Russian.
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
    final colors = Theme.of(context).colorScheme;

    return OnboardingStepLayout(
      icon: Icons.translate_rounded,
      title: l10n.onboardingLanguageTitle,
      description: l10n.onboardingLanguageBody,
      child: Column(
        children: [
          OnboardingOptionCard(
            title: l10n.languageAuto,
            isSelected: settings.language == 'system',
            leading: Icon(
              Icons.settings_suggest_rounded,
              color: settings.language == 'system' ? colors.primary : null,
            ),
            onTap: () => onChanged('system'),
          ),
          OnboardingOptionCard(
            title: 'English',
            isSelected: settings.language == 'en',
            leading: Text(
              'EN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: settings.language == 'en' ? colors.primary : null,
              ),
            ),
            onTap: () => onChanged('en'),
          ),
          OnboardingOptionCard(
            title: 'Русский',
            isSelected: settings.language == 'ru',
            leading: Text(
              'RU',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: settings.language == 'ru' ? colors.primary : null,
              ),
            ),
            onTap: () => onChanged('ru'),
          ),
        ],
      ),
    );
  }
}

/// Theme step: a four card grid, with the automatic entry spanning the row and
/// the three fixed appearances beneath it.
class OnboardingThemeStep extends StatelessWidget {
  const OnboardingThemeStep({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final SettingsState settings;
  final ValueChanged<ThemeModeOption> onChanged;

  static IconData iconFor(ThemeModeOption mode) => switch (mode) {
        ThemeModeOption.system => Icons.brightness_auto_rounded,
        ThemeModeOption.light => Icons.light_mode_rounded,
        ThemeModeOption.dark => Icons.dark_mode_rounded,
        ThemeModeOption.amoled => Icons.contrast_rounded,
      };

  static String labelFor(AppLocalizations l10n, ThemeModeOption mode) =>
      switch (mode) {
        ThemeModeOption.system => l10n.systemTheme,
        ThemeModeOption.light => l10n.lightTheme,
        ThemeModeOption.dark => l10n.darkTheme,
        ThemeModeOption.amoled => l10n.amoledTheme,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // The automatic entry answers a different question than the three fixed
    // appearances, so it gets its own full width card and they share the row
    // below it.
    const fixed = <ThemeModeOption>[
      ThemeModeOption.light,
      ThemeModeOption.dark,
      ThemeModeOption.amoled,
    ];

    return OnboardingStepLayout(
      icon: Icons.palette_outlined,
      title: l10n.onboardingThemeTitle,
      description: l10n.onboardingThemeBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingChoiceCard(
            title: labelFor(l10n, ThemeModeOption.system),
            icon: iconFor(ThemeModeOption.system),
            isSelected: settings.themeMode == ThemeModeOption.system,
            onTap: () => onChanged(ThemeModeOption.system),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < fixed.length; i++) ...[
                if (i > 0) const SizedBox(width: 3),
                Expanded(
                  child: OnboardingChoiceCard(
                    title: labelFor(l10n, fixed[i]),
                    icon: iconFor(fixed[i]),
                    isSelected: settings.themeMode == fixed[i],
                    onTap: () => onChanged(fixed[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
