import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../../core/theme/miuix_icons_helper.dart';
import 'game_card_frame.dart';

class AdaptiveGameCardFrame extends StatelessWidget {
  const AdaptiveGameCardFrame({
    super.key,
    required this.miuix,
    required this.posterWidget,
    required this.titleWidget,
    required this.subtitleWidget,
    required this.actionsWidget,
    this.onTap,
    this.onLongPress,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  });

  final bool miuix;
  final Widget posterWidget;
  final Widget titleWidget;
  final Widget subtitleWidget;
  final Widget actionsWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    if (!miuix) {
      return GameCardFrame(
        posterWidget: posterWidget,
        titleWidget: titleWidget,
        subtitleWidget: subtitleWidget,
        actionsWidget: actionsWidget,
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: contentPadding,
      );
    }

    return MiuixCard(
      onPressed: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          posterWidget,
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleWidget,
                      const SizedBox(height: 1),
                      subtitleWidget,
                    ],
                  ),
                  actionsWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptiveGameActionButton extends StatelessWidget {
  const AdaptiveGameActionButton({
    super.key,
    required this.miuix,
    this.icon,
    this.miuixIconVector,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final bool miuix;
  final IconData? icon;
  final MiuixVectorIcon? miuixIconVector;
  final String label;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!miuix) {
      return M3EButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, size: compact ? 16 : 18)
            : MiuixIcon(
                vector: miuixIconVector ?? MiuixIcons.os4.play,
                size: compact ? 16 : 18,
              ),
        label: Text(label, style: TextStyle(fontSize: compact ? 11.5 : 13)),
        style: M3EButtonStyle.filled,
        size: M3EButtonSize.sm,
        shape: M3EButtonShape.round,
      );
    }

    final miuixTheme = MiuixTheme.of(context);
    return MiuixButton(
      onPressed: onPressed,
      colors: MiuixButtonDefaults.buttonColorsPrimary(context),
      minHeight: compact ? 32 : 36,
      insideMargin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiuixIcon(
            vector: miuixIconVector ?? miuixVector('download', fallback: MiuixIcons.os4.play),
            size: compact ? 15 : 17,
            tint: miuixTheme.colors.onPrimary,
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: compact ? 11.5 : 13)),
        ],
      ),
    );
  }
}
