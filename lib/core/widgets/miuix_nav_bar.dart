import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';

import '../theme/glass_effect.dart';

class MiuixNavBarItem {
  const MiuixNavBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.showBadge = false,
  });

  final MiuixVectorIcon icon;
  final MiuixVectorIcon? activeIcon;
  final String label;
  final bool showBadge;
}

/// Floating Miuix bottom navigation bar with advanced-texture blur,
/// tap/swipe haptics, and 10% active-pill shrink on press or drag.
class MiuixNavBar extends StatefulWidget {
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
  State<MiuixNavBar> createState() => _MiuixNavBarState();
}

class _MiuixNavBarState extends State<MiuixNavBar> {
  static const double _barHeight = 62.0;
  bool _isInteracting = false;

  int _indexForDx(double dx, double totalWidth) {
    if (widget.items.isEmpty || totalWidth <= 0) return 0;
    final itemWidth = totalWidth / widget.items.length;
    return (dx / itemWidth).floor().clamp(0, widget.items.length - 1);
  }

  void _setInteracting(bool value) {
    if (_isInteracting == value) return;
    setState(() => _isInteracting = value);
  }

  void _selectIndex(int index) {
    if (index < 0 || index >= widget.items.length) return;
    HapticFeedback.selectionClick();
    if (index != widget.selectedIndex) {
      widget.onSelect(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;
    final isDark = miuix.brightness == Brightness.dark;

    final shape = MiuixSquircleBorder(
      cornerRadius: 28,
      side: BorderSide(
        color: colors.outline.withValues(alpha: isDark ? 0.28 : 0.16),
        width: 0.75,
      ),
    );

    final baseSurface = isDark
        ? colors.surfaceContainerHigh
        : colors.surfaceContainer;

    final pillColor = _isInteracting
        ? colors.primary.withValues(alpha: isDark ? 0.24 : 0.18)
        : colors.primary.withValues(alpha: isDark ? 0.16 : 0.12);

    return GlassEffect.wrap(
      context,
      enabled: widget.blurEnabled,
      percent: widget.blurPercent,
      baseColor: baseSurface,
      shape: shape,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      child: SizedBox(
        height: _barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final itemWidth = totalWidth / widget.items.length;
            final activeIndex =
                widget.selectedIndex.clamp(0, widget.items.length - 1);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                final idx = _indexForDx(details.localPosition.dx, totalWidth);
                if (idx == activeIndex) {
                  _setInteracting(true);
                }
              },
              onTapUp: (details) {
                _setInteracting(false);
                final idx = _indexForDx(details.localPosition.dx, totalWidth);
                _selectIndex(idx);
              },
              onTapCancel: () => _setInteracting(false),
              onLongPressStart: (details) {
                final idx = _indexForDx(details.localPosition.dx, totalWidth);
                if (idx != activeIndex) {
                  _selectIndex(idx);
                }
                _setInteracting(true);
              },
              onLongPressEnd: (_) => _setInteracting(false),
              onHorizontalDragStart: (details) {
                _setInteracting(true);
                final idx = _indexForDx(details.localPosition.dx, totalWidth);
                if (idx != activeIndex) {
                  _selectIndex(idx);
                }
              },
              onHorizontalDragUpdate: (details) {
                final idx = _indexForDx(details.localPosition.dx, totalWidth);
                if (idx != widget.selectedIndex) {
                  _selectIndex(idx);
                }
              },
              onHorizontalDragEnd: (_) => _setInteracting(false),
              onHorizontalDragCancel: () => _setInteracting(false),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    left: activeIndex * itemWidth,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: Center(
                      child: AnimatedScale(
                        scale: _isInteracting ? 0.90 : 1.0,
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 5,
                          ),
                          decoration: ShapeDecoration(
                            color: pillColor,
                            shape: MiuixSquircleBorder(cornerRadius: 22),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < widget.items.length; i++)
                        Expanded(
                          child: _NavBarItemContent(
                            item: widget.items[i],
                            selected: i == activeIndex,
                            colors: colors,
                            textStyles: miuix.textStyles,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavBarItemContent extends StatelessWidget {
  const _NavBarItemContent({
    required this.item,
    required this.selected,
    required this.colors,
    required this.textStyles,
  });

  final MiuixNavBarItem item;
  final bool selected;
  final MiuixColors colors;
  final MiuixTextStyles textStyles;

  @override
  Widget build(BuildContext context) {
    final tint = selected ? colors.primary : colors.onSurfaceVariantActions;
    final vector = selected ? (item.activeIcon ?? item.icon) : item.icon;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              MiuixIcon(
                vector: vector,
                size: 22,
                tint: tint,
              ),
              if (item.showBadge)
                Positioned(
                  right: -4,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          MiuixText(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyles.footnote2.copyWith(
              color: tint,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
