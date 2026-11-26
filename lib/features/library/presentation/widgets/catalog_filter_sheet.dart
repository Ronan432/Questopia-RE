import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/library_provider.dart';

/// Resolves the localized label of a catalog sort option.
String catalogSortLabel(AppLocalizations l10n, CatalogSortOption option) {
  switch (option) {
    case CatalogSortOption.comments:
      return l10n.sortComments;
    case CatalogSortOption.name:
      return l10n.sortName;
    case CatalogSortOption.updated:
      return l10n.sortUpdated;
    case CatalogSortOption.created:
      return l10n.sortCreated;
    case CatalogSortOption.likes:
      return l10n.sortLikes;
    case CatalogSortOption.downloads:
      return l10n.sortDownloads;
    case CatalogSortOption.plays:
      return l10n.sortPlays;
  }
}

/// Opens the Miuix catalog filter sheet with separated Language, Featured, and Sort cards.
void showCatalogFilterSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showQuestopiaSheet<void>(
    context: context,
    builder: (ctx) => Consumer(
      builder: (sheetCtx, sheetRef, _) {
        final state = sheetRef.watch(libraryProvider);
        final notifier = sheetRef.read(libraryProvider.notifier);
        final miuix = MiuixTheme.of(sheetCtx);
        final colors = miuix.colors;
        const margin = EdgeInsets.symmetric(horizontal: 14, vertical: 10);

        Widget sectionLabel(String text) => Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
              child: MiuixText(
                text,
                style: miuix.textStyles.footnote1.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestopiaSheetHeaderPill(title: l10n.filters),
              sectionLabel(l10n.filterLanguage),
              MiuixCard(
                cornerRadius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final lang in const ['', 'ru', 'en'])
                      MiuixBasicComponent(
                        title: lang.isEmpty
                            ? l10n.allLanguages
                            : lang.toUpperCase(),
                        insideMargin: margin,
                        endActions: [
                          MiuixRadioButton(
                            selected: state.catalogLanguage == lang,
                            onChanged: (_) =>
                                notifier.setCatalogFilter(language: lang),
                          ),
                        ],
                        onClick: () =>
                            notifier.setCatalogFilter(language: lang),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              MiuixCard(
                cornerRadius: 20,
                child: MiuixSwitchPreference(
                  title: l10n.featured,
                  insideMargin: margin,
                  startAction: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MiuixIcon(
                      vector: state.catalogFeaturedOnly
                          ? MiuixIcons.os4.favoritesFill
                          : MiuixIcons.os4.favorites,
                      size: 20,
                      tint: state.catalogFeaturedOnly
                          ? colors.primary
                          : colors.onSurfaceVariantActions,
                    ),
                  ),
                  value: state.catalogFeaturedOnly,
                  onChanged: (v) =>
                      notifier.setCatalogFilter(featuredOnly: v),
                ),
              ),
              sectionLabel(l10n.sortCatalog),
              MiuixCard(
                cornerRadius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final opt in CatalogSortOption.values)
                      MiuixBasicComponent(
                        title: catalogSortLabel(l10n, opt),
                        insideMargin: margin,
                        endActions: [
                          MiuixRadioButton(
                            selected: state.catalogSort == opt,
                            onChanged: (_) =>
                                notifier.setCatalogFilter(sort: opt),
                          ),
                        ],
                        onClick: () => notifier.setCatalogFilter(sort: opt),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
