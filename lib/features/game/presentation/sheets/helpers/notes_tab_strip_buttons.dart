import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';

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
    final mColors = MiuixTheme.of(context).colors;
    return Tooltip(
      message: tooltip,
      child: MiuixPressable(
        onPressed: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        shape: MiuixSquircleBorder(cornerRadius: 16),
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: mColors.primaryContainer.withValues(alpha: 0.55),
            shape: MiuixSquircleBorder(
              cornerRadius: 16,
              side: BorderSide(
                color: mColors.primary.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20,
            color: mColors.onPrimaryContainer,
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
    final mColors = MiuixTheme.of(context).colors;
    return MiuixPressable(
      onPressed: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      shape: MiuixSquircleBorder(cornerRadius: 16),
      child: Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: mColors.surfaceContainerHigh,
          shape: MiuixSquircleBorder(
            cornerRadius: 16,
            side: BorderSide(
              color: mColors.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 180),
          // The strip folds horizontally, so the affordance points sideways.
          turns: isCollapsed ? 0.5 : 0,
          child: Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: mColors.onSurfaceVariantActions,
          ),
        ),
      ),
    );
  }
}
