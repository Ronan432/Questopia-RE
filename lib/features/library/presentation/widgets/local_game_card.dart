import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/duration_format.dart';
import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/local_game.dart';
import '../../data/play_stats_store.dart';
import '../../providers/play_stats_provider.dart';
import 'game_card_frame.dart';
import 'game_poster.dart';

class LocalGameCard extends ConsumerWidget {
  const LocalGameCard({
    super.key,
    required this.game,
    required this.onPlay,
    required this.onRemove,
    required this.onToggleFavorite,
    this.isCompact = false,
  });

  final LocalGame game;
  final VoidCallback onPlay;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;
  final bool isCompact;

  Future<void> _showMenuSheet(
    BuildContext context,
    WidgetRef ref,
    PlayStats playStats,
  ) async {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    await showQuestopiaSheet<void>(
      context: context,
      builder: (sheetCtx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: GamePoster(
                          localPath: game.posterPath,
                          isLocal: true,
                          title: game.title,
                          height: 44,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            game.author.isNotEmpty
                                ? game.author
                                : l10n.qspInteractiveFiction,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SegmentedListSection(
                children: [
                  SegmentedListTile(
                    leading: Icon(
                      Icons.play_arrow_rounded,
                      color: colors.primary,
                      size: 24,
                    ),
                    title: Text(
                      l10n.play,
                      style: const TextStyle(fontSize: 16),
                    ),
                    minVerticalPadding: 16,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(sheetCtx);
                      onPlay();
                    },
                  ),
                  // Play statistics are informational: the tile renders without
                  // a tap handler and stays hidden until the game has actually
                  // been played, so unused games keep a short menu.
                  if (playStats.hasPlayed)
                    SegmentedListTile(
                      leading: Icon(
                        Icons.schedule_rounded,
                        color: colors.onSurfaceVariant,
                        size: 24,
                      ),
                      title: Text(
                        l10n.playStatsTotal,
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        formatPlayDuration(
                          l10n,
                          Duration(seconds: playStats.totalSeconds),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      trailing: Text(
                        playStats.lastPlayed == null
                            ? l10n.neverPlayed
                            : formatLastPlayedDate(playStats.lastPlayed!),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      minVerticalPadding: 12,
                    ),
                  SegmentedListTile(
                    leading: Icon(
                      game.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: game.isFavorite ? colors.error : null,
                      size: 24,
                    ),
                    title: Text(
                      game.isFavorite
                          ? l10n.removeFromFavorites
                          : l10n.addToFavorites,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: game.isFavorite
                        ? Icon(Icons.check_circle_rounded,
                            color: colors.primary)
                        : null,
                    minVerticalPadding: 16,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(sheetCtx);
                      onToggleFavorite();
                    },
                  ),
                  SegmentedListTile(
                    leading: Icon(
                      game.isFromRepo
                          ? Icons.delete_forever_rounded
                          : Icons.delete_outline_rounded,
                      color: colors.error,
                      size: 24,
                    ),
                    title: Text(
                      game.isFromRepo ? l10n.deleteGame : l10n.removeFromLibrary,
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.error,
                      ),
                    ),
                    minVerticalPadding: 16,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      Navigator.pop(sheetCtx);
                      final isRepo = game.isFromRepo;
                      final confirmed = await showQuestopiaDialog<bool>(
                        context: context,
                        builder: (ctx) => QuestopiaConfirmationDialog(
                          icon: isRepo
                              ? Icons.delete_forever_rounded
                              : Icons.delete_outline_rounded,
                          isDestructive: true,
                          title: isRepo ? l10n.deleteGameTitle : l10n.removeFromLibrary,
                          message: isRepo
                              ? l10n.deleteGameMessage(game.title)
                              : l10n.removeFromLibraryMessage(game.title),
                          confirmLabel: isRepo ? l10n.delete : l10n.remove,
                          cancelLabel: l10n.cancel,
                        ),
                      );
                      if (confirmed == true) {
                        onRemove();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    // Unknown stats (still loading, or no entry yet) collapse to empty stats so
    // the menu renders the same shape with the statistics row hidden.
    final playStats =
        ref.watch(playStatsProvider(game.id)).valueOrNull ?? const PlayStats();

    return GameCardFrame(
      contentPadding: isCompact
          ? const EdgeInsets.fromLTRB(8, 6, 8, 6)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onTap: () => _showMenuSheet(context, ref, playStats),
      posterWidget: GamePoster(
        localPath: game.posterPath,
        isLocal: true,
        title: game.title,
        height: isCompact ? 86 : 116,
      ),
      titleWidget: Text(
        game.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isCompact ? 13 : 14.5,
          color: colors.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitleWidget: Text(
        game.author.isNotEmpty ? game.author : l10n.qspInteractiveFiction,
        style: TextStyle(
          fontSize: isCompact ? 10.5 : 11.5,
          color: colors.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actionsWidget: SizedBox(
        width: double.infinity,
        child: M3EButton.icon(
          onPressed: onPlay,
          icon: Icon(Icons.play_arrow_rounded, size: isCompact ? 16 : 18),
          label: Text(
            l10n.play,
            style: TextStyle(fontSize: isCompact ? 11.5 : 13),
          ),
          style: M3EButtonStyle.filled,
          size: M3EButtonSize.sm,
          shape: M3EButtonShape.round,
        ),
      ),
    );
  }
}
