import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
import '../../providers/library_provider.dart';
import 'catalog_filter_sheet.dart';

/// Compact catalog filter bar with a unified Filter button opening
/// separated Sort, Language, and Featured sections.
class CatalogFilterBar extends ConsumerStatefulWidget {
  const CatalogFilterBar({super.key, this.miuix = true});

  final bool miuix;

  @override
  ConsumerState<CatalogFilterBar> createState() => _CatalogFilterBarState();
}

class _CatalogFilterBarState extends ConsumerState<CatalogFilterBar> {
  bool _isVisible = true;
  Timer? _reappearTimer;

  @override
  void dispose() {
    _reappearTimer?.cancel();
    super.dispose();
  }

  void _showBar() {
    _reappearTimer?.cancel();
    if (!_isVisible && mounted) setState(() => _isVisible = true);
  }

  void _hideBar() {
    if (_isVisible && mounted) setState(() => _isVisible = false);
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.horizontal) return false;
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        _hideBar();
        _reappearTimer?.cancel();
        _reappearTimer = Timer(
          const Duration(milliseconds: 1200),
          _showBar,
        );
      } else if (notification.direction == ScrollDirection.forward) {
        _showBar();
        _reappearTimer?.cancel();
      }
    } else if (notification is ScrollEndNotification) {
      _reappearTimer?.cancel();
      _reappearTimer = Timer(const Duration(milliseconds: 400), _showBar);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    final activeCount = (state.catalogLanguage.isNotEmpty ? 1 : 0) +
        (state.catalogFeaturedOnly ? 1 : 0);
    final langText = state.catalogLanguage.isEmpty
        ? l10n.allLanguages
        : state.catalogLanguage.toUpperCase();
    final sortText = catalogSortLabel(l10n, state.catalogSort);

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: _isVisible
            ? Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
                child: Row(
                  children: [
                    MiuixPressable(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        showCatalogFilterSheet(context);
                      },
                      shape: MiuixSquircleBorder(cornerRadius: 18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: ShapeDecoration(
                          color: activeCount > 0
                              ? colors.primary.withValues(alpha: 0.14)
                              : colors.surfaceContainerHigh,
                          shape: MiuixSquircleBorder(
                            cornerRadius: 18,
                            side: BorderSide(
                              color: activeCount > 0
                                  ? colors.primary.withValues(alpha: 0.35)
                                  : colors.outline.withValues(alpha: 0.16),
                              width: 0.75,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            miuixIcon(
                              'filter',
                              size: 16,
                              tint: activeCount > 0
                                  ? colors.primary
                                  : colors.onSurface,
                              fallback: MiuixIcons.basic.arrowUpDown,
                            ),
                            const SizedBox(width: 8),
                            MiuixText(
                              l10n.filters,
                              style: miuix.textStyles.footnote1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: activeCount > 0
                                    ? colors.primary
                                    : colors.onSurface,
                              ),
                            ),
                            if (activeCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MiuixText(
                                  '$activeCount',
                                  style: miuix.textStyles.footnote2.copyWith(
                                    color: colors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiuixText(
                        '$sortText · $langText'
                        '${state.catalogFeaturedOnly ? ' · ${l10n.featured}' : ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: miuix.textStyles.footnote1.copyWith(
                          color: colors.onSurfaceVariantSummary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}
