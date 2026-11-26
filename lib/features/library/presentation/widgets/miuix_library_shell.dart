import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';

class MiuixLibraryShell extends ConsumerStatefulWidget {
  const MiuixLibraryShell({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.child,
    required this.isSearchOpen,
    required this.searchQuery,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onOpenSearch,
    required this.onCloseSearch,
    required this.onImportGame,
    required this.showFavoritesOnly,
    required this.onToggleFavorites,
    required this.onRefreshCatalog,
    this.pagination,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final Widget child;
  final bool isSearchOpen;
  final String searchQuery;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onImportGame;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavorites;
  final VoidCallback onRefreshCatalog;
  final Widget? pagination;

  @override
  ConsumerState<MiuixLibraryShell> createState() => _MiuixLibraryShellState();
}

class _MiuixLibraryShellState extends ConsumerState<MiuixLibraryShell> {
  final MiuixLayerBackdrop _backdrop = MiuixLayerBackdrop();

  @override
  void dispose() {
    _backdrop.dispose();
    super.dispose();
  }

  Widget _action({
    required String label,
    required MiuixVectorIcon icon,
    required VoidCallback onPressed,
  }) {
    return MiuixGlassIconButton(
      tooltip: label,
      semanticLabel: label,
      onPressed: onPressed,
      child: MiuixIcon(vector: icon, size: 22),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, MiuixThemeData miuixTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MiuixSearchBar(
        expanded: widget.isSearchOpen,
        onExpandedChange: (expanded) {
          if (expanded) {
            widget.onOpenSearch();
          } else {
            widget.onCloseSearch();
          }
        },
        outsideEndAction: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: MiuixTextButton(
            l10n.cancel,
            onPressed: widget.onCloseSearch,
          ),
        ),
        inputField: MiuixInputField(
          query: widget.searchQuery,
          onQueryChange: widget.onSearchChanged,
          onSearch: widget.onSearchSubmitted,
          expanded: widget.isSearchOpen,
          onExpandedChange: (expanded) {
            if (expanded) {
              widget.onOpenSearch();
            } else {
              widget.onCloseSearch();
            }
          },
          focusNode: widget.searchFocusNode,
          label: l10n.search,
        ),
        content: const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuixTheme = MiuixTheme.of(context);
    final settings = ref.watch(settingsProvider);
    final blurEnabled = settings.isNavBarBlur;
    final blurSigma =
        (settings.navBarBlurPercent.clamp(10.0, 100.0) / 100.0) * 24.0;

    return MiuixScaffold(
      topBar: MiuixGlassTopAppBar(
        title: widget.selectedTab == 2 ? l10n.settings : l10n.appTitle,
        backdrop: blurEnabled ? _backdrop : null,
        progressiveBlur: blurEnabled,
        bandBlurRadius: blurEnabled ? blurSigma : 0,
        actions: [
          if (widget.selectedTab == 0)
            _action(
              label: widget.showFavoritesOnly
                  ? l10n.showAllGames
                  : l10n.showFavoritesOnly,
              icon: widget.showFavoritesOnly
                  ? MiuixIcons.os4.favoritesFill
                  : MiuixIcons.os4.favorites,
              onPressed: widget.onToggleFavorites,
            ),
          if (widget.selectedTab == 1)
            _action(
              label: l10n.refreshCatalog,
              icon: MiuixIcons.os4.refresh,
              onPressed: widget.onRefreshCatalog,
            ),
        ],
        bottomContent: widget.selectedTab != 2
            ? _buildSearchBar(l10n, miuixTheme)
            : null,
      ),
      content: (padding) => MiuixLayerBackdropCapture(
        backdrop: _backdrop,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            padding.top,
            padding.right,
            0,
          ),
          child: widget.child,
        ),
      ),
      floatingActionButton: widget.selectedTab == 0
          ? MiuixFloatingActionButton(
              onPressed: widget.onImportGame,
              child: MiuixIcon(
                vector: MiuixIcons.os4.add,
                tint: miuixTheme.colors.onPrimary,
                contentDescription: l10n.importGameTooltip,
              ),
            )
          : null,
      bottomBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.paddingOf(context).bottom + 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.pagination != null) ...[
              widget.pagination!,
              const SizedBox(height: 8),
            ],
            MiuixGlassNavigationBar(
              backdrop: blurEnabled ? _backdrop : null,
              selectedIndex: widget.selectedTab,
              onSelect: widget.onTabChanged,
              items: [
                MiuixGlassNavigationItem(
                  icon: MiuixIcon(
                    vector: MiuixIcons.extended.byName('home')!,
                    size: 24,
                  ),
                  label: l10n.home,
                ),
                MiuixGlassNavigationItem(
                  icon: MiuixIcon(
                    vector: MiuixIcons.os4.gridView,
                    size: 24,
                  ),
                  label: l10n.catalog,
                ),
                MiuixGlassNavigationItem(
                  icon: MiuixIcon(
                    vector: MiuixIcons.os4.settings,
                    size: 24,
                  ),
                  label: l10n.settings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
