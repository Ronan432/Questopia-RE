import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../providers/cheat_provider.dart';

/// Variables and watcher list view for Cheat Engine.
class CheatVariablesView extends StatelessWidget {
  const CheatVariablesView({
    super.key,
    required this.cheat,
    required this.notifier,
    required this.searchController,
    required this.addVarController,
    required this.onSearchChanged,
    required this.onEditVar,
  });

  final CheatState cheat;
  final CheatNotifier notifier;
  final TextEditingController searchController;
  final TextEditingController addVarController;
  final VoidCallback onSearchChanged;
  final void Function(String varName, String currentValue) onEditVar;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final query = searchController.text.trim().toLowerCase();
    final vars = query.isEmpty
        ? cheat.watchedVars
        : cheat.watchedVars
            .where((v) => v.name.toLowerCase().contains(query))
            .toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: addVarController,
                decoration: InputDecoration(
                  hintText: l10n.addVariableHint,
                  prefixIcon: const Icon(Icons.add_rounded),
                  isDense: true,
                  filled: true,
                  fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  notifier.addWatch(value);
                  addVarController.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            M3EButton.icon(
              tooltip: l10n.scanAllVariables,
              onPressed: () {
                HapticFeedback.lightImpact();
                notifier.refresh();
              },
              icon: const Icon(Icons.sync_rounded, size: 18),
              label: Text(l10n.scan),
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              shape: M3EButtonShape.round,
            ),
          ],
        ),
        const SizedBox(height: 10),
        QuestopiaSheetSearchBar(
          controller: searchController,
          hintText: l10n.searchVariablesHint(vars.length),
          onChanged: (_) => onSearchChanged(),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: vars.isEmpty
              ? QuestopiaSheetEmptyState(
                  icon: Icons.search_off_rounded,
                  message: l10n.noVariablesFound,
                )
              : ListView(
                  children: [
                    SegmentedListSection(
                      children: [
                        for (final v in vars)
                          _buildVarTile(context, v, cheat, notifier, colors),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  SegmentedListTile _buildVarTile(
    BuildContext context,
    CheatVar v,
    CheatState cheat,
    CheatNotifier notifier,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final frozen = cheat.frozen.containsKey(v.name);
    return SegmentedListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (frozen ? colors.tertiaryContainer : colors.primaryContainer)
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          frozen
              ? Icons.lock_rounded
              : (v.isNumeric ? Icons.tag_rounded : Icons.text_snippet_outlined),
          size: 18,
          color: frozen ? colors.tertiary : colors.primary,
        ),
      ),
      title: Text(
        v.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        v.displayValue.isEmpty ? l10n.emptyStringValue : v.displayValue,
        style: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: frozen ? l10n.unlock : l10n.lockValue,
            icon: Icon(
              frozen ? Icons.lock_rounded : Icons.lock_open_outlined,
              size: 20,
              color: frozen ? colors.tertiary : null,
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              notifier.toggleFreeze(
                v.name,
                v.isNumeric ? v.numValue.toString() : "'${v.strValue}'",
              );
            },
          ),
          IconButton(
            tooltip: l10n.editValue,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => onEditVar(v.name, v.displayValue),
          ),
          IconButton(
            tooltip: l10n.remove,
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () {
              HapticFeedback.selectionClick();
              notifier.removeWatch(v.name);
            },
          ),
        ],
      ),
    );
  }
}

/// Active locks view for Cheat Engine.
class CheatLocksView extends StatelessWidget {
  const CheatLocksView({
    super.key,
    required this.cheat,
    required this.notifier,
  });

  final CheatState cheat;
  final CheatNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    if (cheat.frozen.isEmpty) {
      return QuestopiaSheetEmptyState(
        icon: Icons.lock_open_rounded,
        message: l10n.noLockedVariables,
      );
    }
    final entries = cheat.frozen.entries.toList();
    return ListView(
      children: [
        SegmentedListSection(
          children: [
            for (final entry in entries)
              SegmentedListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.tertiaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.lock_rounded, size: 18, color: colors.tertiary),
                ),
                title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(l10n.lockedTo(entry.value), style: TextStyle(color: colors.tertiary)),
                trailing: IconButton(
                  tooltip: l10n.unlock,
                  icon: const Icon(Icons.lock_open_outlined),
                  onPressed: () => notifier.toggleFreeze(entry.key, entry.value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Diff comparison view for Cheat Engine.
class CheatDiffView extends StatelessWidget {
  const CheatDiffView({super.key, required this.cheat});

  final CheatState cheat;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final diff = cheat.diff;
    if (!cheat.hasSnapshotSave || diff.isEmpty) {
      return QuestopiaSheetEmptyState(
        icon: Icons.difference_outlined,
        message: !cheat.hasSnapshotSave
            ? l10n.noSnapshotYet
            : l10n.noChangesSinceSnapshot,
      );
    }
    return ListView(
      children: [
        SegmentedListSection(
          children: [
            for (final d in diff)
              SegmentedListTile(
                leading: Icon(Icons.difference_outlined, color: colors.primary, size: 20),
                title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${d.before}  ->  ${d.after}',
                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
