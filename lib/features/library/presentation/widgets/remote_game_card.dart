import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/media/poster_menu_sheet.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
import '../../data/remote_game.dart';
import 'game_poster.dart';
import 'miuix_game_card.dart';

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
    this.miuix = false,
  });

  final RemoteGame game;
  final bool isDownloading;
  final double? progress;
  final VoidCallback onDownload;
  final bool isInstalled;
  final VoidCallback? onPlay;
  final bool isCompact;
  final bool miuix;

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
    if (miuix) {
      final miuixTheme = MiuixTheme.of(context);
      final rows = <(String, String)>[
        if (game.author.isNotEmpty) ('person', game.author),
        if (game.portedBy.isNotEmpty) ('swap_horiz', game.portedBy),
        if (game.version.isNotEmpty) ('tag', 'v${game.version}'),
        if (game.lang.isNotEmpty) ('language', game.lang.toUpperCase()),
        if (game.player.isNotEmpty) ('gamepad', game.player),
        if (_sizeLabel.isNotEmpty) ('storage', _sizeLabel),
        if (game.modDate.isNotEmpty) ('update', game.modDate),
      ];
      showQuestopiaSheet<void>(
        context: context,
        builder: (ctx) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestopiaSheetHeaderPill(title: _title(l10n)),
              if (rows.isNotEmpty)
                MiuixCard(
                  cornerRadius: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < rows.length; i++) ...[
                        if (i > 0)
                          const Padding(
                            padding: EdgeInsets.only(left: 48),
                            child: MiuixHorizontalDivider(),
                          ),
                        MiuixBasicComponent(
                          title: rows[i].$2,
                          insideMargin: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: miuixIcon(rows[i].$1, size: 20),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (game.descriptionText.isNotEmpty) ...[
                const SizedBox(height: 12),
                MiuixCard(
                  cornerRadius: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: MiuixText(
                      game.descriptionText,
                      style: miuixTheme.textStyles.body2.copyWith(
                        color: miuixTheme.colors.onSurfaceSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              MiuixButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (isInstalled) {
                    onPlay?.call();
                  } else {
                    onDownload();
                  }
                },
                colors: MiuixButtonDefaults.buttonColorsPrimary(ctx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MiuixIcon(
                      vector: isInstalled
                          ? MiuixIcons.os4.play
                          : miuixVector('download', fallback: MiuixIcons.os4.add),
                      size: 18,
                      tint: miuixTheme.colors.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(isInstalled ? l10n.play : l10n.download),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    showQuestopiaSheet<void>(
      context: context,
      builder: (ctx) {
        final miuixTheme = MiuixTheme.of(ctx);
        final colors = miuixTheme.colors;
        final rows = <(MiuixVectorIcon, String)>[
          if (game.author.isNotEmpty) (MiuixIcons.os4.contacts, game.author),
          if (game.portedBy.isNotEmpty) (MiuixIcons.os4.replace, game.portedBy),
          if (game.version.isNotEmpty)
            (MiuixIcons.os4.info, 'v${game.version}'),
          if (game.lang.isNotEmpty)
            (MiuixIcons.os4.translate, game.lang.toUpperCase()),
          if (game.player.isNotEmpty) (MiuixIcons.os4.play, game.player),
          if (_sizeLabel.isNotEmpty) (MiuixIcons.os4.backup, _sizeLabel),
          if (game.modDate.isNotEmpty) (MiuixIcons.os4.update, game.modDate),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestopiaSheetHeaderPill(title: _title(l10n)),
              if (rows.isNotEmpty)
                MiuixCard(
                  cornerRadius: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final row in rows)
                        MiuixBasicComponent(
                          title: row.$2,
                          insideMargin: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: MiuixIcon(
                              vector: row.$1,
                              size: 20,
                              tint: colors.onSurfaceVariantActions,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (game.descriptionText.isNotEmpty) ...[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MiuixText(
                    game.descriptionText,
                    style: miuixTheme.textStyles.body2.copyWith(
                      height: 1.5,
                      color: colors.onSurfaceVariantSummary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              MiuixButton(
                minHeight: 46,
                colors: MiuixButtonDefaults.buttonColorsPrimary(ctx),
                onPressed: () {
                  Navigator.pop(ctx);
                  if (isInstalled) {
                    onPlay?.call();
                  } else {
                    onDownload();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MiuixIcon(
                      vector: isInstalled
                          ? MiuixIcons.os4.play
                          : MiuixIcons.os4.download,
                      size: 18,
                      tint: colors.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(isInstalled ? l10n.play : l10n.download),
                  ],
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

    return AdaptiveGameCardFrame(
      miuix: miuix,
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
                  if (miuix)
                    MiuixLinearProgressIndicator(progress: progress)
                  else
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
            : AdaptiveGameActionButton(
                miuix: miuix,
                miuixIconVector: isInstalled
                    ? MiuixIcons.os4.play
                    : MiuixIcons.os4.download,
                label: isInstalled
                    ? AppLocalizations.of(context)!.play
                    : AppLocalizations.of(context)!.download,
                onPressed: isInstalled ? onPlay : onDownload,
                compact: isCompact,
              ),
      ),
    );
  }
}
