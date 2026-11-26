import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';

class MiuixLibraryShell extends StatelessWidget {
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

  Widget _action({
    required String label,
    required String iconName,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: MiuixIconButton(
        onPressed: onPressed,
        minWidth: 48,
        minHeight: 48,
        child: MiuixIcon(
          vector: MiuixIcons.extended.byName(iconName)!,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuixTheme = MiuixTheme.of(context);
    final sectionTitle = switch (selectedTab) {
      0 => l10n.home,
      1 => l10n.catalog,
      _ => l10n.settings,
    };

    return MiuixScaffold(
      topBar: MiuixTopAppBar(
        title: l10n.appTitle,
        subtitle: sectionTitle,
        actions: [
          _action(
            label: l10n.search,
            iconName: 'search',
            onPressed: onOpenSearch,
          ),
          if (selectedTab == 0)
            _action(
              label: l10n.importGameTooltip,
              iconName: 'add',
              onPressed: onImportGame,
            ),
          if (selectedTab == 0)
            _action(
              label: showFavoritesOnly
                  ? l10n.showAllGames
                  : l10n.showFavoritesOnly,
              iconName: 'favoritesFill',
              onPressed: onToggleFavorites,
            ),
          if (selectedTab == 1)
            _action(
              label: l10n.refreshCatalog,
              iconName: 'refresh',
              onPressed: onRefreshCatalog,
            ),
        ],
        bottomContent: isSearchOpen
            ? MiuixSearchBar(
                expanded: true,
                onExpandedChange: (expanded) {
                  if (!expanded) onCloseSearch();
                },
                outsideEndAction: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onCloseSearch,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: miuixTheme.colors.primary),
                    ),
                  ),
                ),
                inputField: MiuixInputField(
                  query: searchQuery,
                  onQueryChange: onSearchChanged,
                  onSearch: onSearchSubmitted,
                  expanded: true,
                  onExpandedChange: (_) {},
                  focusNode: searchFocusNode,
                  label: l10n.search,
                ),
                content: const SizedBox.shrink(),
              )
            : null,
      ),
      content: (padding) => Padding(
        padding: padding,
        child: child,
      ),
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pagination != null) pagination!,
          MiuixNavigationBar(
            children: [
              MiuixNavigationBarItem(
                selected: selectedTab == 0,
                onPressed: () => onTabChanged(0),
                icon: MiuixIcon(
                  vector: MiuixIcons.extended.byName('home')!,
                  size: 26,
                ),
                label: l10n.home,
              ),
              MiuixNavigationBarItem(
                selected: selectedTab == 1,
                onPressed: () => onTabChanged(1),
                icon: MiuixIcon(
                  vector: MiuixIcons.extended.byName('gridView')!,
                  size: 26,
                ),
                label: l10n.catalog,
              ),
              MiuixNavigationBarItem(
                selected: selectedTab == 2,
                onPressed: () => onTabChanged(2),
                icon: MiuixIcon(
                  vector: MiuixIcons.extended.byName('settings')!,
                  size: 26,
                ),
                label: l10n.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
