import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/duration_format.dart';
import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
import '../../data/local_game.dart';
import '../../data/play_stats_store.dart';
import '../../providers/play_stats_provider.dart';
import 'game_poster.dart';

/// Cardless Miuix row for a locally installed game.
class MiuixLocalGameRow extends ConsumerWidget {
  const MiuixLocalGameRow({
    super.key,
    required this.game,
    required this.onPlay,
    required this.onRemove,
    required this.onToggleFavorite,
  });

  final LocalGame game;
  final VoidCallback onPlay;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;

  Future<void> _showMenuSheet(BuildContext context, PlayStats playStats) async {
    final l10n = AppLocalizations.of(context)!;
    final miuixTheme = MiuixTheme.of(context);
    final mColors = miuixTheme.colors;

    await showQuestopiaSheet<void>(
      context: context,
      title: game.title,
      builder: (sheetCtx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: GamePoster(
                      localPath: game.posterPath,
                      isLocal: true,
                      title: game.title,
                      height: 48,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MiuixText(
                    game.author.isNotEmpty
                        ? game.author
                        : l10n.qspInteractiveFiction,
                    style: miuixTheme.textStyles.body2.copyWith(
                      color: mColors.onSurfaceVariantSummary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            MiuixCard(
              cornerRadius: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiuixBasicComponent(
                    title: l10n.play,
                    startAction: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: MiuixIcon(
                        vector: MiuixIcons.os4.play,
                        tint: mColors.primary,
                        size: 22,
                      ),
                    ),
                    onClick: () {
                      Navigator.pop(sheetCtx);
                      onPlay();
                    },
                  ),
                  if (playStats.hasPlayed)
                    MiuixBasicComponent(
                      title: l10n.playStatsTotal,
                      summary: formatPlayDuration(
                        l10n,
                        Duration(seconds: playStats.totalSeconds),
                      ),
                      startAction: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: miuixIcon(
                          'timer',
                          size: 20,
                          tint: mColors.onSurfaceVariantActions,
                        ),
                      ),
                      endActions: [
                        Text(
                          playStats.lastPlayed == null
                              ? l10n.neverPlayed
                              : formatLastPlayedDate(playStats.lastPlayed!),
                          style: miuixTheme.textStyles.body2.copyWith(
                            color: mColors.onSurfaceVariantSummary,
                          ),
                        ),
                      ],
                    ),
                  MiuixBasicComponent(
                    title: game.isFavorite
                        ? l10n.removeFromFavorites
                        : l10n.addToFavorites,
                    startAction: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: MiuixIcon(
                        vector: game.isFavorite
                            ? MiuixIcons.os4.favoritesFill
                            : MiuixIcons.os4.favorites,
                        tint: game.isFavorite
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
                      child: MiuixIcon(
                        vector: MiuixIcons.os4.delete,
                        tint: mColors.error,
                        size: 22,
                      ),
                    ),
                    onClick: () async {
                      Navigator.pop(sheetCtx);
                      final isRepo = game.isFromRepo;
                      final confirmed = await showQuestopiaDialog<bool>(
                        context: context,
                        builder: (ctx) => QuestopiaConfirmationDialog(
                          miuixVectorIcon: MiuixIcons.os4.delete,
                          isDestructive: true,
                          title: isRepo
                              ? l10n.deleteGameTitle
                              : l10n.removeFromLibrary,
                          message: isRepo
                              ? l10n.deleteGameMessage(game.title)
                              : l10n.removeFromLibraryMessage(game.title),
                          confirmLabel: isRepo ? l10n.delete : l10n.remove,
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;
    final playStats =
        ref.watch(playStatsProvider(game.id)).valueOrNull ?? const PlayStats();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MiuixCard(
        cornerRadius: 20,
        insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        feedbackType: MiuixPressFeedbackType.sink,
        onPressed: onPlay,
        onLongPress: () => _showMenuSheet(context, playStats),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: GamePoster(
                      localPath: game.posterPath,
                      isLocal: true,
                      title: game.title,
                      height: 48,
                    ),
                  ),
                ),
                if (game.isFavorite)
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: MiuixIcon(
                        vector: MiuixIcons.os4.favoritesFill,
                        size: 11,
                        tint: colors.error,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiuixText(
                    game.title,
                    style: miuix.textStyles.headline2.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  MiuixText(
                    game.author.isNotEmpty
                        ? game.author
                        : l10n.qspInteractiveFiction,
                    style: miuix.textStyles.body2.copyWith(
                      color: colors.onSurfaceVariantSummary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            MiuixIconButton(
              onPressed: () => _showMenuSheet(context, playStats),
              minWidth: 36,
              minHeight: 36,
              child: miuixIcon(
                'more',
                size: 20,
                tint: colors.onSurfaceVariantActions,
              ),
            ),
            const SizedBox(width: 4),
            // The filled primary disc keeps the play glyph readable in both
            // themes: white on the dark palette and matching on the light one.
            MiuixIconButton(
              onPressed: onPlay,
              minWidth: 40,
              minHeight: 40,
              backgroundColor: colors.primary,
              child: MiuixIcon(
                vector: MiuixIcons.os4.play,
                size: 18,
                tint: colors.onPrimary,
                contentDescription: l10n.play,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
