import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../l10n/app_localizations.dart';

export '../widgets/questopia_morph_button.dart';

/// Shows a unified Miuix modal dialog with scale/fade and backdrop blur.
Future<T?> showQuestopiaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  final capturedThemes =
      InheritedTheme.capture(from: context, to: Navigator.of(context).context);
  final barrierLabel = AppLocalizations.of(context)?.dismiss ?? 'Dismiss';

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Colors.black.withValues(alpha: 0.50),
    useRootNavigator: useRootNavigator,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return capturedThemes.wrap(builder(dialogContext));
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: AnimatedBuilder(
          animation: curvedAnimation,
          builder: (context, _) {
            final scale =
                lerpDouble(0.92, 1.0, curvedAnimation.value) ?? 1.0;
            final sigma = curvedAnimation.value * 8.0;

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

/// Unified Miuix modal dialog frame with squircle geometry.
class QuestopiaDialog extends StatelessWidget {
  const QuestopiaDialog({
    super.key,
    this.icon,
    this.title,
    required this.content,
    this.actions,
    this.maxWidth = 320,
  });

  final Widget? icon;
  final Widget? title;
  final Widget content;
  final List<Widget>? actions;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.maybeOf(context);
    final colors = miuix?.colors;
    final themeColors = Theme.of(context).colorScheme;
    final bg = colors?.surfaceContainer ?? themeColors.surfaceContainer;
    final outline = colors?.outline ?? themeColors.outlineVariant;
    final onSurface = colors?.onSurface ?? themeColors.onSurface;
    final primary = colors?.primary ?? themeColors.primary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 260,
      ),
      child: Material(
        color: bg,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.32),
        shape: MiuixSquircleBorder(
          cornerRadius: 24,
          side: BorderSide(
            color: outline.withValues(alpha: 0.24),
            width: 0.75,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (icon != null) ...[
                Align(
                  alignment: Alignment.center,
                  child: IconTheme(
                    data: IconThemeData(
                      size: 26,
                      color: primary,
                    ),
                    child: icon!,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (title != null) ...[
                DefaultTextStyle(
                  style: (miuix?.textStyles.title4 ?? const TextStyle(fontSize: 17))
                      .copyWith(
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                  textAlign:
                      icon != null ? TextAlign.center : TextAlign.start,
                  child: title!,
                ),
                const SizedBox(height: 10),
              ],
              Flexible(
                child: SingleChildScrollView(
                  child: content,
                ),
              ),
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      actions![i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Specialized Miuix confirmation dialog for destructive or binary decisions.
class QuestopiaConfirmationDialog extends StatelessWidget {
  const QuestopiaConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    this.icon,
    this.miuixVectorIcon,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final IconData? icon;
  final MiuixVectorIcon? miuixVectorIcon;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.maybeOf(context);
    final colors = Theme.of(context).colorScheme;
    final primary = miuix?.colors.primary ?? colors.primary;
    final error = miuix?.colors.error ?? colors.error;
    final summaryColor =
        miuix?.colors.onSurfaceVariantSummary ?? colors.onSurfaceVariant;
    final l10n = AppLocalizations.of(context)!;
    final resolvedConfirmLabel = confirmLabel ?? l10n.confirm;
    final resolvedCancelLabel = cancelLabel ?? l10n.cancel;

    Widget? resolvedIcon;
    if (miuixVectorIcon != null) {
      resolvedIcon = MiuixIcon(
        vector: miuixVectorIcon,
        size: 26,
        tint: isDestructive ? error : primary,
      );
    } else if (icon != null) {
      resolvedIcon = MiuixIcon(
        vector: isDestructive ? MiuixIcons.os4.delete : MiuixIcons.os4.settings,
        size: 26,
        tint: isDestructive ? error : primary,
      );
    }

    return QuestopiaDialog(
      icon: resolvedIcon,
      title: Text(title),
      content: Text(
        message,
        style: (miuix?.textStyles.body2 ?? const TextStyle(fontSize: 14))
            .copyWith(color: summaryColor),
      ),
      actions: [
        MiuixButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop(false);
            }
          },
          minHeight: 38,
          insideMargin:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(resolvedCancelLabel),
        ),
        MiuixButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              Navigator.of(context).pop(true);
            }
          },
          colors: isDestructive
              ? MiuixButtonColors(
                  color: error,
                  contentColor: miuix?.colors.onError ?? colors.onError,
                  disabledColor: error.withValues(alpha: 0.38),
                  disabledContentColor:
                      (miuix?.colors.onError ?? colors.onError)
                          .withValues(alpha: 0.38),
                )
              : MiuixButtonDefaults.buttonColorsPrimary(context),
          minHeight: 38,
          insideMargin:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(resolvedConfirmLabel),
        ),
      ],
    );
  }
}
