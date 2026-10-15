import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/media/poster_menu_sheet.dart';
import '../../data/remote_game.dart';
import 'game_card_frame.dart';
import 'game_poster.dart';

class RemoteGameCard extends ConsumerWidget {
  const RemoteGameCard({
    super.key,
    required this.game,
    required this.isDownloading,
    required this.progress,
    required this.onDownload,
    this.isInstalled = false,
    this.onPlay,
    this.isCompact = false,
  });

  final RemoteGame game;
  final bool isDownloading;
  final double? progress;
  final VoidCallback onDownload;
  final bool isInstalled;
  final VoidCallback? onPlay;
  final bool isCompact;

  /// Title shown on the card and in the details sheet.
  ///
  /// Repository entries occasionally arrive without a title; in that case the
  /// localized fallback name is used instead of the raw id.
  String _title(AppLocalizations l10n) =>
      game.title.trim().isNotEmpty ? game.title : l10n.untitledRemoteGame(game.id);

  String get _sizeLabel {
    if (game.fileSize <= 0) return '';
    if (game.fileSize >= 1024 * 1024) {
      return '${(game.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (game.fileSize >= 1024) {
      return '${(game.fileSize / 1024).toStringAsFixed(0)} KB';
    }
    return '${game.fileSize} B';
  }

  /// Shows the catalogue metadata the app already downloads but never displayed.
  void _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showQuestopiaSheet<void>(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        final rows = <(IconData, String)>[
          if (game.author.isNotEmpty) (Icons.person_outline, game.author),
          if (game.portedBy.isNotEmpty) (Icons.swap_horiz_rounded, game.portedBy),
          if (game.version.isNotEmpty) (Icons.sell_outlined, 'v${game.version}'),
          if (game.lang.isNotEmpty)
            (Icons.language_outlined, game.lang.toUpperCase()),
          if (game.player.isNotEmpty)
            (Icons.videogame_asset_outlined, game.player),
          if (_sizeLabel.isNotEmpty) (Icons.sd_storage_outlined, _sizeLabel),
          if (game.modDate.isNotEmpty)
            (Icons.update_rounded, game.modDate),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestopiaSheetHeaderPill(title: _title(l10n)),
              if (rows.isNotEmpty)
                SegmentedListSection(
                  children: [
                    for (final row in rows)
                      SegmentedListTile(
                        leading: Icon(row.$1, size: 22),
                        title: Text(row.$2),
                        minVerticalPadding: 10,
                      ),
                  ],
                ),
              if (game.descriptionText.isNotEmpty) ...[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    game.descriptionText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: M3EButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (isInstalled) {
                      onPlay?.call();
                    } else {
                      onDownload();
                    }
                  },
                  icon: Icon(
                    isInstalled
                        ? Icons.play_arrow_rounded
                        : Icons.download_rounded,
                    size: 20,
                  ),
                  label: Text(isInstalled ? l10n.play : l10n.download),
                  style: M3EButtonStyle.filled,
                  size: M3EButtonSize.lg,
                  shape: M3EButtonShape.round,
                ),
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
    final title = _title(l10n);

    return GameCardFrame(
      contentPadding: isCompact
          ? const EdgeInsets.fromLTRB(8, 6, 8, 6)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onTap: () => _showDetails(context),
      onLongPress: game.posterUrl.isNotEmpty
          ? () => showPosterMenuSheet(
                context: context,
                imageUri: game.posterUrl,
              )
          : null,
      posterWidget: GamePoster(
        remoteUrl: game.posterUrl,
        isLocal: false,
        title: title,
        height: isCompact ? 84 : 112,
      ),
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 13 : 15,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (game.lang.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                game.lang.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (game.author.isNotEmpty)
                Expanded(
                  child: Text(
                    game.author,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (game.version.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  'v${game.version}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.outline,
                      ),
                ),
              ],
            ],
          ),
          if (_sizeLabel.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              _sizeLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.outline,
                  ),
            ),
          ],
        ],
      ),
      actionsWidget: SizedBox(
        width: double.infinity,
        child: isDownloading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 4),
                  Text(
                    progress == null
                        ? AppLocalizations.of(context)!.downloading
                        : '${(progress! * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )
            : (isInstalled
                ? M3EButton.icon(
                    onPressed: onPlay,
                    icon: Icon(Icons.play_arrow_rounded,
                        size: isCompact ? 16 : 18),
                    label: Text(
                      AppLocalizations.of(context)!.play,
                      style: TextStyle(fontSize: isCompact ? 11.5 : 13),
                    ),
                    style: M3EButtonStyle.filled,
                    size: M3EButtonSize.sm,
                    shape: M3EButtonShape.round,
                  )
                : M3EButton.icon(
                    onPressed: onDownload,
                    icon:
                        Icon(Icons.download_rounded, size: isCompact ? 16 : 18),
                    label: Text(
                      AppLocalizations.of(context)!.download,
                      style: TextStyle(fontSize: isCompact ? 11.5 : 13),
                    ),
                    style: M3EButtonStyle.filled,
                    size: M3EButtonSize.sm,
                    shape: M3EButtonShape.round,
                  )),
      ),
    );
  }
}
