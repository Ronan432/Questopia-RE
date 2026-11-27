import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';

/// KoWSU-inspired (`HomeMiuix.kt`) 2-card bento hero row for the Home tab:
/// Installed Games (green status card) + Favorites toggle card, with instant
/// touch-point 3D tilt matching `PressFeedback.kt`.
class MiuixHomeHero extends StatelessWidget {
  const MiuixHomeHero({
    super.key,
    required this.gamesCount,
    required this.favoriteCount,
    required this.showFavoritesOnly,
    required this.onToggleFavoritesOnly,
    this.onDeleteAll,
  });

  final int gamesCount;
  final int favoriteCount;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavoritesOnly;
  final VoidCallback? onDeleteAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;
    final isDark = colors.background.computeLuminance() < 0.5;
    final hasGames = gamesCount > 0;
    final statusColor = isDark
        ? const Color(0xFF1A3825)
        : const Color(0xFFDFFAE4);
    final statusIconTint = hasGames
        ? const Color(0xFF36D167).withValues(alpha: 0.35)
        : colors.onSurfaceVariantActions.withValues(alpha: 0.16);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _KoWsuTiltCard(
              onTap: onDeleteAll ?? () {},
              child: MiuixCard(
                cornerRadius: 20,
                colors: hasGames
                    ? MiuixCardColors(
                        color: statusColor,
                        contentColor: colors.onSurface,
                      )
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -24,
                        bottom: -28,
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 124,
                          color: statusIconTint,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MiuixText(
                              l10n.installedGames,
                              style: miuix.textStyles.body2.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colors.onSurfaceVariantSummary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            MiuixText(
                              '$gamesCount',
                              style: miuix.textStyles.title2.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _KoWsuTiltCard(
              onTap: onToggleFavoritesOnly,
              child: MiuixCard(
                cornerRadius: 20,
                colors: showFavoritesOnly
                    ? MiuixCardColors(
                        color: isDark
                            ? const Color(0xFF3A1A20)
                            : const Color(0xFFFFE4E8),
                        contentColor: colors.onSurface,
                      )
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -24,
                        bottom: -28,
                        child: Icon(
                          showFavoritesOnly
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 124,
                          color: showFavoritesOnly
                              ? const Color(0xFFE53935).withValues(alpha: 0.42)
                              : colors.onSurfaceVariantActions
                                  .withValues(alpha: 0.16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MiuixText(
                              l10n.favoriteGames,
                              style: miuix.textStyles.body2.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: showFavoritesOnly
                                    ? (isDark
                                        ? const Color(0xFFFFB4AB)
                                        : const Color(0xFFB3261E))
                                    : colors.onSurfaceVariantSummary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            MiuixText(
                              '$favoriteCount',
                              style: miuix.textStyles.title2.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KoWsuTiltCard extends StatefulWidget {
  const _KoWsuTiltCard({
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_KoWsuTiltCard> createState() => _KoWsuTiltCardState();
}

class _KoWsuTiltCardState extends State<_KoWsuTiltCard>
    with TickerProviderStateMixin {
  late final AnimationController _tiltX =
      AnimationController.unbounded(vsync: this);
  late final AnimationController _tiltY =
      AnimationController.unbounded(vsync: this);
  late final AnimationController _scale =
      AnimationController.unbounded(vsync: this)..value = 1.0;
  Alignment _origin = Alignment.center;
  Size _size = Size.zero;
  DateTime? _downAt;
  bool _isPressed = false;

  static final SpringDescription _pressSpring =
      SpringDescription.withDampingRatio(mass: 1.0, stiffness: 180.0, ratio: 0.72);
  static final SpringDescription _releaseSpring =
      SpringDescription.withDampingRatio(mass: 1.0, stiffness: 220.0, ratio: 0.78);

  @override
  void dispose() {
    _tiltX.dispose();
    _tiltY.dispose();
    _scale.dispose();
    super.dispose();
  }

  void _animateTo(double tx, double ty, double scale, SpringDescription spring) {
    _tiltX.animateWith(
      SpringSimulation(spring, _tiltX.value, tx, 0),
    );
    _tiltY.animateWith(
      SpringSimulation(spring, _tiltY.value, ty, 0),
    );
    _scale.animateWith(
      SpringSimulation(spring, _scale.value, scale, 0),
    );
  }

  void _onDown(PointerDownEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    _size = box.size;
    final nx = (_size.width > 0 ? event.localPosition.dx / _size.width : 0.5)
        .clamp(0.0, 1.0);
    final ny = (_size.height > 0 ? event.localPosition.dy / _size.height : 0.5)
        .clamp(0.0, 1.0);

    // Anchor opposite edge/corner and swing the pressed area deep into the
    // screen with a softer spring so the sink feels substantial and physical.
    final dx = (nx - 0.5) * 2.0;
    final dy = (ny - 0.5) * 2.0;
    _origin = Alignment(-dx, -dy);
    const maxRad = 0.16;
    final tx = dy * maxRad;
    final ty = -dx * maxRad;
    _isPressed = true;
    _downAt = DateTime.now();
    _animateTo(tx, ty, 0.945, _pressSpring);
  }

  void _onRelease() {
    _isPressed = false;
    final downAt = _downAt;
    final elapsedMs = downAt == null
        ? 999
        : DateTime.now().difference(downAt).inMilliseconds;
    const minPressMs = 160;
    if (elapsedMs < minPressMs) {
      Future<void>.delayed(Duration(milliseconds: minPressMs - elapsedMs), () {
        if (mounted && !_isPressed) {
          _animateTo(0.0, 0.0, 1.0, _releaseSpring);
        }
      });
    } else {
      _animateTo(0.0, 0.0, 1.0, _releaseSpring);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onDown,
      onPointerUp: (_) => _onRelease(),
      onPointerCancel: (_) => _onRelease(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_tiltX, _tiltY, _scale]),
          builder: (context, child) {
            final s = _scale.value;
            final matrix = Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateX(_tiltX.value)
              ..rotateY(_tiltY.value)
              ..scaleByDouble(s, s, 1.0, 1.0);
            return Transform(
              alignment: _origin,
              transform: matrix,
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
