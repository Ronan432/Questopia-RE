import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/helpers/path_picker_helper.dart';
import '../../../core/helpers/platform_helper.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/miuix_design.dart';
import '../../settings/presentation/settings_screen.dart';
import '../providers/library_provider.dart';
import '../providers/search_history_provider.dart';
import 'helpers/crash_dialog_helper.dart';
import 'helpers/library_filter_helper.dart';
import 'helpers/library_import_helper.dart';
import 'views/catalog_games_view.dart';
import 'views/local_games_view.dart';
import 'widgets/catalog_pagination_bar.dart';
import 'widgets/miuix_library_shell.dart';

/// Main hub containing the local game library, remote catalog, and inline settings.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';
  bool _isSearchOpen = false;
  bool _showFavoritesOnly = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final MiuixExitUntilCollapsedScrollBehavior _settingsScrollBehavior =
      miuixScrollBehavior();
  final MiuixExitUntilCollapsedScrollBehavior _catalogScrollBehavior =
      miuixScrollBehavior(
        snapDuration: const Duration(milliseconds: 520),
        snapCurve: Curves.easeInOutCubic,
      );

  @override
  void initState() {
    super.initState();
    if (!isDesktopPlatform) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CrashDialogHelper.offerCrashReport(context);
      if (defaultTargetPlatform == TargetPlatform.android) {
        await PathPickerHelper.ensureStoragePermissions();
      }
      if (mounted) {
        ref.read(libraryProvider.notifier).refreshLocalGames();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchFocusNode.requestFocus());
  }

  void _closeSearch() {
    if (!_isSearchOpen) return;
    setState(() => _isSearchOpen = false);
    _searchFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  /// Records the query in the catalog history (catalog tab only).
  void _rememberCatalogSearch(String rawQuery) {
    if (_selectedTab != 1) return;
    final trimmed = rawQuery.trim();
    if (trimmed.isEmpty) return;
    ref.read(searchHistoryProvider.notifier).record(trimmed);
  }

  Future<void> _importGameFolder() =>
      LibraryImportHelper.pickAndImport(context, ref);

  void _onTabChanged(int index) {
    if (_selectedTab == index) return;
    HapticFeedback.selectionClick();
    _closeSearch();
    setState(() => _selectedTab = index);
    _ensureCatalogLoaded(index);
  }

  /// Lazily loads the remote catalogue the first time the tab is opened.
  void _ensureCatalogLoaded(int index) {
    if (index != 1) return;
    final state = ref.read(libraryProvider);
    if (!state.hasLoadedRemote && !state.isLoadingRemote) {
      ref.read(libraryProvider.notifier).refreshRemoteCatalog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);
    final settings = ref.watch(settingsProvider);
    // Search covers the author as well as the title, and the catalogue also
    // matches on its description text.
    final filteredLocalGames = LibraryFilterHelper.filterLocalGames(
      state.localGames,
      _searchQuery,
      favoritesOnly: _showFavoritesOnly,
    );
    final filteredRemoteGames = LibraryFilterHelper.filterRemoteGames(
      state.remoteGames,
      _searchQuery,
    );

    Widget mainContentFor(int tabIndex) {
      switch (tabIndex) {
        case 0:
          return LocalGamesView(
            games: filteredLocalGames,
            onImportFolder: _importGameFolder,
            allGames: state.localGames,
            showFavoritesOnly: _showFavoritesOnly,
            onToggleFavoritesOnly: () => setState(
              () => _showFavoritesOnly = !_showFavoritesOnly,
            ),
            miuix: shouldUseMiuixDesign(settings),
          );
        case 1:
          return CatalogGamesView(
            games: filteredRemoteGames,
            miuix: shouldUseMiuixDesign(settings),
            onScrollNotification: _catalogScrollBehavior.handleScroll,
          );
        case 2:
          return SettingsScreen(
            isInline: true,
            searchQuery: _selectedTab == 2 ? _searchQuery : '',
            onScrollNotification: _settingsScrollBehavior.handleScroll,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return MiuixDesignTheme(
      child: PopScope(
        canPop: !_isSearchOpen && _selectedTab == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_isSearchOpen) {
            _closeSearch();
            return;
          }
          if (_selectedTab != 0) _onTabChanged(0);
        },
        child: MiuixLibraryShell(
          selectedTab: _selectedTab,
          onTabChanged: _onTabChanged,
          settingsScrollBehavior: _settingsScrollBehavior,
          catalogScrollBehavior: _catalogScrollBehavior,
          isSearchOpen: _isSearchOpen,
          searchQuery: _searchQuery,
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onSearchSubmitted: _rememberCatalogSearch,
          onOpenSearch: _openSearch,
          onCloseSearch: _closeSearch,
          onImportGame: _importGameFolder,
          showFavoritesOnly: _showFavoritesOnly,
          onToggleFavorites: () =>
              setState(() => _showFavoritesOnly = !_showFavoritesOnly),
          pagination: _selectedTab == 1 && state.totalPages > 1
              ? const CatalogPaginationBar(isInsideOverlay: true, miuix: true)
              : null,
          child: IndexedStack(
            index: _selectedTab,
            children: [
              mainContentFor(0),
              mainContentFor(1),
              mainContentFor(2),
            ],
          ),
        ),
      ),
    );
  }
}
