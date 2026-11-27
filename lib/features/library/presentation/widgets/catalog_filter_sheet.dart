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

/// Opens the Miuix catalog filter sheet with unified settings-style cards.
void showCatalogFilterSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showQuestopiaSheet<void>(
    context: context,
    title: l10n.filters,
    builder: (ctx) => Consumer(
      builder: (sheetCtx, sheetRef, _) {
        final state = sheetRef.watch(libraryProvider);
        final notifier = sheetRef.read(libraryProvider.notifier);
        final miuix = MiuixTheme.of(sheetCtx);
        final colors = miuix.colors;
        const margin = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

        Widget sectionLabel(String text) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: MiuixText(
                text,
                style: miuix.textStyles.footnote1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
            );

        const langs = ['', 'ru', 'en'];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sectionLabel(l10n.filterLanguage),
              MiuixCard(
                cornerRadius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < langs.length; i++) ...[
                      if (i > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: MiuixHorizontalDivider(),
                        ),
                      MiuixRadioButtonPreference(
                        title: langs[i].isEmpty
                            ? l10n.allLanguages
                            : langs[i].toUpperCase(),
                        insideMargin: margin,
                        selected: state.catalogLanguage == langs[i],
                        onClick: () =>
                            notifier.setCatalogFilter(language: langs[i]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              MiuixCard(
                cornerRadius: 20,
                child: MiuixSwitchPreference(
                  title: l10n.featured,
                  insideMargin: margin,
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
                    for (var i = 0;
                        i < CatalogSortOption.values.length;
                        i++) ...[
                      if (i > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: MiuixHorizontalDivider(),
                        ),
                      MiuixRadioButtonPreference(
                        title: catalogSortLabel(
                          l10n,
                          CatalogSortOption.values[i],
                        ),
                        insideMargin: margin,
                        selected:
                            state.catalogSort == CatalogSortOption.values[i],
                        onClick: () => notifier.setCatalogFilter(
                          sort: CatalogSortOption.values[i],
                        ),
                      ),
                    ],
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
