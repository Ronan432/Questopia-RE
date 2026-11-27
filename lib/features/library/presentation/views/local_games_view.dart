import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/platform_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../game/presentation/game_screen.dart';
import '../../../game/providers/game_engine_provider.dart';
import '../../data/local_game.dart';
import '../../providers/library_provider.dart';
import '../widgets/library_stats_row.dart';
import '../widgets/local_game_card.dart';
import '../widgets/miuix_local_game_row.dart';

/// Local installed games view with empty placeholder and adaptive grid layout.
class LocalGamesView extends ConsumerWidget {
  const LocalGamesView({
    super.key,
    required this.games,
    required this.onImportFolder,
    required this.allGames,
    required this.showFavoritesOnly,
    required this.onToggleFavoritesOnly,
    this.miuix = false,
  });

  final List<LocalGame> games;
  final VoidCallback onImportFolder;

  /// Unfiltered library, used for the summary counters.
  final List<LocalGame> allGames;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavoritesOnly;
  final bool miuix;

  Future<void> _launchGame(
    BuildContext context,
    WidgetRef ref,
    LocalGame game,
    AppLocalizations l10n,
  ) async {
    final f = File(game.gameFilePath);
    if (!await f.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.gameFileNotFound(game.gameFilePath))),
        );
      }
      return;
    }
    ref.read(gameEngineProvider.notifier).loadGame(game);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => GameScreen(title: game.title),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(libraryProvider);

    Widget wrapPullToRefresh(Widget child) {
      if (!miuix) return child;
      return MiuixPullToRefresh(
        isRefreshing: state.isLoadingLocal,
        contentPadding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        onRefresh: () =>
            ref.read(libraryProvider.notifier).refreshLocalGames(force: true),
        refreshTexts: [
          l10n.pullToRefreshPull,
          l10n.pullToRefreshRelease,
          l10n.pullToRefreshRefreshing,
          l10n.pullToRefreshComplete,
        ],
        child: child,
      );
    }

    if (games.isEmpty) {
      return wrapPullToRefresh(
        ListView(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(
              child: MiuixIcon(
                vector: MiuixIcons.os4.gridView,
                size: 52,
                tint: MiuixTheme.of(context).colors.onSurfaceVariantSummary,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: MiuixText(
                l10n.emptyLibraryHint,
                textAlign: TextAlign.center,
                style: MiuixTheme.of(context).textStyles.body2.copyWith(
                      color:
                          MiuixTheme.of(context).colors.onSurfaceVariantSummary,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: MiuixButton(
                onPressed: onImportFolder,
                colors: MiuixButtonDefaults.buttonColorsPrimary(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MiuixIcon(
                      vector: MiuixIcons.os4.add,
                      size: 20,
                      tint: MiuixTheme.of(context).colors.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.addGame),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 600;
    final isDesktop = isDesktopPlatform;
    final isNavBarBlur = !isDesktop && ref.watch(settingsProvider).isNavBarBlur;

    final horizontalPadding = isCompact ? 12.0 : 20.0;

    return wrapPullToRefresh(
      CustomScrollView(
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              MediaQuery.paddingOf(context).top + 10,
              horizontalPadding,
              12,
            ),
            sliver: SliverToBoxAdapter(
              child: LibraryStatsRow(
                games: allGames,
                showFavoritesOnly: showFavoritesOnly,
                onToggleFavoritesOnly: onToggleFavoritesOnly,
                miuix: miuix,
              ),
            ),
          ),
          if (miuix)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                100,
              ),
              sliver: SliverList.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return MiuixLocalGameRow(
                    game: game,
                    onPlay: () => _launchGame(context, ref, game, l10n),
                    onRemove: () {
                      ref
                          .read(libraryProvider.notifier)
                          .removeGameFromLibrary(game);
                    },
                    onToggleFavorite: () {
                      ref.read(libraryProvider.notifier).toggleFavorite(game);
                    },
                  );
                },
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                isNavBarBlur ? 90 : (isCompact ? 20 : 24),
              ),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: isCompact ? 200 : 320,
                  mainAxisExtent: isCompact ? 208 : 245,
                  crossAxisSpacing: isCompact ? 10 : 14,
                  mainAxisSpacing: isCompact ? 10 : 14,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return LocalGameCard(
                    game: game,
                    isCompact: isCompact,
                    miuix: false,
                    onPlay: () => _launchGame(context, ref, game, l10n),
                    onRemove: () {
                      ref
                          .read(libraryProvider.notifier)
                          .removeGameFromLibrary(game);
                    },
                    onToggleFavorite: () {
                      ref.read(libraryProvider.notifier).toggleFavorite(game);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
