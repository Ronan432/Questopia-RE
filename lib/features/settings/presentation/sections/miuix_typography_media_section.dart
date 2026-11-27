import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../sheets/settings_picker_sheets.dart';
import '../widgets/miuix_settings_tiles.dart';

class MiuixTypographySection extends StatelessWidget {
  const MiuixTypographySection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typefaces = SettingsPickerSheets.typefaceNames(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionTypography),
        MiuixSettingsGroup(
          children: [
            miuixSliderPreference(
              context: context,
              title: l10n.fontSize,
              iconName: 'book',
              value: settings.fontSize,
              min: 12,
              max: 28,
              steps: 8,
              valueText: '${settings.fontSize.toStringAsFixed(0)} pt',
              onChanged: notifier.setFontSize,
            ),
            miuixDropdownPreference(
              context: context,
              title: l10n.typeface,
              iconName: 'edit',
              items: typefaces,
              selectedIndex:
                  settings.typefaceIndex.clamp(0, typefaces.length - 1),
              onSelectedIndexChange: notifier.setTypefaceIndex,
            ),
            Builder(
              builder: (context) {
                final idx = kReadingThemeIds.indexOf(settings.readingTheme);
                return miuixDropdownPreference(
                  context: context,
                  title: l10n.readingTheme,
                  iconName: 'theme',
                  items: [
                    for (final id in kReadingThemeIds)
                      SettingsPickerSheets.readingThemeLabel(context, id),
                  ],
                  selectedIndex: idx < 0 ? 0 : idx,
                  onSelectedIndexChange: (index) =>
                      notifier.setReadingTheme(kReadingThemeIds[index]),
                );
              },
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.customTextColor,
              iconName: 'theme',
              value: settings.useGameTextColor,
              onChanged: notifier.setUseGameTextColor,
            ),
            if (settings.useGameTextColor)
              miuixInfoPreference(
                context: context,
                title: l10n.textColor,
                iconName: 'theme',
                endAction: _ColorDot(
                  color: Color(settings.gameTextColor),
                  onPick: (c) => notifier.setGameTextColor(c.toARGB32()),
                ),
              ),
            miuixSwitchPreference(
              context: context,
              title: l10n.customBackgroundColor,
              iconName: 'theme',
              value: settings.useGameBackgroundColor,
              onChanged: notifier.setUseGameBackgroundColor,
            ),
            if (settings.useGameBackgroundColor)
              miuixInfoPreference(
                context: context,
                title: l10n.backgroundColor,
                iconName: 'theme',
                endAction: _ColorDot(
                  color: Color(settings.gameBackColor),
                  onPick: (c) => notifier.setGameBackColor(c.toARGB32()),
                ),
              ),
            miuixSwitchPreference(
              context: context,
              title: l10n.customLinkColor,
              iconName: 'link',
              value: settings.useGameLinkColor,
              onChanged: notifier.setUseGameLinkColor,
            ),
            if (settings.useGameLinkColor)
              miuixInfoPreference(
                context: context,
                title: l10n.linkColor,
                iconName: 'link',
                endAction: _ColorDot(
                  color: Color(settings.gameLinkColor),
                  onPick: (c) => notifier.setGameLinkColor(c.toARGB32()),
                ),
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
            miuixDropdownPreference(
              context: context,
              title: l10n.actionsPanelHeight,
              iconName: 'verticalSplit',
              items: const ['1/2', '1/3', '1/4', '1/5'],
              selectedIndex: const ['1/2', '1/3', '1/4', '1/5']
                  .indexOf(settings.actionsHeightRatio)
                  .clamp(0, 3),
              onSelectedIndexChange: (index) => notifier.setActionsHeightRatio(
                const ['1/2', '1/3', '1/4', '1/5'][index],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.onPick});

  final Color color;
  final ValueChanged<Color> onPick;

  static const _swatches = <Color>[
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFF1A1C1E),
    Color(0xFFF4ECD8),
    Color(0xFF0061A4),
    Color(0xFF2E6C38),
    Color(0xFF9B4061),
    Color(0xFF924C00),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final swatch in _swatches)
          GestureDetector(
            onTap: () => onPick(swatch),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: swatch,
                shape: BoxShape.circle,
                border: Border.all(
                  color: swatch.toARGB32() == color.toARGB32()
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withValues(alpha: 0.4),
                  width: swatch.toARGB32() == color.toARGB32() ? 2 : 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MiuixMediaSection extends StatelessWidget {
  const MiuixMediaSection({
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
        MiuixSettingsSectionTitle(l10n.sectionMedia),
        MiuixSettingsGroup(
          children: [
            miuixSwitchPreference(
              context: context,
              title: l10n.disableImages,
              iconName: 'image',
              value: settings.isImageDisabled,
              onChanged: notifier.setImageDisabled,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.showAllImagesDialog,
              iconName: 'image',
              value: settings.isImagesInDialogEnabled,
              onChanged: notifier.setImagesInDialog,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.pinchZoom,
              iconName: 'search',
              value: settings.isPinchZoomEnabled,
              onChanged: notifier.setPinchZoom,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.fullscreenImages,
              iconName: 'screenMirroring',
              value: settings.isFullscreenImages,
              onChanged: notifier.setFullscreenImages,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.autoWidth,
              iconName: 'horizontalSplit',
              value: settings.isAutoWidth,
              onChanged: notifier.setAutoWidth,
            ),
            if (!settings.isAutoWidth)
              miuixSliderPreference(
                context: context,
                title: l10n.imageWidth,
                iconName: 'horizontalSplit',
                value: settings.customWidthImage.toDouble(),
                min: 100,
                max: 2000,
                steps: 19,
                valueText: '${settings.customWidthImage} px',
                onChanged: (value) =>
                    notifier.setCustomWidthImage(value.round()),
              ),
            miuixSwitchPreference(
              context: context,
              title: l10n.autoHeight,
              iconName: 'verticalSplit',
              value: settings.isAutoHeight,
              onChanged: notifier.setAutoHeight,
            ),
            if (!settings.isAutoHeight)
              miuixSliderPreference(
                context: context,
                title: l10n.imageHeight,
                iconName: 'verticalSplit',
                value: settings.customHeightImage.toDouble(),
                min: 100,
                max: 2000,
                steps: 19,
                valueText: '${settings.customHeightImage} px',
                onChanged: (value) =>
                    notifier.setCustomHeightImage(value.round()),
              ),
          ],
        ),
      ],
    );
  }
}
