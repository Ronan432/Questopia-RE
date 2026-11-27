import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../helpers/platform_helper.dart';

/// Rounded frame around the whole desktop window.
///
/// The desktop window is created without native decorations, so nothing draws
/// rounded corners and nothing offers resize grips. This widget clips the app
/// to a rounded surface, paints a thin outline while the window is floating,
/// and restores the eight resize edges of a normal window. A maximized or full
/// screen window drops the radius and the grips, exactly like a native frame.
class DesktopWindowFrame extends StatefulWidget {
  const DesktopWindowFrame({super.key, required this.child});

  final Widget child;

  static const double _radius = 14;

  @override
  State<DesktopWindowFrame> createState() => _DesktopWindowFrameState();
}

class _DesktopWindowFrameState extends State<DesktopWindowFrame>
    with WindowListener {
  bool _isMaximized = false;
  bool _isFullScreen = false;

  bool get _isFloating => !_isMaximized && !_isFullScreen;

  @override
  void initState() {
    super.initState();
    if (!isDesktopPlatform) return;
    windowManager.addListener(this);
    _syncWindowState();
  }

  @override
  void dispose() {
    if (isDesktopPlatform) windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _syncWindowState() async {
    try {
      final maximized = await windowManager.isMaximized();
      final fullScreen = await windowManager.isFullScreen();
      if (!mounted) return;
      setState(() {
        _isMaximized = maximized;
        _isFullScreen = fullScreen;
      });
    } catch (_) {
      // The window channel is unavailable in tests and on unsupported hosts.
    }
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  @override
  void onWindowEnterFullScreen() => setState(() => _isFullScreen = true);

  @override
  void onWindowLeaveFullScreen() => setState(() => _isFullScreen = false);

  @override
  Widget build(BuildContext context) {
    if (!isDesktopPlatform) return widget.child;

    final borderColor =
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6);
    final radius = BorderRadius.circular(
      _isFloating ? DesktopWindowFrame._radius : 0,
    );

    return DragToResizeArea(
      enableResizeEdges: _isFloating ? null : const <ResizeEdge>[],
      resizeEdgeSize: 8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: _isFloating ? borderColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: ClipRRect(borderRadius: radius, child: widget.child),
      ),
    );
  }
}
