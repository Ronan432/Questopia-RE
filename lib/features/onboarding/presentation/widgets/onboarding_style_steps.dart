import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/game_colors.dart';
import '../../../settings/presentation/sheets/settings_picker_sheets.dart';
import 'onboarding_option_card.dart';
import 'onboarding_step_layout.dart';

/// Accent color step: every entry of `kThemeColorOptions`, including the
/// dynamic Material You palette.
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
    final colors = Theme.of(context).colorScheme;
    final labels = SettingsPickerSheets.accentLabels(context);

    return OnboardingStepLayout(
      icon: Icons.color_lens_outlined,
      title: l10n.onboardingAccentTitle,
      description: l10n.onboardingAccentBody,
      child: Column(
        children: [
          for (final id in kThemeColorOptions)
            OnboardingOptionCard(
              title: labels[id] ?? id,
              isSelected: settings.themeColor == id,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: SettingsPickerSheets.accentColors[id] ?? colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: settings.themeColor == id
                        ? colors.primary
                        : colors.outlineVariant,
                    width: settings.themeColor == id ? 3 : 1,
                  ),
                ),
              ),
              onTap: () => onChanged(id),
            ),
        ],
      ),
    );
  }
}

/// Reading experience step: game text size and the reading surface preset.
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
    final colors = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return OnboardingStepLayout(
      icon: Icons.menu_book_outlined,
      title: l10n.onboardingReadingTitle,
      description: l10n.onboardingReadingBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: colors.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.onboardingReadingFontSize}: '
                    '${settings.fontSize.toStringAsFixed(0)} pt',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  M3ESlider(
                    value: settings.fontSize.clamp(12.0, 28.0),
                    min: 12.0,
                    max: 28.0,
                    divisions: 8,
                    haptic: M3EHapticFeedback.light,
                    onChanged: onFontSizeChanged,
                  ),
                  Text(
                    l10n.livePreviewText,
                    style: TextStyle(
                      fontSize: settings.fontSize,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.readingTheme,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          for (final id in kReadingThemeIds)
            OnboardingOptionCard(
              title: SettingsPickerSheets.readingThemeLabel(context, id),
              isSelected: settings.readingTheme == id,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ReadingThemeColors.background(id, brightness),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: settings.readingTheme == id
                        ? colors.primary
                        : colors.outlineVariant,
                    width: settings.readingTheme == id ? 3 : 1,
                  ),
                ),
              ),
              onTap: () => onReadingThemeChanged(id),
            ),
        ],
      ),
    );
  }
}
