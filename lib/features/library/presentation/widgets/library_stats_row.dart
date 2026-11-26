import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/local_game.dart';
import '../../providers/library_provider.dart';

/// A pair of summary tiles shown above the library grid, with inline accordion expansion.
class LibraryStatsRow extends ConsumerStatefulWidget {
  const LibraryStatsRow({
    super.key,
    required this.games,
    required this.showFavoritesOnly,
    required this.onToggleFavoritesOnly,
    this.miuix = false,
  });

  final List<LocalGame> games;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavoritesOnly;
  final bool miuix;

  @override
  ConsumerState<LibraryStatsRow> createState() => _LibraryStatsRowState();
}

class _LibraryStatsRowState extends ConsumerState<LibraryStatsRow>
    with SingleTickerProviderStateMixin {
  /// Drives the panel reveal. It runs forward to unfold and backward to fold,
  /// so the fold visually retraces the unfold instead of snapping shut.
  late final AnimationController _panelController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 240),
  );

  late final Animation<double> _panelCurve = CurvedAnimation(
    parent: _panelController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  bool get _isExpanded => _panelController.status == AnimationStatus.forward ||
      _panelController.status == AnimationStatus.completed;

  int get _favoriteCount => widget.games.where((game) => game.isFavorite).length;

  /// Width the unfolded panel takes. It is spawned over the favorites tile
  /// rather than below the row, so it carries its own width instead of being
  /// stretched by the surrounding column.
  static const double _panelWidth = 300;

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    HapticFeedback.lightImpact();
    if (_isExpanded) {
      _panelController.reverse();
    } else {
      _panelController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    if (widget.miuix) {
      return _MiuixStatsRow(
        gamesCount: widget.games.length,
        favoriteCount: _favoriteCount,
        showFavoritesOnly: widget.showFavoritesOnly,
        onToggleFavoritesOnly: widget.onToggleFavoritesOnly,
        onDeleteAll: widget.games.isEmpty
            ? null
            : () async {
                final confirmed = await showQuestopiaDialog<bool>(
                  context: context,
                  builder: (ctx) => QuestopiaConfirmationDialog(
                    title: l10n.deleteAllGamesTitle,
                    message: l10n.deleteAllGamesMessage,
                    confirmLabel: l10n.delete,
                    cancelLabel: l10n.cancel,
                    isDestructive: true,
                    icon: Icons.delete_sweep_rounded,
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref.read(libraryProvider.notifier).removeAllGames();
                }
              },
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.library_books_outlined,
                label: l10n.installedGames,
                value: widget.games.length,
                highlighted: false,
                onTap: _togglePanel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _panelCurve,
                builder: (context, _) => _StatTile(
                  icon: Icons.favorite_rounded,
                  label: l10n.favoriteGames,
                  value: _favoriteCount,
                  // The unfolded panel is spawned directly on top of this tile,
                  // so it fades out behind the panel instead of being lost.
                  dimmed: _panelCurve.value,
                  highlighted: widget.showFavoritesOnly,
                  onTap: widget.onToggleFavoritesOnly,
                ),
              ),
            ),
          ],
        ),
        // The panel is anchored to the favorites tile and grows diagonally out
        // of its top right corner, covering that tile as it travels. It is
        // spawned over the row rather than pushed below it, which is what makes
        // it read as a drawer pulled open across the button.
        Positioned(
          top: 0,
          right: 0,
          child: _DiagonalReveal(
            progress: _panelCurve,
            child: SizedBox(
              width: _panelWidth,
              child: Material(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_open_rounded, color: colors.primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${widget.games.length} installed games in library',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.games.isNotEmpty)
                      QuestopiaMorphButton.filled(
                        isDestructive: true,
                        onPressed: () async {
                          final confirmed = await showQuestopiaDialog<bool>(
                            context: context,
                            builder: (ctx) => QuestopiaConfirmationDialog(
                              title: l10n.deleteAllGamesTitle,
                              message: l10n.deleteAllGamesMessage,
                              confirmLabel: l10n.delete,
                              cancelLabel: l10n.cancel,
                              isDestructive: true,
                              icon: Icons.delete_sweep_rounded,
                            ),
                          );
                          if (confirmed == true && context.mounted) {
                            await ref.read(libraryProvider.notifier).removeAllGames();
                            if (mounted) {
                              _panelController.reverse();
                            }
                          }
                        },
                        icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                        child: Text(l10n.deleteAll),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ],
    );
  }
}

/// Unfolds [child] diagonally out of the top right corner while it grows in
/// height, so the panel appears to be pulled out from behind the control it is
/// anchored to instead of simply fading into the row.
class _DiagonalReveal extends StatelessWidget {
  const _DiagonalReveal({required this.progress, required this.child});

  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      alignment: Alignment.topCenter,
      sizeFactor: progress,
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, inner) {
          final t = progress.value;
          return Opacity(
            // Fully visible early so the sliding surface never looks washed out.
            opacity: Curves.easeOut.transform(t.clamp(0.0, 1.0)),
            child: Transform(
              // Pivot on the corner it grows out of, so the panel fans open from
              // the top right the way a drawer hinged there would.
              alignment: Alignment.topRight,
              transform: Matrix4.identity()
                ..translateByDouble(
                  // Travels up and in from the right, the diagonal the drawer
                  // metaphor needs, and settles exactly over the tile.
                  (1.0 - t) * 48.0,
                  (1.0 - t) * -24.0,
                  0.0,
                  1.0,
                )
                ..scaleByDouble(0.94 + 0.06 * t, 0.94 + 0.06 * t, 1.0, 1.0),
              child: inner,
            ),
          );
        },
        child: child,
      ),
    );
  }
}

