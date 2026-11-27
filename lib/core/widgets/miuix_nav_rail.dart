import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import 'miuix_nav_bar.dart';

/// Left-hand navigation rail shown by the Miuix shell on desktop windows.
///
/// It mirrors [MiuixNavBar] with the same [MiuixNavBarItem] descriptors, adds
/// the import entry as a trailing action, and keeps the collapsed Miuix rail
/// proportions from Compose `NavigationRail.kt`.
class MiuixNavRail extends StatelessWidget {
  const MiuixNavRail({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.importLabel,
    this.onImportGame,
  });

  final List<MiuixNavBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  /// Import entry shown after the navigation entries; omitted when null.
  final String? importLabel;
  final VoidCallback? onImportGame;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final activeIndex = selectedIndex.clamp(0, items.length - 1);

    return MiuixNavigationRail(
      showDivider: true,
      children: [
        for (var i = 0; i < items.length; i++)
          MiuixNavigationRailItem(
            selected: i == activeIndex,
            onPressed: () {
              if (i != activeIndex) onSelect(i);
            },
            icon: Icon(
              i == activeIndex
                  ? (items[i].activeIcon ?? items[i].icon)
                  : items[i].icon,
            ),
            label: items[i].label,
          ),
        if (importLabel != null && onImportGame != null)
          MiuixNavigationRailItem(
            selected: false,
            onPressed: onImportGame,
            icon: const Icon(Icons.add_rounded),
            label: importLabel!,
          ),
      ],
    );
  }
}
