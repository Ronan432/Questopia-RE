import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../sheets/settings_picker_sheets.dart';
import '../widgets/miuix_settings_tiles.dart';
import '../widgets/setting_tiles.dart';

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
        MiuixSmallTitle(l10n.sectionTypography),
        MiuixSettingsGroup(
          children: [
            miuixSliderPreference(
              title: l10n.fontSize,
              icon: Icons.format_size_outlined,
              value: settings.fontSize,
              min: 12,
              max: 28,
              steps: 8,
              valueText: '${settings.fontSize.toStringAsFixed(0)} pt',
              onChanged: notifier.setFontSize,
            ),
            miuixArrowPreference(
              title: l10n.typeface,
              icon: Icons.style_outlined,
              summary: typefaces[
                  settings.typefaceIndex.clamp(0, typefaces.length - 1)],
              onClick: () => SettingsPickerSheets.showTypefacePicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixArrowPreference(
              title: l10n.readingTheme,
              icon: Icons.contrast_rounded,
              summary: SettingsPickerSheets.readingThemeLabel(
                context,
                settings.readingTheme,
              ),
              onClick: () => SettingsPickerSheets.showReadingThemePicker(
                context,
                notifier,
                settings,
              ),
            ),
            miuixSwitchPreference(
              title: l10n.customTextColor,
              icon: Icons.format_color_text_outlined,
              value: settings.useGameTextColor,
              onChanged: notifier.setUseGameTextColor,
            ),
            if (settings.useGameTextColor)
              MiuixBasicComponent(
                title: l10n.textColor,
                bottomAction: ColorRow(
                  label: l10n.textColor,
                  color: Color(settings.gameTextColor),
                  onPick: (color) =>
                      notifier.setGameTextColor(color.toARGB32()),
                ),
              ),
            miuixSwitchPreference(
              title: l10n.customBackgroundColor,
              icon: Icons.format_color_fill_outlined,
              value: settings.useGameBackgroundColor,
              onChanged: notifier.setUseGameBackgroundColor,
            ),
            if (settings.useGameBackgroundColor)
              MiuixBasicComponent(
                title: l10n.backgroundColor,
                bottomAction: ColorRow(
                  label: l10n.backgroundColor,
                  color: Color(settings.gameBackColor),
                  onPick: (color) =>
                      notifier.setGameBackColor(color.toARGB32()),
                ),
              ),
            miuixSwitchPreference(
              title: l10n.customLinkColor,
              icon: Icons.link_outlined,
              value: settings.useGameLinkColor,
              onChanged: notifier.setUseGameLinkColor,
            ),
            if (settings.useGameLinkColor)
              MiuixBasicComponent(
                title: l10n.linkColor,
                bottomAction: ColorRow(
                  label: l10n.linkColor,
                  color: Color(settings.gameLinkColor),
                  onPick: (color) =>
                      notifier.setGameLinkColor(color.toARGB32()),
                ),
              ),
          ],
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
        MiuixSmallTitle(l10n.sectionMedia),
        MiuixSettingsGroup(
          children: [
            miuixSwitchPreference(
              title: l10n.disableImages,
              icon: Icons.hide_image_outlined,
              value: settings.isImageDisabled,
              onChanged: notifier.setImageDisabled,
            ),
            miuixSwitchPreference(
              title: l10n.showAllImagesDialog,
              icon: Icons.image_outlined,
              value: settings.isImagesInDialogEnabled,
              onChanged: notifier.setImagesInDialog,
            ),
            miuixSwitchPreference(
              title: l10n.pinchZoom,
              icon: Icons.zoom_in_outlined,
              value: settings.isPinchZoomEnabled,
              onChanged: notifier.setPinchZoom,
            ),
            miuixSwitchPreference(
              title: l10n.fullscreenImages,
              icon: Icons.fullscreen_outlined,
              value: settings.isFullscreenImages,
              onChanged: notifier.setFullscreenImages,
            ),
            miuixSwitchPreference(
              title: l10n.autoWidth,
              icon: Icons.width_full_outlined,
              value: settings.isAutoWidth,
              onChanged: notifier.setAutoWidth,
            ),
            if (!settings.isAutoWidth)
              miuixSliderPreference(
                title: l10n.imageWidth,
                icon: Icons.width_normal_outlined,
                value: settings.customWidthImage.toDouble(),
                min: 100,
                max: 2000,
                steps: 19,
                valueText: '${settings.customWidthImage} px',
                onChanged: (value) =>
                    notifier.setCustomWidthImage(value.round()),
              ),
            miuixSwitchPreference(
              title: l10n.autoHeight,
              icon: Icons.height_outlined,
              value: settings.isAutoHeight,
              onChanged: notifier.setAutoHeight,
            ),
            if (!settings.isAutoHeight)
              miuixSliderPreference(
                title: l10n.imageHeight,
                icon: Icons.height_outlined,
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
