import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../theme/glass_effect.dart';

/// Item descriptor for [MiuixNavBar], matching KoWSU `BottomBarMiuix.kt`
/// (`Icons.Rounded.Cottage`, `Icons.Rounded.Extension`, `Icons.Rounded.Settings`).
class MiuixNavBarItem {
  const MiuixNavBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.showBadge = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool showBadge;
}

/// Classic MIUI docked bottom navigation bar backed by Compose Miuix
/// [MiuixNavigationBar] and [MiuixNavigationBarItem].
class MiuixNavBar extends StatelessWidget {
  const MiuixNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.blurEnabled = false,
    this.blurPercent = 70.0,
  });

  final List<MiuixNavBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool blurEnabled;
  final double blurPercent;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;
    final activeIndex = selectedIndex.clamp(0, items.length - 1);

    final navColors = MiuixNavigationBarColors(
      background: blurEnabled
          ? GlassEffect.getBackgroundColor(
              context,
              enabled: true,
              percent: blurPercent,
              baseColor: colors.surface,
            )
          : colors.surface,
      floatingBackground: colors.surfaceContainer,
      content: colors.onSurface,
      divider: colors.dividerLine,
    );

    final bar = MiuixNavigationBar(
      color: blurEnabled ? Colors.transparent : colors.surface,
      colors: navColors,
      showDivider: true,
      defaultWindowInsetsPadding: true,
      mode: MiuixNavigationBarDisplayMode.iconAndText,
      children: [
        for (var i = 0; i < items.length; i++)
          MiuixNavigationBarItem(
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
            badge: items[i].showBadge ? const MiuixBadge() : null,
          ),
      ],
    );

    if (!blurEnabled) return bar;

    return GlassEffect.wrap(
      context,
      enabled: true,
      percent: blurPercent,
      baseColor: colors.surface,
      child: bar,
    );
  }
}
