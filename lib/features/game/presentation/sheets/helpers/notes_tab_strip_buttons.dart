import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Trailing chip that appends a new note tab.
class AddNoteTabChip extends StatelessWidget {
  const AddNoteTabChip({
    super.key,
    required this.colors,
    required this.tooltip,
    required this.size,
    required this.onTap,
  });

  final ColorScheme colors;
  final String tooltip;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 22,
            color: colors.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Collapses or expands the note tab strip so the editor can reclaim the room.
class NoteTabCollapseButton extends StatelessWidget {
  const NoteTabCollapseButton({
    super.key,
    required this.colors,
    required this.isCollapsed,
    required this.size,
    required this.onPressed,
  });

  final ColorScheme colors;
  final bool isCollapsed;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 180),
          // The strip folds horizontally, so the affordance points sideways.
          turns: isCollapsed ? 0.5 : 0,
          child: Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 22,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
