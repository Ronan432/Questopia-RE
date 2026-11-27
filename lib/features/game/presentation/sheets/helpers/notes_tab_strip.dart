import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../data/note_tab.dart';
import 'notes_tab_strip_buttons.dart';

/// Horizontally scrollable tab strip for the notes sheet.
///
/// It is a plain widget rather than a [TabBar] because the tabs are user
/// created and reorderable by persistence order, not a fixed route-level set.
/// Tapping a tab selects it, long pressing renames it, a middle click or the
/// close affordance removes it, and the trailing chip adds a new one.
///
/// Once the tabs no longer fit, the strip keeps the full tab size and scrolls
/// rather than shrinking every label, and it can be folded down to the active
/// tab alone through [onToggleCollapsed].
class NotesTabStrip extends StatelessWidget {
  const NotesTabStrip({
    super.key,
    required this.tabs,
    required this.selectedId,
    required this.onSelect,
    required this.onRename,
    required this.onDelete,
    required this.onAdd,
    required this.addTooltip,
    required this.renameTooltip,
    required this.deleteTooltip,
    this.isCollapsed = false,
    this.onToggleCollapsed,
    this.maxTabWidth = 220,
  });

  final List<NoteTab> tabs;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final ValueChanged<NoteTab> onRename;
  final ValueChanged<NoteTab> onDelete;
  final VoidCallback onAdd;
  final String addTooltip;
  final String renameTooltip;
  final String deleteTooltip;

  /// When true only the active tab is drawn, so the editor keeps the space.
  final bool isCollapsed;
  final VoidCallback? onToggleCollapsed;

  /// Upper bound for a single tab, reached only when few tabs are open.
  final double maxTabWidth;

  static const double _stripHeight = 46;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visibleTabs = isCollapsed
        ? tabs.where((tab) => tab.id == selectedId).toList()
        : tabs;

    return SizedBox(
      height: _stripHeight,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: visibleTabs.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == visibleTabs.length) {
                  return AddNoteTabChip(
                    colors: colors,
                    tooltip: addTooltip,
                    size: _stripHeight,
                    onTap: onAdd,
                  );
                }
                final tab = visibleTabs[index];
                return _NoteTabChip(
                  tab: tab,
                  isSelected: tab.id == selectedId,
                  colors: colors,
                  renameTooltip: renameTooltip,
                  deleteTooltip: deleteTooltip,
                  maxWidth: maxTabWidth,
                  onSelect: () => onSelect(tab.id),
                  onRename: () => onRename(tab),
                  onDelete: () => onDelete(tab),
                );
              },
            ),
          ),
          if (onToggleCollapsed != null && tabs.length > 1) ...[
            const SizedBox(width: 8),
            NoteTabCollapseButton(
              colors: colors,
              isCollapsed: isCollapsed,
              size: _stripHeight,
              onPressed: onToggleCollapsed!,
            ),
          ],
        ],
      ),
    );
  }
}

/// One selectable note tab, with rename on long press and a close affordance.
///
/// A middle click closes the tab as well, matching the browser convention the
/// strip imitates; the same gesture is what a desktop reader reaches for.
class _NoteTabChip extends StatelessWidget {
  const _NoteTabChip({
    required this.tab,
    required this.isSelected,
    required this.colors,
    required this.renameTooltip,
    required this.deleteTooltip,
    required this.maxWidth,
    required this.onSelect,
    required this.onRename,
    required this.onDelete,
  });

  final NoteTab tab;
  final bool isSelected;
  final ColorScheme colors;
  final String renameTooltip;
  final String deleteTooltip;
  final double maxWidth;
  final VoidCallback onSelect;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final title = tab.title.trim().isEmpty ? renameTooltip : tab.title;
    final miuix = MiuixTheme.of(context);
    final mColors = miuix.colors;
    final shape = MiuixSquircleBorder(
      cornerRadius: 16,
      side: BorderSide(
        color: isSelected
            ? mColors.primary.withValues(alpha: 0.55)
            : mColors.outline.withValues(alpha: 0.2),
        width: 1,
      ),
    );

    return Listener(
      onPointerDown: (event) {
        if (event.buttons == kMiddleMouseButton) {
          HapticFeedback.selectionClick();
          onDelete();
        }
      },
      child: Tooltip(
        message: title,
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onRename();
          },
          child: MiuixPressable(
            onPressed: () {
              HapticFeedback.selectionClick();
              onSelect();
            },
            shape: MiuixSquircleBorder(cornerRadius: 16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.only(left: 14, right: 6),
              constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 96),
              decoration: ShapeDecoration(
                color: isSelected
                    ? mColors.secondaryContainer
                    : mColors.surfaceContainerHigh,
                shape: shape,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: MiuixText(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: miuix.textStyles.footnote1.copyWith(
                        fontSize: 14.5,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? mColors.onSecondaryContainer
                            : mColors.onSurfaceVariantSummary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _TabDeleteButton(
                    colors: colors,
                    tooltip: deleteTooltip,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Control that removes a single note tab.
class _TabDeleteButton extends StatelessWidget {
  const _TabDeleteButton({
    required this.colors,
    required this.tooltip,
    required this.onPressed,
  });

  final ColorScheme colors;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final mColors = MiuixTheme.of(context).colors;
    return Tooltip(
      message: tooltip,
      child: MiuixPressable(
        onPressed: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        shape: MiuixSquircleBorder(cornerRadius: 12),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color: mColors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
