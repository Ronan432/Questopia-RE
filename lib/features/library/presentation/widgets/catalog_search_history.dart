import 'package:flutter/material.dart';
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
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // An empty history must not reserve any layout space at all.
    if (history.isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      color: colors.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref, l10n, colors),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: history.queries.length,
                itemBuilder: (context, index) {
                  final query = history.queries[index];
                  return _buildEntry(
                    context,
                    query,
                    l10n,
                    colors,
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
    ColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
      child: Row(
        children: [
          Icon(Icons.history_rounded, size: 16, color: colors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.searchHistoryTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => _confirmClear(context, ref, l10n),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Text(l10n.searchHistoryClearAll),
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
    ColorScheme colors, {
    required VoidCallback onRemove,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(Icons.search_rounded, size: 18, color: colors.outline),
      title: Text(
        query,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, color: colors.onSurface),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close_rounded, size: 18, color: colors.outline),
        tooltip: l10n.searchHistoryRemove,
        visualDensity: VisualDensity.compact,
        onPressed: onRemove,
      ),
      onTap: () => onQuerySelected(query),
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
        icon: Icons.delete_sweep_outlined,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          notifier.clear();
        },
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
