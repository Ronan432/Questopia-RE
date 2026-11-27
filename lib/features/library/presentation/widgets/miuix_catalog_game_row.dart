import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/remote_game.dart';
import 'game_poster.dart';

/// KoWSU (`ModuleMiuix.kt` / `ModuleRepoMiuix.kt`) style catalog row card for
/// remote games: rounded poster, clean metadata, and Miuix action pill.
class MiuixCatalogGameRow extends StatelessWidget {
  const MiuixCatalogGameRow({
    super.key,
    required this.game,
    required this.isDownloading,
    required this.progress,
    required this.isInstalled,
    required this.onDownload,
    this.onPlay,
  });

  final RemoteGame game;
  final bool isDownloading;
  final double? progress;
  final bool isInstalled;
  final VoidCallback onDownload;
  final VoidCallback? onPlay;

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

  void _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    final rows = <(IconData, String)>[
      if (game.author.isNotEmpty) (Icons.person_rounded, game.author),
      if (game.portedBy.isNotEmpty) (Icons.swap_horiz_rounded, game.portedBy),
      if (game.version.isNotEmpty) (Icons.sell_rounded, 'v${game.version}'),
      if (game.lang.isNotEmpty)
        (Icons.language_rounded, game.lang.toUpperCase()),
      if (game.player.isNotEmpty) (Icons.sports_esports_rounded, game.player),
      if (_sizeLabel.isNotEmpty) (Icons.storage_rounded, _sizeLabel),
      if (game.modDate.isNotEmpty) (Icons.update_rounded, game.modDate),
    ];

    showQuestopiaSheet<void>(
      context: context,
      title: _title(l10n),
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (rows.isNotEmpty)
              MiuixCard(
                cornerRadius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < rows.length; i++)
                      MiuixBasicComponent(
                        title: rows[i].$2,
                        insideMargin: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        startAction: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            rows[i].$1,
                            size: 20,
                            color: colors.onSurfaceVariantActions,
                          ),
                        ),
                      ),
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
                    style: miuix.textStyles.body2.copyWith(
                      color: colors.onSurfaceSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            MiuixButton(
              onPressed: isDownloading
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      if (isInstalled && onPlay != null) {
                        onPlay!();
                      } else {
                        onDownload();
                      }
                    },
              colors: MiuixButtonDefaults.buttonColorsPrimary(ctx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isInstalled ? Icons.play_arrow_rounded : Icons.download_rounded,
                    size: 20,
                    color: colors.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  MiuixText(
                    isInstalled ? l10n.play : l10n.download,
                    style: miuix.textStyles.button.copyWith(
                      color: colors.onPrimary,
                    ),
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    final metaParts = <String>[
      if (game.author.isNotEmpty) game.author,
      if (game.version.isNotEmpty) 'v${game.version}',
      if (game.lang.isNotEmpty) game.lang.toUpperCase(),
      if (_sizeLabel.isNotEmpty) _sizeLabel,
    ];

    return MiuixCard(
      cornerRadius: 20,
      insideMargin: const EdgeInsets.all(14),
      onPressed: () => _showDetails(context),
      child: Row(
        children: [
          GamePoster(
            title: _title(l10n),
            remoteUrl: game.icon,
            width: 56,
            height: 76,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiuixText(
                  _title(l10n),
                  style: miuix.textStyles.title4.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (metaParts.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  MiuixText(
                    metaParts.join(' · '),
                    style: miuix.textStyles.footnote1.copyWith(
                      color: colors.onSurfaceVariantSummary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (game.descriptionText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  MiuixText(
                    game.descriptionText,
                    style: miuix.textStyles.footnote2.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isDownloading)
            const SizedBox(
              width: 42,
              height: 42,
              child: Center(
                child: MiuixCircularProgressIndicator(),
              ),
            )
          else
            SizedBox(
              width: 42,
              height: 42,
              child: MiuixButton(
                onPressed: isInstalled ? onPlay : onDownload,
                cornerRadius: 14,
                minHeight: 42,
                insideMargin: EdgeInsets.zero,
                colors: isInstalled
                    ? MiuixButtonDefaults.buttonColorsPrimary(context)
                    : MiuixButtonColors(
                        color: colors.surfaceContainerHigh,
                        disabledColor: colors.disabledSecondary,
                        contentColor: colors.onSurface,
                        disabledContentColor: colors.disabledOnSecondary,
                      ),
                child: Center(
                  child: Icon(
                    isInstalled
                        ? Icons.play_arrow_rounded
                        : Icons.download_rounded,
                    size: 20,
                    color: isInstalled ? colors.onPrimary : colors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