class _MiuixStatsRow extends StatelessWidget {
  const _MiuixStatsRow({
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          MiuixIcon(
            vector: MiuixIcons.os4.folder,
            size: 18,
            tint: colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MiuixText(
              '$gamesCount ${l10n.installedGames}',
              style: miuix.textStyles.subtitle.copyWith(
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MiuixButton(
            onPressed: onToggleFavoritesOnly,
            colors: showFavoritesOnly
                ? MiuixButtonDefaults.buttonColorsPrimary(context)
                : MiuixButtonDefaults.buttonColors(context),
            minHeight: 36,
            insideMargin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MiuixIcon(
                  vector: showFavoritesOnly
                      ? MiuixIcons.os4.favoritesFill
                      : MiuixIcons.os4.favorites,
                  size: 16,
                  tint: showFavoritesOnly
                      ? colors.onPrimary
                      : colors.onSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${l10n.favoriteGames} ($favoriteCount)',
                  style: miuix.textStyles.footnote1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: showFavoritesOnly
                        ? colors.onPrimary
                        : colors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onDeleteAll != null) ...[
            const SizedBox(width: 6),
            MiuixIconButton(
              onPressed: onDeleteAll,
              minWidth: 38,
              minHeight: 38,
              child: MiuixIcon(
                vector: MiuixIcons.os4.delete,
                size: 20,
                tint: colors.error,
                contentDescription: l10n.deleteAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
    this.dimmed = 0.0,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int value;
  final bool highlighted;

  /// How far the unfolding panel has travelled over this tile, 0 to 1. Used to
  /// fade the tile back so the panel reads as covering it.
  final double dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fade = (1.0 - dimmed * 0.55).clamp(0.0, 1.0);

    return Opacity(
      opacity: fade,
      child: Material(
        color: highlighted
            ? colors.secondaryContainer
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: highlighted ? colors.onSecondaryContainer : colors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$value',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: highlighted
                              ? colors.onSecondaryContainer
                              : colors.onSurface,
                        ),
                      ),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: highlighted
                              ? colors.onSecondaryContainer
                              : colors.onSurfaceVariant,
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
    );
  }
}
