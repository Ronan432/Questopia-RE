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
    final accentLabels = SettingsPickerSheets.accentLabels(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSmallTitle(l10n.sectionAppearance),
        MiuixSettingsGroup(
          children: [
            miuixArrowPreference(
              title: l10n.theme,
              icon: Icons.brightness_6_outlined,
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
              title: l10n.colorAccent,
              icon: Icons.palette_outlined,
              summary: accentLabels[settings.themeColor] ?? l10n.accentDynamic,
              onClick: () => SettingsPickerSheets.showAccentPicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixArrowPreference(
              title: l10n.language,
              icon: Icons.language_outlined,
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
              title: l10n.miuixDesign,
              summary: l10n.miuixDesignSummary,
              icon: Icons.auto_awesome_outlined,
              value: settings.isMiuixDesignEnabled,
              onChanged: notifier.setMiuixDesignEnabled,
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
        MiuixSmallTitle(l10n.sectionGeneral),
        MiuixSettingsGroup(
          children: [
            miuixSwitchPreference(
              title: l10n.immersiveMode,
              icon: Icons.fullscreen_outlined,
              value: settings.isImmersiveMode,
              onChanged: notifier.setImmersiveMode,
            ),
            miuixSwitchPreference(
              title: l10n.autoscroll,
              icon: Icons.vertical_align_bottom_outlined,
              value: settings.isUseAutoscroll,
              onChanged: notifier.setAutoscroll,
            ),
            miuixSwitchPreference(
              title: l10n.separatorLine,
              icon: Icons.table_rows_outlined,
              value: settings.isUseSeparator,
              onChanged: notifier.setSeparator,
            ),
            miuixSwitchPreference(
              title: l10n.navBarBlur,
              icon: Icons.blur_on_outlined,
              value: settings.isNavBarBlur,
              onChanged: notifier.setNavBarBlur,
            ),
            if (settings.isNavBarBlur)
              miuixSliderPreference(
                title: l10n.navBarBlur,
                icon: Icons.blur_linear_outlined,
                value: settings.navBarBlurPercent,
                min: 10,
                max: 100,
                steps: 18,
                valueText: '${settings.navBarBlurPercent.round()}%',
                onChanged: notifier.setNavBarBlurPercent,
              ),
            miuixSwitchPreference(
              title: l10n.autoSave,
              icon: Icons.save_outlined,
              value: settings.isAutosaveEnabled,
              onChanged: notifier.setAutosave,
            ),
            if (settings.isAutosaveEnabled)
              miuixSliderPreference(
                title: l10n.autoSaveInterval,
                icon: Icons.timer_outlined,
                value: settings.autosaveInterval.toDouble(),
                min: 10,
                max: 100,
                steps: 9,
                valueText: '${settings.autosaveInterval} ${l10n.clicks}',
                onChanged: (value) =>
                    notifier.setAutosaveInterval(value.round()),
              ),
            miuixSwitchPreference(
              title: l10n.cheatEngine,
              icon: Icons.security_outlined,
              value: settings.isCheatsEnabled,
              onChanged: notifier.setCheatsEnabled,
            ),
            miuixSwitchPreference(
              title: l10n.qspCommandLine,
              icon: Icons.terminal_outlined,
              value: settings.isExecStringEnabled,
              onChanged: notifier.setExecStringEnabled,
            ),
            miuixArrowPreference(
              title: l10n.actionsPanelHeight,
              icon: Icons.height_outlined,
              summary: settings.actionsHeightRatio,
              onClick: () => SettingsPickerSheets.showActionsHeightPicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixArrowPreference(
              title: l10n.binaryPrefixes,
              icon: Icons.memory_outlined,
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
