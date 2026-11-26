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
      enabled: settings.isNavBarBlur,
      percent: settings.navBarBlurPercent,
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
                controller: searchController,
                focusNode: searchFocusNode,
                hintText: selectedTab == 1
                    ? l10n.searchOnlineCatalog
                    : l10n.search,
                query: searchQuery,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
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
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.query,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String query;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return Container(
      height: 42,
      decoration: ShapeDecoration(
        color: colors.surfaceContainerHigh,
        shape: MiuixSquircleBorder(
          cornerRadius: 21,
          side: BorderSide(
            color: colors.outline.withValues(alpha: 0.16),
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          MiuixIcon(
            vector: MiuixIcons.basic.search,
            size: 18,
            tint: colors.onSurfaceVariantActions,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: miuix.textStyles.body2.copyWith(
                color: colors.onSurface,
              ),
              cursorColor: colors.primary,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: miuix.textStyles.body2.copyWith(
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
            ),
          ),
          if (query.isNotEmpty)
            MiuixIconButton(
              minWidth: 32,
              minHeight: 32,
              onPressed: onClear,
              child: MiuixIcon(
                vector: MiuixIcons.os4.close,
                size: 16,
                tint: colors.onSurfaceVariantActions,
              ),
            ),
        ],
      ),
    );
  }
}
