import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../settings/presentation/sheets/settings_picker_sheets.dart';
import '../../../settings/presentation/widgets/miuix_settings_tiles.dart';
import 'onboarding_step_layout.dart';

/// Accent color step: the accent dropdown row from the settings screen.
class OnboardingAccentStep extends StatelessWidget {
  const OnboardingAccentStep({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final SettingsState settings;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = SettingsPickerSheets.accentLabels(context);
    final currentIndex = kThemeColorOptions.indexOf(settings.themeColor);

    return OnboardingStepLayout(
      title: l10n.onboardingAccentTitle,
      description: l10n.onboardingAccentBody,
      child: MiuixSettingsGroup(
        children: [
          miuixDropdownPreference(
            context: context,
            title: l10n.colorAccent,
            iconName: 'theme',
            items: [
              for (final id in kThemeColorOptions) labels[id] ?? id,
            ],
            selectedIndex: currentIndex < 0 ? 0 : currentIndex,
            onSelectedIndexChange: (index) =>
                onChanged(kThemeColorOptions[index]),
          ),
        ],
      ),
    );
  }
}

/// Reading experience step: the text size slider and the reading theme row.
class OnboardingReadingStep extends StatelessWidget {
  const OnboardingReadingStep({
    super.key,
    required this.settings,
    required this.onFontSizeChanged,
    required this.onReadingThemeChanged,
  });

  final SettingsState settings;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<String> onReadingThemeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = kReadingThemeIds.indexOf(settings.readingTheme);

    return OnboardingStepLayout(
      title: l10n.onboardingReadingTitle,
      description: l10n.onboardingReadingBody,
      child: MiuixSettingsGroup(
        children: [
          miuixSliderPreference(
            context: context,
            title: l10n.onboardingReadingFontSize,
            iconName: 'edit',
            value: settings.fontSize.clamp(12.0, 28.0),
            min: 12,
            max: 28,
            steps: 8,
            valueText: '${settings.fontSize.toStringAsFixed(0)} pt',
            onChanged: onFontSizeChanged,
          ),
          miuixDropdownPreference(
            context: context,
            title: l10n.readingTheme,
            iconName: 'book',
            items: [
              for (final id in kReadingThemeIds)
                SettingsPickerSheets.readingThemeLabel(context, id),
            ],
            selectedIndex: currentIndex < 0 ? 0 : currentIndex,
            onSelectedIndexChange: (index) =>
                onReadingThemeChanged(kReadingThemeIds[index]),
          ),
        ],
      ),
    );
  }
}
