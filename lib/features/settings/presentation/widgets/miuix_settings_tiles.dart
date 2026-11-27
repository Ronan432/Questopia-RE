import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/theme/miuix_icons_helper.dart';

class MiuixSettingsSectionTitle extends StatelessWidget {
  const MiuixSettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: MiuixText(
          title,
          style: miuix.textStyles.footnote1.copyWith(
            fontWeight: FontWeight.w400,
            color: miuix.colors.onSurfaceVariantSummary,
          ),
        ),
      ),
    );
  }
}

class MiuixSettingsGroup extends StatelessWidget {
  const MiuixSettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MiuixCard(
      cornerRadius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// The taller rows leave room for the descenders of the row labels, which were
// clipped by the previous padding.
const EdgeInsets _kCompactRowMargin = EdgeInsets.symmetric(
  horizontal: 14,
  vertical: 14,
);

/// HyperOS style accent colors for the rounded settings icon tiles.
const Map<String, Color> _kSettingsIconColors = {
  'theme': Color(0xFF8A5CF6),
  'image': Color(0xFF8A5CF6),
  'screenMirroring': Color(0xFF8A5CF6),
  'memoryFunction': Color(0xFF8A5CF6),
  'translate': Color(0xFF3B82F6),
  'link': Color(0xFF3B82F6),
  'lock': Color(0xFF3B82F6),
  'search': Color(0xFF3B82F6),
  'timer': Color(0xFF3B82F6),
  'refresh': Color(0xFF3B82F6),
  'edit': Color(0xFF3B82F6),
  'book': Color(0xFFF59E0B),
  'file': Color(0xFFF59E0B),
  'folder': Color(0xFFF59E0B),
  'save': Color(0xFFF59E0B),
  'backup': Color(0xFFF59E0B),
  'volumeUp': Color(0xFF22C55E),
  'volumeOff': Color(0xFF22C55E),
  'delete': Color(0xFFEF4444),
  'info': Color(0xFF64748B),
  'layers': Color(0xFF14B8A6),
  'listView': Color(0xFF14B8A6),
  'horizontalSplit': Color(0xFF14B8A6),
  'verticalSplit': Color(0xFF14B8A6),
  'tune': Color(0xFF64748B),
  'expandMore': Color(0xFF64748B),
};

const Map<String, IconData> _kKowsuRoundedIcons = {
  'theme': Icons.palette_rounded,
  'translate': Icons.translate_rounded,
  'screenMirroring': Icons.fullscreen_rounded,
  'expandMore': Icons.keyboard_double_arrow_down_rounded,
  'listView': Icons.view_headline_rounded,
  'layers': Icons.layers_rounded,
  'tune': Icons.tune_rounded,
  'save': Icons.save_rounded,
  'timer': Icons.timer_rounded,
  'lock': Icons.lock_rounded,
  'memoryFunction': Icons.terminal_rounded,
  'verticalSplit': Icons.vertical_split_rounded,
  'backup': Icons.storage_rounded,
  'book': Icons.text_fields_rounded,
  'edit': Icons.font_download_rounded,
  'link': Icons.link_rounded,
  'image': Icons.image_rounded,
  'volumeUp': Icons.volume_up_rounded,
  'volumeOff': Icons.volume_off_rounded,
  'folder': Icons.folder_rounded,
  'delete': Icons.delete_rounded,
  'info': Icons.info_rounded,
  'refresh': Icons.refresh_rounded,
  'search': Icons.search_rounded,
};

Widget miuixSettingsIcon(BuildContext context, String iconName,
    {MiuixVectorIcon? fallback}) {
  final color = _kSettingsIconColors[iconName] ??
      MiuixTheme.of(context).colors.primary;
  final roundedIcon = _kKowsuRoundedIcons[iconName];
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: color,
        shape: MiuixSquircleBorder(cornerRadius: 9),
      ),
      child: roundedIcon != null
          ? Icon(roundedIcon, size: 18, color: Colors.white)
          : miuixIcon(
              iconName,
              size: 18,
              tint: Colors.white,
              fallback: fallback,
            ),
    ),
  );
}

MiuixArrowPreference miuixArrowPreference({
  required BuildContext context,
  required String title,
  required String iconName,
  MiuixVectorIcon? fallbackIcon,
  String? summary,
  required VoidCallback onClick,
}) {
  return MiuixArrowPreference(
    title: title,
    summary: summary,
    insideMargin: _kCompactRowMargin,
    startAction: miuixSettingsIcon(context, iconName, fallback: fallbackIcon),
    onClick: onClick,
  );
}

/// Window level dropdown row.
///
/// A scaffold level dropdown is positioned inside the shell content box while
/// its anchor is measured in window coordinates, so on a desktop layout the
/// panel drifts away from the row and can leave the window. The window level
/// variant shares one coordinate space with the anchor and dims the whole
/// window, which also stops the navigation from being used while it is open.
MiuixWindowDropdownPreference miuixDropdownPreference({
  required BuildContext context,
  required String title,
  required String iconName,
  required List<String> items,
  required int selectedIndex,
  required ValueChanged<int> onSelectedIndexChange,
  String? summary,
  MiuixVectorIcon? fallbackIcon,
}) {
  return MiuixWindowDropdownPreference(
    title: title,
    summary: summary,
    items: items,
    selectedIndex: selectedIndex.clamp(0, items.isEmpty ? 0 : items.length - 1),
    insideMargin: _kCompactRowMargin,
    startAction: miuixSettingsIcon(context, iconName, fallback: fallbackIcon),
    onSelectedIndexChange: onSelectedIndexChange,
  );
}

MiuixSwitchPreference miuixSwitchPreference({
  required BuildContext context,
  required String title,
  required String iconName,
  MiuixVectorIcon? fallbackIcon,
  String? summary,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return MiuixSwitchPreference(
    title: title,
    summary: summary,
    insideMargin: _kCompactRowMargin,
    startAction: miuixSettingsIcon(context, iconName, fallback: fallbackIcon),
    value: value,
    onChanged: onChanged,
  );
}

MiuixSliderPreference miuixSliderPreference({
  required BuildContext context,
  required String title,
  required String iconName,
  MiuixVectorIcon? fallbackIcon,
  required double value,
  required double min,
  required double max,
  required int steps,
  required String valueText,
  required ValueChanged<double> onChanged,
}) {
  return MiuixSliderPreference(
    title: title,
    insideMargin: _kCompactRowMargin,
    startAction: miuixSettingsIcon(context, iconName, fallback: fallbackIcon),
    value: value,
    min: min,
    max: max,
    steps: 0,
    showKeyPoints: false,
    valueText: valueText,
    onValueChange: onChanged,
  );
}

MiuixBasicComponent miuixInfoPreference({
  required BuildContext context,
  required String title,
  required String iconName,
  MiuixVectorIcon? fallbackIcon,
  String? summary,
  Widget? endAction,
  VoidCallback? onClick,
}) {
  return MiuixBasicComponent(
    title: title,
    summary: summary,
    insideMargin: _kCompactRowMargin,
    startAction: miuixSettingsIcon(context, iconName, fallback: fallbackIcon),
    endActions: [if (endAction != null) endAction],
    onClick: onClick,
  );
}
