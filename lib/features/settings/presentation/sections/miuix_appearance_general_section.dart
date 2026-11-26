import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

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
            miuixArrowPreference(
              context: context,
              title: l10n.theme,
              iconName: 'theme',
              summary: SettingsPickerSheets.themeLabel(
                context,
                settings.themeMode == ThemeModeOption.amoled
                    ? ThemeModeOption.dark
                    : settings.themeMode,
              ),
              onClick: () => SettingsPickerSheets.showThemeModePicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixArrowPreference(
              context: context,
              title: l10n.language,
              iconName: 'translate',
              summary: SettingsPickerSheets.languageOptions(context)
                  .firstWhere(
                    (option) => option.$1 == settings.language,
                    orElse: () => ('system', l10n.followSystem),
                  )
                  .$2,
              onClick: () => SettingsPickerSheets.showLanguagePicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.miuixDynamicColor,
              summary: l10n.miuixDynamicColorSummary,
              iconName: 'theme',
              value: settings.isMiuixDynamicColor,
              onChanged: notifier.setMiuixDynamicColor,
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
              title: l10n.immersiveMode,
              iconName: 'screenMirroring',
              value: settings.isImmersiveMode,
              onChanged: notifier.setImmersiveMode,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.autoscroll,
              iconName: 'expandMore',
              value: settings.isUseAutoscroll,
              onChanged: notifier.setAutoscroll,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.separatorLine,
              iconName: 'listView',
              value: settings.isUseSeparator,
              onChanged: notifier.setSeparator,
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
                title: l10n.navBarBlur,
                iconName: 'tune',
                value: settings.navBarBlurPercent,
                min: 10,
                max: 100,
                steps: 9,
                valueText: '${settings.navBarBlurPercent.round()}%',
                onChanged: notifier.setNavBarBlurPercent,
              ),
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
            miuixArrowPreference(
              context: context,
              title: l10n.actionsPanelHeight,
              iconName: 'verticalSplit',
              summary: settings.actionsHeightRatio,
              onClick: () => SettingsPickerSheets.showActionsHeightPicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixArrowPreference(
              context: context,
              title: l10n.binaryPrefixes,
              iconName: 'backup',
              fallbackIcon: MiuixIcons.os4.backup,
              summary: settings.binaryPrefixes == 1024 ? '1024' : '1000',
              onClick: () => SettingsPickerSheets.showBinaryPrefixesPicker(
                context,
                notifier,
                settings,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
