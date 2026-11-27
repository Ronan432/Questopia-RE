import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../l10n/app_localizations.dart';

export '../widgets/questopia_morph_button.dart';

/// Shows a declarative Compose-Miuix [MiuixOverlayDialog] hosted inside a
/// transparent route so existing `Navigator.pop` callers work unchanged.
Future<T?> showQuestopiaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  final capturedThemes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: useRootNavigator).context,
  );

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    _MiuixOverlayDialogRoute<T>(
      capturedThemes: capturedThemes,
      builder: builder,
      barrierDismissible: barrierDismissible,
    ),
  );
}

class _MiuixOverlayDialogRoute<T> extends PageRoute<T> {
  _MiuixOverlayDialogRoute({
    required this.capturedThemes,
    required this.builder,
    required this.barrierDismissible,
  });

  final CapturedThemes capturedThemes;
  final WidgetBuilder builder;
  @override
  final bool barrierDismissible;

  final ValueNotifier<bool> _showNotifier = ValueNotifier<bool>(false);
  bool _disposed = false;

  @override
  bool get opaque => false;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 220);

  @override
  TickerFuture didPush() {
    final future = super.didPush();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) _showNotifier.value = true;
    });
    return future;
  }

  @override
  bool didPop(T? result) {
    _showNotifier.value = false;
    return super.didPop(result);
  }

  @override
  void dispose() {
    _disposed = true;
    _showNotifier.dispose();
    super.dispose();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return capturedThemes.wrap(
      MiuixPopupScope(
        establishRoot: true,
        child: Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _showNotifier,
              builder: (hostCtx, show, _) {
                return MiuixOverlayDialog(
                  show: show,
                  insideMargin: const Size(20, 20),
                  onDismissRequest: barrierDismissible
                      ? () => Navigator.of(hostCtx).maybePop()
                      : null,
                  content: Builder(builder: builder),
                );
              },
            ),
            const MiuixPopupHost(),
          ],
        ),
      ),
    );
  }
}

/// Unified Miuix modal dialog content frame hosted inside [MiuixOverlayDialog].
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
    final onSurface = colors?.onSurface ?? themeColors.onSurface;
    final primary = colors?.primary ?? themeColors.primary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 260,
      ),
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
              textAlign: TextAlign.center,
              child: title!,
            ),
            const SizedBox(height: 12),
          ],
          // The hosting Miuix dialog measures its children with an unbounded
          // main axis, so a Flexible child cannot shrink there and a long
          // message overflows the panel. A bounded scroll area keeps any
          // content inside the dialog.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  (MediaQuery.sizeOf(context).height * 0.3).clamp(120.0, 340.0),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: content,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                for (var i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: actions![i]),
                ],
              ],
            ),
          ],
        ],
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
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          minHeight: 46,
          cornerRadius: 16,
          insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(resolvedCancelLabel),
        ),
        MiuixButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
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
          minHeight: 46,
          cornerRadius: 16,
          insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(resolvedConfirmLabel),
        ),
      ],
    );
  }
}
