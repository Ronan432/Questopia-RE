import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';

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
    final miuix = MiuixTheme.of(context);
    final miuixColors = miuix.colors;
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
                  prefixIcon: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: miuixColors.onSurfaceVariantActions,
                  ),
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
            Tooltip(
              message: l10n.scanAllVariables,
              child: MiuixButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  notifier.refresh();
                },
                minHeight: 40,
                cornerRadius: 14,
                insideMargin: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                colors: MiuixButtonColors(
                  color: miuixColors.secondaryContainer,
                  disabledColor: miuixColors.disabledSecondary,
                  contentColor: miuixColors.onSecondaryContainer,
                  disabledContentColor: miuixColors.disabledOnSecondary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: miuixColors.onSecondaryContainer,
                    ),
                    const SizedBox(width: 6),
                    MiuixText(
                      l10n.scan,
                      style: miuix.textStyles.footnote1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: miuixColors.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
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
                  icon: Icons.search_rounded,
                  message: l10n.noVariablesFound,
                )
              : ListView(
                  children: [
                    MiuixCard(
                      cornerRadius: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < vars.length; i++) ...[
                            if (i > 0)
                              const Padding(
                                padding: EdgeInsets.only(left: 56),
                                child: MiuixHorizontalDivider(),
                              ),
                            _buildVarTile(
                              context,
                              vars[i],
                              cheat,
                              notifier,
                              colors,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildVarTile(
    BuildContext context,
    CheatVar v,
    CheatState cheat,
    CheatNotifier notifier,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final frozen = cheat.frozen.containsKey(v.name);
    return MiuixBasicComponent(
      title: v.name,
      summary: v.displayValue.isEmpty ? l10n.emptyStringValue : v.displayValue,
      insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      startAction: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (frozen ? colors.tertiaryContainer : colors.primaryContainer)
                .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            frozen
                ? Icons.lock_rounded
                : (v.isNumeric ? Icons.tune_rounded : Icons.article_rounded),
            size: 18,
            color: frozen ? colors.tertiary : colors.primary,
          ),
        ),
      ),
      endActions: [
        IconButton(
          tooltip: frozen ? l10n.unlock : l10n.lockValue,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            frozen ? Icons.lock_rounded : Icons.lock_open_rounded,
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
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.edit_rounded, size: 20),
          onPressed: () => onEditVar(v.name, v.displayValue),
        ),
        IconButton(
          tooltip: l10n.remove,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close_rounded, size: 20),
          onPressed: () {
            HapticFeedback.selectionClick();
            notifier.removeWatch(v.name);
          },
        ),
      ],
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
        MiuixCard(
          cornerRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.only(left: 56),
                    child: MiuixHorizontalDivider(),
                  ),
                MiuixBasicComponent(
                  title: entries[i].key,
                  summary: l10n.lockedTo(entries[i].value),
                  insideMargin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  startAction: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.tertiaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: colors.tertiary,
                      ),
                    ),
                  ),
                  endActions: [
                    IconButton(
                      tooltip: l10n.unlock,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.lock_open_rounded, size: 20),
                      onPressed: () => notifier.toggleFreeze(
                        entries[i].key,
                        entries[i].value,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
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
        icon: Icons.compare_arrows_rounded,
        message: !cheat.hasSnapshotSave
            ? l10n.noSnapshotYet
            : l10n.noChangesSinceSnapshot,
      );
    }
    return ListView(
      children: [
        MiuixCard(
          cornerRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < diff.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.only(left: 48),
                    child: MiuixHorizontalDivider(),
                  ),
                MiuixBasicComponent(
                  title: diff[i].name,
                  summary: '${diff[i].before}  ->  ${diff[i].after}',
                  insideMargin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  startAction: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.compare_arrows_rounded,
                      color: colors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
