import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/duration_format.dart';
import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/local_game.dart';
import '../../data/play_stats_store.dart';
import '../../providers/play_stats_provider.dart';
import 'game_poster.dart';
import 'miuix_game_card.dart';

class LocalGameCard extends ConsumerWidget {
  const LocalGameCard({
    super.key,
    required this.game,
    required this.onPlay,
    required this.onRemove,
    required this.onToggleFavorite,
    this.isCompact = false,
    this.miuix = false,
  });

  final LocalGame game;
  final VoidCallback onPlay;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;
  final bool isCompact;
  final bool miuix;

  Future<void> _showMenuSheet(
    BuildContext context,
    WidgetRef ref,
    PlayStats playStats,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (miuix) {
      final miuixTheme = MiuixTheme.of(context);
      final mColors = miuixTheme.colors;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: mColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetCtx) => MiuixTheme(
          data: miuixTheme,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                              style: miuixTheme.textStyles.title4.copyWith(
                                color: mColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              game.author.isNotEmpty
                                  ? game.author
                                  : l10n.qspInteractiveFiction,
                              style: miuixTheme.textStyles.body2.copyWith(
                                color: mColors.onSurfaceVariantSummary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  MiuixCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MiuixBasicComponent(
                          title: l10n.play,
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: mColors.primary,
                              size: 22,
                            ),
                          ),
                          onClick: () {
                            Navigator.pop(sheetCtx);
                            onPlay();
                          },
                        ),
                        if (playStats.hasPlayed) ...[
                          const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: MiuixHorizontalDivider(),
                          ),
                          MiuixBasicComponent(
                            title: l10n.playStatsTotal,
                            summary: formatPlayDuration(
                              l10n,
                              Duration(seconds: playStats.totalSeconds),
                            ),
                            startAction: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.schedule_rounded,
                                color: mColors.onSurfaceVariantActions,
                                size: 22,
                              ),
                            ),
                            endActions: [
                              Text(
                                playStats.lastPlayed == null
                                    ? l10n.neverPlayed
                                    : formatLastPlayedDate(
                                        playStats.lastPlayed!,
                                      ),
                                style: miuixTheme.textStyles.body2.copyWith(
                                  color: mColors.onSurfaceVariantSummary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: MiuixHorizontalDivider(),
                        ),
                        MiuixBasicComponent(
                          title: game.isFavorite
                              ? l10n.removeFromFavorites
                              : l10n.addToFavorites,
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              game.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: game.isFavorite
                                  ? mColors.error
                                  : mColors.onSurfaceVariantActions,
                              size: 22,
                            ),
                          ),
                          onClick: () {
                            Navigator.pop(sheetCtx);
                            onToggleFavorite();
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: MiuixHorizontalDivider(),
                        ),
                        MiuixBasicComponent(
                          title: game.isFromRepo
                              ? l10n.deleteGame
                              : l10n.removeFromLibrary,
                          titleColor: MiuixBasicComponentColors(
                            color: mColors.error,
                            disabledColor: mColors.disabledOnSurface,
                          ),
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              game.isFromRepo
                                  ? Icons.delete_forever_rounded
                                  : Icons.delete_outline_rounded,
                              color: mColors.error,
                              size: 22,
                            ),
                          ),
                          onClick: () async {
                            Navigator.pop(sheetCtx);
                            final isRepo = game.isFromRepo;
                            final confirmed = await showQuestopiaDialog<bool>(
                              context: context,
                              builder: (ctx) => QuestopiaConfirmationDialog(
                                icon: isRepo
                                    ? Icons.delete_forever_rounded
                                    : Icons.delete_outline_rounded,
                                isDestructive: true,
                                title: isRepo
                                    ? l10n.deleteGameTitle
                                    : l10n.removeFromLibrary,
                                message: isRepo
                                    ? l10n.deleteGameMessage(game.title)
                                    : l10n.removeFromLibraryMessage(game.title),
                                confirmLabel:
                                    isRepo ? l10n.delete : l10n.remove,
                                cancelLabel: l10n.cancel,
                              ),
                            );
                            if (confirmed == true) onRemove();
                          },
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
      return;
    }

    final colors = Theme.of(context).colorScheme;

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

    return AdaptiveGameCardFrame(
      miuix: miuix,
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
        child: AdaptiveGameActionButton(
          miuix: miuix,
          icon: Icons.play_arrow_rounded,
          label: l10n.play,
          onPressed: onPlay,
          compact: isCompact,
        ),
      ),
    );
  }
}
