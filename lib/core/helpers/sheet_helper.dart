import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';

import 'platform_helper.dart';

/// Shows a Modal Bottom Sheet with backdrop blur, constrained strictly so its
/// drag handle and top edges never cross or overlap the status bar or custom titlebar.
Future<T?> showQuestopiaSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool showDragHandle = true,
  bool useRootNavigator = true,
  Color? backgroundColor,
}) {
  final mediaQuery = MediaQuery.of(context);
  final showCustomTitleBar = isDesktopPlatform;
  final topPadding =
      mediaQuery.padding.top + (showCustomTitleBar ? 40.0 : 24.0);
  final maxSheetHeight = (mediaQuery.size.height - topPadding)
      .clamp(200.0, mediaQuery.size.height);
  final colors = Theme.of(context).colorScheme;
  final miuixColors = MiuixTheme.maybeOf(context)?.colors;
  final sheetBgColor =
      backgroundColor ?? miuixColors?.background ?? colors.surface;
  final isDark =
      ThemeData.estimateBrightnessForColor(sheetBgColor) == Brightness.dark;

  // A desktop window is far wider than a phone, and a bottom sheet stretched
  // across it turns into a full width panel that reads as a page rather than a
  // sheet. Clamping the width and centering keeps the phone proportions.
  final maxSheetWidth = isDesktopPlatform
      ? (mediaQuery.size.width * 0.6).clamp(360.0, 560.0)
      : mediaQuery.size.width;

  final capturedThemes =
      InheritedTheme.capture(from: context, to: Navigator.of(context).context);

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    _BlurredModalBottomSheetRoute<T>(
      capturedThemes: capturedThemes,
      isScrollControlled: isScrollControlled,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      modalBarrierColor: Colors.black.withValues(alpha: 0.35),
      backgroundColor: Colors.transparent,
      elevation: 0,
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
        maxWidth: maxSheetWidth,
      ),
      builder: (sheetContext) {
        final sheetMediaQuery = MediaQuery.of(sheetContext);
        final currentTopPadding =
            sheetMediaQuery.padding.top + (showCustomTitleBar ? 40.0 : 24.0);
        final currentMaxHeight =
            (sheetMediaQuery.size.height - currentTopPadding)
                .clamp(200.0, sheetMediaQuery.size.height);
        final currentMaxWidth = isDesktopPlatform
            ? (sheetMediaQuery.size.width * 0.6).clamp(360.0, 560.0)
            : sheetMediaQuery.size.width;

        final overlayStyle = SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: colors.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: currentMaxHeight,
              maxWidth: currentMaxWidth,
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              child: Container(
                decoration: BoxDecoration(
                  color: sheetBgColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showDragHandle) ...[
                        _InteractiveDragHandle(isDark: isDark),
                      ],
                      Flexible(
                        child: builder(sheetContext),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _BlurredModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _BlurredModalBottomSheetRoute({
    required super.builder,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.backgroundColor,
    super.elevation,
    super.shape,
    super.clipBehavior,
    super.modalBarrierColor,
    super.isDismissible = true,
    super.enableDrag = true,
    super.showDragHandle,
    super.isScrollControlled = false,
    super.settings,
    super.transitionAnimationController,
    super.anchorPoint,
    super.useSafeArea = false,
    super.constraints,
  });

  @override
  ImageFilter? get filter => ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0);
}

/// Centered Miuix style title row for modal bottom sheets.
class QuestopiaSheetHeaderPill extends StatelessWidget {
  const QuestopiaSheetHeaderPill({
    super.key,
    required this.title,
    this.icon,
    this.miuixVectorIcon,
  });

  final String title;
  final IconData? icon;
  final MiuixVectorIcon? miuixVectorIcon;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.maybeOf(context);
    final colors = Theme.of(context).colorScheme;
    final onSurface = miuix?.colors.onSurface ?? colors.onSurface;
    final primary = miuix?.colors.primary ?? colors.primary;
    final textStyle =
        (miuix?.textStyles.title4 ?? const TextStyle(fontSize: 17)).copyWith(
      fontWeight: FontWeight.w500,
      color: onSurface,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (miuixVectorIcon != null) ...[
            MiuixIcon(vector: miuixVectorIcon, size: 18, tint: primary),
            const SizedBox(width: 8),
          ] else if (icon != null) ...[
            Icon(icon, size: 18, color: primary),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveDragHandle extends StatefulWidget {
  const _InteractiveDragHandle({required this.isDark});

  final bool isDark;

  @override
  State<_InteractiveDragHandle> createState() => _InteractiveDragHandleState();
}

class _InteractiveDragHandleState extends State<_InteractiveDragHandle> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.20)
        : Colors.black.withValues(alpha: 0.20);
    final activeColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.35);

    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: SizedBox(
        height: 24,
        width: double.infinity,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: _isPressed ? 55 : 45,
            height: _isPressed ? 4.6 : 4,
            decoration: BoxDecoration(
              color: _isPressed ? activeColor : baseColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
