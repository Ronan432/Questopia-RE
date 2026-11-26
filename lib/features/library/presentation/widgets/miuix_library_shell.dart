import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/glass_effect.dart';
import '../../../../core/widgets/miuix_nav_bar.dart';

class MiuixLibraryShell extends ConsumerWidget {
  const MiuixLibraryShell({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.child,
    required this.isSearchOpen,
    required this.searchQuery,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onOpenSearch,
    required this.onCloseSearch,
    required this.onImportGame,
    required this.showFavoritesOnly,
    required this.onToggleFavorites,
    this.pagination,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final Widget child;
  final bool isSearchOpen;
  final String searchQuery;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onImportGame;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavorites;
  final Widget? pagination;

  Widget _buildTopBar(
    BuildContext context,
    AppLocalizations l10n,
    MiuixThemeData miuixTheme,
    SettingsState settings,
  ) {
    final colors = miuixTheme.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return GlassEffect.wrap(
      context,
      enabled: settings.isNavBarBlur || selectedTab == 2,
      percent: settings.isNavBarBlur ? settings.navBarBlurPercent : 70.0,
      baseColor: colors.surface,
      border: Border(
        bottom: BorderSide(
          color: colors.dividerLine.withValues(alpha: 0.45),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, topInset + 6, 16, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: MiuixText(
                      selectedTab == 2 ? l10n.settings : l10n.appTitle,
                      style: miuixTheme.textStyles.title3.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selectedTab == 0)
                    MiuixIconButton(
                      minWidth: 40,
                      minHeight: 40,
                      onPressed: onToggleFavorites,
                      child: MiuixIcon(
                        vector: showFavoritesOnly
                            ? MiuixIcons.os4.favoritesFill
                            : MiuixIcons.os4.favorites,
                        size: 22,
                        contentDescription: showFavoritesOnly
                            ? l10n.showAllGames
                            : l10n.showFavoritesOnly,
                        tint: showFavoritesOnly
                            ? colors.error
                            : colors.onSurfaceVariantActions,
                      ),
                    ),
                ],
              ),
            ),
            if (selectedTab != 2) ...[
              const SizedBox(height: 6),
              _MiuixSearchField(
                focusNode: searchFocusNode,
                hintText: selectedTab == 1
                    ? l10n.searchOnlineCatalog
                    : l10n.search,
                query: searchQuery,
                isExpanded: isSearchOpen,
                cancelLabel: l10n.cancel,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                onOpen: onOpenSearch,
                onClear: () {
                  searchController.clear();
                  onSearchChanged('');
                  onCloseSearch();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final miuixTheme = MiuixTheme.of(context);
    final settings = ref.watch(settingsProvider);

    return MiuixScaffold(
      topBar: _buildTopBar(context, l10n, miuixTheme, settings),
      content: (padding) => Padding(
        padding: EdgeInsets.fromLTRB(
          padding.left,
          padding.top,
          padding.right,
          0,
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: child,
        ),
      ),
      floatingActionButton: selectedTab == 0
          ? MiuixFloatingActionButton(
              onPressed: onImportGame,
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
            if (pagination != null) ...[
              pagination!,
              const SizedBox(height: 8),
            ],
            MiuixNavBar(
              selectedIndex: selectedTab,
              onSelect: onTabChanged,
              blurEnabled: settings.isNavBarBlur,
              blurPercent: settings.navBarBlurPercent,
              items: [
                MiuixNavBarItem(
                  icon: MiuixIcons.extended.byName('home') ??
                      MiuixIcons.os4.gridView,
                  label: l10n.home,
                ),
                MiuixNavBarItem(
                  icon: MiuixIcons.os4.gridView,
                  label: l10n.catalog,
                ),
                MiuixNavBarItem(
                  icon: MiuixIcons.os4.settings,
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

class _MiuixSearchField extends StatelessWidget {
  const _MiuixSearchField({
    required this.focusNode,
    required this.hintText,
    required this.query,
    required this.isExpanded,
    required this.cancelLabel,
    required this.onChanged,
    required this.onSubmitted,
    required this.onOpen,
    required this.onClear,
  });

  final FocusNode focusNode;
  final String hintText;
  final String query;
  final bool isExpanded;
  final String cancelLabel;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onOpen;
  final VoidCallback onClear;

  void _onExpandedChanged(bool expanded) {
    if (expanded) {
      onOpen();
    } else {
      onClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return MiuixSearchBar(
      expanded: isExpanded,
      insideMargin: EdgeInsets.zero,
      onExpandedChange: _onExpandedChanged,
      inputField: MiuixInputField(
        query: query,
        onQueryChange: onChanged,
        onSearch: onSubmitted,
        expanded: isExpanded,
        onExpandedChange: _onExpandedChanged,
        label: hintText,
        focusNode: focusNode,
        color: colors.surfaceContainerHigh,
        leadingIcon: MiuixIcon(
          vector: MiuixIcons.basic.search,
          size: 20,
          tint: colors.onSurfaceVariantActions,
        ),
      ),
      outsideEndAction: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: MiuixTextButton(
          cancelLabel,
          onPressed: onClear,
        ),
      ),
      content: const SizedBox.shrink(),
    );
  }
}
