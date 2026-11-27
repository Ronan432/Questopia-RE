import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../sheets/settings_picker_sheets.dart';
import '../widgets/miuix_settings_tiles.dart';

class MiuixAppearanceSection extends StatelessWidget {
  const MiuixAppearanceSection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionAppearance),
        MiuixSettingsGroup(
          children: [
            miuixDropdownPreference(
              context: context,
              title: l10n.theme,
              iconName: 'theme',
              items: [
                SettingsPickerSheets.themeLabel(context, ThemeModeOption.system),
                SettingsPickerSheets.themeLabel(context, ThemeModeOption.light),
                SettingsPickerSheets.themeLabel(context, ThemeModeOption.dark),
              ],
              selectedIndex: switch (settings.themeMode) {
                ThemeModeOption.system => 0,
                ThemeModeOption.light => 1,
                ThemeModeOption.dark || ThemeModeOption.amoled => 2,
              },
              onSelectedIndexChange: (index) {
                const modes = [
                  ThemeModeOption.system,
                  ThemeModeOption.light,
                  ThemeModeOption.dark,
                ];
                notifier.setThemeMode(modes[index]);
              },
            ),
            Builder(
              builder: (context) {
                final options = SettingsPickerSheets.languageOptions(context);
                final currentIndex = options.indexWhere(
                  (option) => option.$1 == settings.language,
                );
                return miuixDropdownPreference(
                  context: context,
                  title: l10n.language,
                  iconName: 'translate',
                  items: [for (final option in options) option.$2],
                  selectedIndex: currentIndex < 0 ? 0 : currentIndex,
                  onSelectedIndexChange: (index) =>
                      notifier.setLanguage(options[index].$1),
                );
              },
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.miuixDynamicColor,
              summary: l10n.miuixDynamicColorSummary,
              iconName: 'theme',
              value: settings.isMiuixDynamicColor,
              onChanged: notifier.setMiuixDynamicColor,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.navBarBlur,
              iconName: 'layers',
              value: settings.isNavBarBlur,
              onChanged: notifier.setNavBarBlur,
            ),
            if (settings.isNavBarBlur)
              miuixSliderPreference(
                context: context,
                title: '',
                value: settings.navBarBlurPercent,
                min: 10,
                max: 100,
                steps: 9,
                snapToSteps: true,
                valueText: '${settings.navBarBlurPercent.round()}%',
                onChanged: notifier.setNavBarBlurPercent,
              ),
            miuixSwitchPreference(
              context: context,
              title: l10n.immersiveMode,
              iconName: 'screenMirroring',
              value: settings.isImmersiveMode,
              onChanged: notifier.setImmersiveMode,
            ),
          ],
        ),
      ],
    );
  }
}

class MiuixGeneralSection extends StatelessWidget {
  const MiuixGeneralSection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionGeneral),
        MiuixSettingsGroup(
          children: [
            miuixSwitchPreference(
              context: context,
              title: l10n.autoSave,
              iconName: 'save',
              value: settings.isAutosaveEnabled,
              onChanged: notifier.setAutosave,
            ),
            if (settings.isAutosaveEnabled)
              miuixSliderPreference(
                context: context,
                title: l10n.autoSaveInterval,
                iconName: 'timer',
                value: settings.autosaveInterval.toDouble(),
                min: 10,
                max: 100,
                steps: 9,
                valueText: '${settings.autosaveInterval} ${l10n.clicks}',
                onChanged: (value) =>
                    notifier.setAutosaveInterval(value.round()),
              ),
            miuixSwitchPreference(
              context: context,
              title: l10n.cheatEngine,
              iconName: 'lock',
              value: settings.isCheatsEnabled,
              onChanged: notifier.setCheatsEnabled,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.qspCommandLine,
              iconName: 'memoryFunction',
              value: settings.isExecStringEnabled,
              onChanged: notifier.setExecStringEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
