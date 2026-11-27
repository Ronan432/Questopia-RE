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
import '../../data/remote_game.dart';
import '../../providers/library_provider.dart';
import '../widgets/catalog_filter_bar.dart';
import '../widgets/catalog_pagination_bar.dart';
import '../widgets/miuix_catalog_game_row.dart';
import '../widgets/remote_game_card.dart';

/// Remote catalog games view with filter bar, grid, and pagination.
class CatalogGamesView extends ConsumerWidget {
  const CatalogGamesView({
    super.key,
    required this.games,
    this.miuix = false,
    this.onScrollNotification,
  });

  final List<RemoteGame> games;
  final bool miuix;
  final bool Function(ScrollNotification)? onScrollNotification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final isDesktop = isDesktopPlatform;

    final grid = _buildRemoteGrid(context, ref, games, state);
    final l10n = AppLocalizations.of(context)!;

    final content = miuix
        ? CustomScrollView(
            physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                  child: CatalogFilterBar(miuix: miuix),
                ),
              ),
              ..._buildMiuixSlivers(context, ref, games, state, l10n),
            ],
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: CatalogFilterBar(miuix: miuix),
              ),
              Expanded(child: grid),
              if (isDesktop && state.totalPages > 1)
                CatalogPaginationBar(miuix: miuix),
            ],
          );

    if (!miuix) return content;

    final refreshed = MiuixPullToRefresh(
      isRefreshing: state.isLoadingRemote,
      contentPadding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      onRefresh: () =>
          ref.read(libraryProvider.notifier).refreshRemoteCatalog(force: true),
      refreshTexts: [
        l10n.pullToRefreshPull,
        l10n.pullToRefreshRelease,
        l10n.pullToRefreshRefreshing,
        l10n.pullToRefreshComplete,
      ],
      child: content,
    );

    return onScrollNotification != null
        ? NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: refreshed,
          )
        : refreshed;
  }

  List<Widget> _buildMiuixSlivers(
    BuildContext context,
    WidgetRef ref,
    List<RemoteGame> games,
    LibraryState state,
    AppLocalizations l10n,
  ) {
    final miuixColors = MiuixTheme.of(context).colors;
    if (state.isLoadingRemote && games.isEmpty) {
      return const [
        SliverPadding(
          padding: EdgeInsets.only(top: 32),
          sliver: SliverToBoxAdapter(
            child: Center(child: MiuixCircularProgressIndicator()),
          ),
        ),
      ];
    }

    if (state.remoteError != null && games.isEmpty) {
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 52,
                  color: miuixColors.onSurfaceVariantSummary,
                ),
                const SizedBox(height: 12),
                MiuixText(
                  state.remoteError ?? l10n.couldNotReachRepository,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                MiuixButton(
                  onPressed: () => ref
                      .read(libraryProvider.notifier)
                      .refreshRemoteCatalog(force: true),
                  colors: MiuixButtonDefaults.buttonColorsPrimary(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: miuixColors.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      MiuixText(
                        l10n.retry,
                        style: MiuixTheme.of(context)
                            .textStyles
                            .button
                            .copyWith(color: miuixColors.onPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (games.isEmpty) {
      return [
        SliverPadding(
          padding: const EdgeInsets.only(top: 32),
          sliver: SliverToBoxAdapter(
            child: Center(child: MiuixText(l10n.noCatalogItems)),
          ),
        ),
      ];
    }

    final hasPagination = state.totalPages > 1;
    final bottomPadding =
        (hasPagination ? 140.0 : 100.0) + MediaQuery.paddingOf(context).bottom;

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, bottomPadding),
        sliver: SliverList.separated(
          itemCount: games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final remoteGame = games[index];
            final isDownloading = state.downloadingGameId == remoteGame.id;
            final progress = isDownloading ? state.downloadProgress : null;

            LocalGame? matchingLocal;
            try {
              matchingLocal = state.localGames.firstWhere(
                (g) =>
                    g.id == remoteGame.id || g.title == remoteGame.displayName,
              );
            } catch (_) {}

            final installed = matchingLocal;
            return MiuixCatalogGameRow(
              game: remoteGame,
              isDownloading: isDownloading,
              progress: progress,
              isInstalled: installed != null,
              onPlay: installed != null
                  ? () async {
                      final f = File(installed.gameFilePath);
                      if (!await f.exists()) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.gameFileNotFound(installed.gameFilePath),
                              ),
                            ),
                          );
                        }
                        return;
                      }
                      ref.read(gameEngineProvider.notifier).loadGame(installed);
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GameScreen(title: installed.title),
                          ),
                        );
                      }
                    }
                  : null,
              onDownload: () => _download(context, ref, remoteGame),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildRemoteGrid(
    BuildContext context,
    WidgetRef ref,
    List<RemoteGame> games,
    LibraryState state,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (state.isLoadingRemote && games.isEmpty) {
      return ListView(
        padding: const EdgeInsets.only(top: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(child: MiuixCircularProgressIndicator()),
        ],
      );
    }

    if (state.remoteError != null && games.isEmpty) {
      final miuixColors = MiuixTheme.of(context).colors;
      return ListView(
        padding: const EdgeInsets.only(top: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: MiuixIcon(
              vector: MiuixIcons.os4.refresh,
              size: 52,
              tint: miuixColors.onSurfaceVariantSummary,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: MiuixText(
                state.remoteError ?? l10n.couldNotReachRepository,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: MiuixButton(
              onPressed: () => ref
                  .read(libraryProvider.notifier)
                  .refreshRemoteCatalog(force: true),
              colors: MiuixButtonDefaults.buttonColorsPrimary(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiuixIcon(
                    vector: MiuixIcons.os4.refresh,
                    size: 18,
                    tint: miuixColors.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.retry),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (games.isEmpty) {
      return ListView(
        padding: const EdgeInsets.only(top: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: MiuixText(l10n.noCatalogItems),
          ),
        ],
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 600;
    final isDesktop = isDesktopPlatform;
    final isNavBarBlur = !isDesktop && ref.watch(settingsProvider).isNavBarBlur;
    final hasPagination = state.totalPages > 1;
    final bottomGridPadding = hasPagination
        ? 8.0
        : (isNavBarBlur ? 90.0 : (isCompact ? 20.0 : 24.0));

    if (miuix) {
      final list = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16,
          4,
          16,
          bottomGridPadding + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: games.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final remoteGame = games[index];
          final isDownloading = state.downloadingGameId == remoteGame.id;
          final progress = isDownloading ? state.downloadProgress : null;

          LocalGame? matchingLocal;
          try {
            matchingLocal = state.localGames.firstWhere(
              (g) => g.id == remoteGame.id || g.title == remoteGame.displayName,
            );
          } catch (_) {}

          final installed = matchingLocal;
          return MiuixCatalogGameRow(
            game: remoteGame,
            isDownloading: isDownloading,
            progress: progress,
            isInstalled: installed != null,
            onPlay: installed != null
                ? () async {
                    final f = File(installed.gameFilePath);
                    if (!await f.exists()) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.gameFileNotFound(installed.gameFilePath),
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    ref.read(gameEngineProvider.notifier).loadGame(installed);
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute<void>(
                          builder: (_) => GameScreen(title: installed.title),
                        ),
                      );
                    }
                  }
                : null,
            onDownload: () => _download(context, ref, remoteGame),
          );
        },
      );
      return onScrollNotification != null
          ? NotificationListener<ScrollNotification>(
              onNotification: onScrollNotification,
              child: list,
            )
          : list;
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        isCompact ? 12 : 20,
        4,
        isCompact ? 12 : 20,
        bottomGridPadding,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: isCompact ? 200 : 320,
        mainAxisExtent: isCompact ? 208 : 245,
        crossAxisSpacing: isCompact ? 10 : 14,
        mainAxisSpacing: isCompact ? 10 : 14,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final remoteGame = games[index];
        final isDownloading = state.downloadingGameId == remoteGame.id;
        final progress = isDownloading ? state.downloadProgress : null;

        LocalGame? matchingLocal;
        try {
          matchingLocal = state.localGames.firstWhere(
            (g) => g.id == remoteGame.id || g.title == remoteGame.displayName,
          );
        } catch (_) {}

        final installed = matchingLocal;

        return RemoteGameCard(
          game: remoteGame,
          isCompact: isCompact,
          miuix: miuix,
          isDownloading: isDownloading,
          progress: progress,
          isInstalled: installed != null,
          onPlay: installed != null
              ? () async {
                  final f = File(installed.gameFilePath);
                  if (!await f.exists()) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.gameFileNotFound(
                              installed.gameFilePath,
                            ),
                          ),
                        ),
                      );
                    }
                    return;
                  }
                  ref.read(gameEngineProvider.notifier).loadGame(installed);
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GameScreen(title: installed.title),
                      ),
                    );
                  }
                }
              : null,
          onDownload: () => _download(context, ref, remoteGame),
        );
      },
    );
  }

  Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    RemoteGame remoteGame,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final downloaded =
          await ref.read(libraryProvider.notifier).downloadGame(remoteGame);
      if (downloaded != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.downloadedGame(remoteGame.displayName))),
        );
      }
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
