import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

/// Helper functions returning [SegmentedListTile] for settings lists.
class SettingsTiles {
  const SettingsTiles._();

  static SegmentedListTile navTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    Color? leadingDot,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return SegmentedListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingDot != null) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: leadingDot,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
        ],
      ),
      minVerticalPadding: 18,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  static SegmentedListTile switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SegmentedListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: M3ESwitch(
        value: value,
        selectedIcon: const Icon(Icons.check, size: 16),
        onChanged: (val) {
          HapticFeedback.lightImpact();
          onChanged(val);
        },
      ),
      minVerticalPadding: 18,
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
    );
  }

  static SegmentedListTile sliderTile({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    ValueChanged<double>? onChangeEnd,
    int? divisions,
  }) {
    return SegmentedListTile(
      // Top alignment keeps the leading icon level with the label instead of
      // floating in the middle of the taller slider row.
      titleAlignment: ListTileTitleAlignment.top,
      leading: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, size: 24),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          // M3E draws the handle as a rounded 4x44 bar, the vertical mark the
          // design calls for, so the slider reserves about 44 logical pixels of
          // height on its own. The row only needs a small top inset; forcing a
          // fixed height here would clip the handle. The pressed handle width is
          // pinned to its resting width by QuestopiaTheme.sliderTheme, because
          // the stock transition narrows the bar to 2px on press, which reads as
          // the handle caving in under the cursor on desktop.
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: M3ESlider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              divisions: divisions,
              haptic: M3EHapticFeedback.light,
              onChangeEnd: onChangeEnd,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
      minVerticalPadding: 8,
    );
  }
}
