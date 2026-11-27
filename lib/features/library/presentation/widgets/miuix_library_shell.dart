import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/platform_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/glass_effect.dart';
import '../../../../core/widgets/miuix_nav_bar.dart';
import '../../../../core/widgets/miuix_nav_rail.dart';
import '../../../../core/widgets/window_title_bar.dart';
import 'miuix_search_field.dart';

class MiuixLibraryShell extends ConsumerStatefulWidget {
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
    required this.settingsScrollBehavior,
    required this.catalogScrollBehavior,
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
  final MiuixExitUntilCollapsedScrollBehavior settingsScrollBehavior;
  final MiuixExitUntilCollapsedScrollBehavior catalogScrollBehavior;
  final Widget? pagination;

  @override
  ConsumerState<MiuixLibraryShell> createState() => _MiuixLibraryShellState();
}

class _MiuixLibraryShellState extends ConsumerState<MiuixLibraryShell> {
  final GlobalKey _filterButtonKey = GlobalKey();
  bool _showFilterPopup = false;
  Rect _filterAnchorBounds = Rect.zero;
  MiuixExitUntilCollapsedScrollBehavior get _settingsScrollBehavior =>
      widget.settingsScrollBehavior;

  void _clearSearch() {
    widget.searchController.clear();
    widget.onSearchChanged('');
    widget.onCloseSearch();
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return MiuixSearchField(
      focusNode: widget.searchFocusNode,
      hintText: widget.selectedTab == 1
          ? l10n.searchOnlineCatalog
          : l10n.search,
      query: widget.searchQuery,
      isExpanded: widget.isSearchOpen,
      cancelLabel: l10n.cancel,
      onChanged: widget.onSearchChanged,
      onSubmitted: widget.onSearchSubmitted,
      onOpen: widget.onOpenSearch,
      onClear: _clearSearch,
    );
  }

