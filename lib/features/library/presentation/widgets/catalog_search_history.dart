import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/search_history_provider.dart';

/// Dropdown list of recent catalog search queries.
///
/// Renders nothing while the history is empty, so the search box stays clean
/// until the user has actually searched the catalog at least once. It is meant
/// to be shown underneath a focused search field.
class CatalogSearchHistory extends ConsumerWidget {
  const CatalogSearchHistory({
    super.key,
    required this.onQuerySelected,
    this.maxHeight = 260,
  });

  /// Called with the chosen query when the user taps a history entry.
  final ValueChanged<String> onQuerySelected;

  /// Upper bound for the scrollable list.
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);
    final notifier = ref.read(searchHistoryProvider.notifier);
    final miuix = MiuixTheme.of(context);
    final miuixColors = miuix.colors;
    final l10n = AppLocalizations.of(context)!;

    // An empty history must not reserve any layout space at all.
    if (history.isEmpty) return const SizedBox.shrink();

    return MiuixCard(
      cornerRadius: 20,
      colors: MiuixCardColors(
        color: miuixColors.surfaceContainerHigh,
        contentColor: miuixColors.onSurface,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref, l10n, miuix, miuixColors),
            const MiuixHorizontalDivider(),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: history.queries.length,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(left: 42),
                  child: MiuixHorizontalDivider(),
                ),
                itemBuilder: (context, index) {
                  final query = history.queries[index];
                  return _buildEntry(
                    context,
                    query,
                    l10n,
                    miuixColors,
                    onRemove: () => notifier.remove(query),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header row with the section label and the clear-all action.
  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    MiuixThemeData miuix,
    MiuixColors miuixColors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 8, top: 6, bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            size: 16,
            color: miuixColors.onSurfaceVariantSummary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MiuixText(
              l10n.searchHistoryTitle,
              style: miuix.textStyles.footnote1.copyWith(
                color: miuixColors.onSurfaceVariantSummary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          MiuixButton(
            onPressed: () => _confirmClear(context, ref, l10n),
            minHeight: 30,
            cornerRadius: 12,
            insideMargin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            colors: MiuixButtonColors(
              color: Colors.transparent,
              disabledColor: Colors.transparent,
              contentColor: miuixColors.primary,
              disabledContentColor: miuixColors.disabledOnSecondary,
            ),
            child: MiuixText(
              l10n.searchHistoryClearAll,
              style: miuix.textStyles.footnote1.copyWith(
                color: miuixColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// One tappable query row with its own delete affordance.
  Widget _buildEntry(
    BuildContext context,
    String query,
    AppLocalizations l10n,
    MiuixColors miuixColors, {
    required VoidCallback onRemove,
  }) {
    return MiuixBasicComponent(
      title: query,
      insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      startAction: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.history_rounded,
          size: 18,
          color: miuixColors.onSurfaceVariantActions,
        ),
      ),
      endActions: [
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 18,
            color: miuixColors.onSurfaceVariantActions,
          ),
          tooltip: l10n.searchHistoryRemove,
          visualDensity: VisualDensity.compact,
          onPressed: onRemove,
        ),
      ],
      onClick: () => onQuerySelected(query),
    );
  }

  /// Asks for confirmation before wiping the whole history.
  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final notifier = ref.read(searchHistoryProvider.notifier);
    await showQuestopiaDialog<void>(
      context: context,
      builder: (dialogContext) => QuestopiaConfirmationDialog(
        title: l10n.searchHistoryClearTitle,
        message: l10n.searchHistoryClearMessage,
        confirmLabel: l10n.searchHistoryClearAll,
        isDestructive: true,
        icon: Icons.delete_outline_rounded,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          notifier.clear();
        },
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