  Widget _buildCollapsibleTopBar(
    BuildContext context,
    AppLocalizations l10n,
    MiuixThemeData miuixTheme,
    SettingsState settings, {
    required String title,
    required MiuixExitUntilCollapsedScrollBehavior scrollBehavior,
  }) {
    final colors = miuixTheme.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return GlassEffect.wrap(
      context,
      enabled: settings.isNavBarBlur,
      percent: settings.navBarBlurPercent,
      baseColor: colors.surface,
      border: (widget.isSearchOpen || settings.isNavBarBlur)
          ? Border(
              bottom: BorderSide(
                color: colors.dividerLine.withValues(alpha: 0.45),
                width: 0.5,
              ),
            )
          : null,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.18, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: widget.isSearchOpen
            ? Padding(
                key: ValueKey('collapsible_search_expanded_$title'),
                padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 10),
                child: _buildSearchField(l10n),
              )
            : Column(
                key: ValueKey('collapsible_search_collapsed_$title'),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MiuixTopAppBar(
                    title: title,
                    largeTitle: title,
                    scrollBehavior: scrollBehavior,
                    color: Colors.transparent,
                    actions: [
                      ListenableBuilder(
                        listenable: scrollBehavior.state,
                        builder: (context, _) {
                          final fraction =
                              scrollBehavior.state.collapsedFraction;
                          final iconOpacity =
                              ((fraction - 0.35) / 0.45).clamp(0.0, 1.0);
                          return IgnorePointer(
                            ignoring: iconOpacity < 0.05,
                            child: Opacity(
                              opacity: iconOpacity,
                              child: MiuixIconButton(
                                minWidth: 36,
                                minHeight: 36,
                                onPressed: widget.onOpenSearch,
                                child: _BoldSearchIcon(
                                  color: colors.onSurface,
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ListenableBuilder(
                    listenable: scrollBehavior.state,
                    builder: (context, child) {
                      final factor =
                          (1.0 - scrollBehavior.state.collapsedFraction * 1.6)
                              .clamp(0.0, 1.0);
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: factor,
                          child: Opacity(
                            opacity: factor,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                      child: _buildSearchField(l10n),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _openHomeFilterMenu() {
    final box =
        _filterButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final topLeft = box.localToGlobal(Offset.zero);
    setState(() {
      _filterAnchorBounds = topLeft & box.size;
      _showFilterPopup = true;
    });
  }

  Widget _buildHomeFilterPopup(BuildContext context, AppLocalizations l10n) {
    final dropdownColors = MiuixDropdownDefaults.dropdownColors(context);
    final items = <MiuixDropdownItem>[
      MiuixDropdownItem(
        text: l10n.installedGames,
        selected: !widget.showFavoritesOnly,
      ),
      MiuixDropdownItem(
        text: l10n.favoriteGames,
        selected: widget.showFavoritesOnly,
      ),
    ];

    // The window level popup shares window coordinates with the anchor and its
    // dim layer covers the bars, so the panel cannot slide off screen and the
    // navigation stays locked while it is open.
    return MiuixWindowListPopup(
      show: _showFilterPopup,
      anchorBounds: _filterAnchorBounds,
      alignment: MiuixPopupAlign.end,
      onDismissRequest: () {
        if (_showFilterPopup) setState(() => _showFilterPopup = false);
      },
      content: MiuixListPopupColumn(
        children: [
          for (var i = 0; i < items.length; i++)
            MiuixDropdownImpl(
              item: items[i],
              optionSize: items.length,
              isSelected: items[i].selected,
              index: i,
              dropdownColors: dropdownColors,
              onSelectedIndexChange: (idx) {
                setState(() => _showFilterPopup = false);
                final wantFavorites = idx == 1;
                if (wantFavorites != widget.showFavoritesOnly) {
                  widget.onToggleFavorites();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AppLocalizations l10n,
    MiuixThemeData miuixTheme,
    SettingsState settings,
  ) {
    if (widget.selectedTab == 1) {
      return _buildCollapsibleTopBar(
        context,
        l10n,
        miuixTheme,
        settings,
        title: l10n.catalog,
        scrollBehavior: widget.catalogScrollBehavior,
      );
    }
    if (widget.selectedTab == 2) {
      return _buildCollapsibleTopBar(
        context,
        l10n,
        miuixTheme,
        settings,
        title: l10n.settings,
        scrollBehavior: _settingsScrollBehavior,
      );
    }

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
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: widget.isSearchOpen
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: MiuixText(
                                  l10n.appTitle,
                                  style: miuixTheme.textStyles.title3.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            MiuixIconButton(
                              key: _filterButtonKey,
                              minWidth: 36,
                              minHeight: 36,
                              holdDownState: _showFilterPopup,
                              onPressed: _openHomeFilterMenu,
                              child: MiuixIcon(
                                vector: MiuixIcons.os4.moreCircle,
                                size: 22,
                                tint: widget.showFavoritesOnly
                                    ? colors.primary
                                    : colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            _buildSearchField(l10n),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuixTheme = MiuixTheme.of(context);
    final settings = ref.watch(settingsProvider);
    final isDesktop = isDesktopPlatform;
    final navItems = <MiuixNavBarItem>[
      MiuixNavBarItem(icon: Icons.home_rounded, label: l10n.home),
      MiuixNavBarItem(icon: Icons.extension_rounded, label: l10n.catalog),
      MiuixNavBarItem(icon: Icons.settings_rounded, label: l10n.settings),
    ];

    final scaffold = MiuixScaffold(
      topBar: _buildTopBar(context, l10n, miuixTheme, settings),
      content: (padding) {
        final mq = MediaQuery.of(context);
        return Stack(
          children: [
            MediaQuery(
              data: mq.copyWith(
                padding: mq.padding.copyWith(
                  top: padding.top,
                  bottom: 0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padding.left,
                  0,
                  padding.right,
                  0,
                ),
                child: widget.child,
              ),
            ),
            _buildHomeFilterPopup(context, l10n),
          ],
        );
      },
      floatingActionButton: widget.selectedTab == 0 && !isDesktop
          ? _KoWsuFab(
              onPressed: widget.onImportGame,
              tooltip: l10n.importGameTooltip,
            )
          : null,
      bottomBar: isDesktop && widget.pagination == null
          ? null
          : IgnorePointer(
              ignoring: _showFilterPopup,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.pagination != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: widget.pagination!,
                    ),
                  if (!isDesktop)
                    MiuixNavBar(
                      selectedIndex: widget.selectedTab,
                      onSelect: widget.onTabChanged,
                      blurEnabled: settings.isNavBarBlur,
                      blurPercent: settings.navBarBlurPercent,
                      items: navItems,
                    ),
                ],
              ),
            ),
    );

    if (!isDesktop) return scaffold;

    // A desktop window keeps the native title bar hidden, so the draggable
    // window row lives above the shell and the navigation moves to the start
    // side rail instead of the phone bottom bar.
    return Column(
      children: [
        // The mark is centered over the navigation rail, not over the window
        // edge, so the title row and the rail share one left edge.
        const WindowTitleBar(
          leadingWidth: 80,
          leading: QuestopiaLogoIcon(size: 22),
        ),
        Expanded(
          child: Row(
            children: [
              IgnorePointer(
                ignoring: _showFilterPopup,
                child: MiuixNavRail(
                  items: navItems,
                  selectedIndex: widget.selectedTab,
                  onSelect: widget.onTabChanged,
                  importLabel: l10n.addGame,
                  onImportGame: widget.onImportGame,
                ),
              ),
              // Screens still report short notices through the material
              // scaffold messenger, so the desktop shell keeps an invisible
              // scaffold as the host for them.
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: scaffold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoldSearchIcon extends StatelessWidget {
  const _BoldSearchIcon({required this.color, this.size = 22});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BoldSearchPainter(color),
    );
  }
}

class _BoldSearchPainter extends CustomPainter {
  const _BoldSearchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final r = size.width * 0.34;
    final center = Offset(size.width * 0.43, size.height * 0.43);
    canvas.drawCircle(center, r, paint);
    final start = Offset(
      center.dx + r * 0.72,
      center.dy + r * 0.72,
    );
    final end = Offset(size.width * 0.88, size.height * 0.88);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _BoldSearchPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _KoWsuFab extends StatelessWidget {
  const _KoWsuFab({
    required this.onPressed,
    required this.tooltip,
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = MiuixTheme.of(context).colors;
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: colors.primary,
        shape: CircleBorder(
          side: BorderSide(
            color: colors.outline.withValues(alpha: 0.35),
            width: 0.5,
          ),
        ),
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 3.2,
                      decoration: BoxDecoration(
                        color: colors.onPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      width: 3.2,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colors.onPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
