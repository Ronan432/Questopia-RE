import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../providers/cheat_provider.dart';
import '../../../providers/game_engine_provider.dart';

/// Teleport tab view for Cheat Engine.
class CheatTeleportView extends StatelessWidget {
  const CheatTeleportView({
    super.key,
    required this.controller,
    required this.onTeleport,
  });

  final TextEditingController controller;
  final ValueChanged<String> onTeleport;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              l10n.jumpToLocationHint,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.locationNameHint,
              prefixIcon: const Icon(Icons.explore_outlined),
              filled: true,
              fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            textInputAction: TextInputAction.go,
            onSubmitted: onTeleport,
          ),
          const SizedBox(height: 16),
          M3EButton.icon(
            onPressed: () => onTeleport(controller.text),
            icon: const Icon(Icons.my_location_rounded, size: 18),
            label: Text(l10n.teleport),
            style: M3EButtonStyle.filled,
            size: M3EButtonSize.md,
            shape: M3EButtonShape.round,
          ),
        ],
      ),
    );
  }
}

/// Inventory editor tab view for Cheat Engine.
class CheatInventoryView extends StatelessWidget {
  const CheatInventoryView({
    super.key,
    required this.engineState,
    required this.notifier,
    required this.itemController,
    required this.onAddItem,
  });

  final GameEngineState engineState;
  final CheatNotifier notifier;
  final TextEditingController itemController;
  final ValueChanged<String> onAddItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final objects = engineState.gameState.objects;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: itemController,
                decoration: InputDecoration(
                  hintText: l10n.newItemNameHint,
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
                onSubmitted: onAddItem,
              ),
            ),
            const SizedBox(width: 8),
            M3EButton.icon(
              onPressed: () => onAddItem(itemController.text),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.add),
              style: M3EButtonStyle.filled,
              size: M3EButtonSize.sm,
              shape: M3EButtonShape.round,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: objects.isEmpty
              ? QuestopiaSheetEmptyState(
                  icon: Icons.inventory_2_outlined,
                  message: l10n.inventoryIsEmpty,
                )
              : ListView(
                  children: [
                    SegmentedListSection(
                      children: [
                        for (final item in objects)
                          SegmentedListTile(
                            leading: Icon(Icons.inventory_2_outlined,
                                color: colors.primary, size: 20),
                            title: Text(item.name,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: IconButton(
                              tooltip: l10n.remove,
                              icon: Icon(Icons.delete_outline_rounded,
                                  color: colors.error, size: 20),
                              onPressed: () {
                                final ok = notifier.removeItem(item.name);
                                if (!ok) {
                                  showSheetSnackBar(
                                    context,
                                    l10n.couldNotRemoveItem,
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Console execution tab view for Cheat Engine.
class CheatConsoleView extends StatelessWidget {
  const CheatConsoleView({
    super.key,
    required this.consoleController,
    required this.consoleOutput,
    required this.onRunConsole,
  });

  final TextEditingController consoleController;
  final String consoleOutput;
  final VoidCallback onRunConsole;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: SingleChildScrollView(
              child: Text(
                consoleOutput.isEmpty ? l10n.qspConsoleReady : consoleOutput,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: consoleController,
                decoration: InputDecoration(
                  hintText: l10n.qspStatementHint,
                  isDense: true,
                  filled: true,
                  fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onRunConsole(),
              ),
            ),
            const SizedBox(width: 8),
            M3EButton.icon(
              onPressed: onRunConsole,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(l10n.run),
              style: M3EButtonStyle.filled,
              size: M3EButtonSize.sm,
              shape: M3EButtonShape.round,
            ),
          ],
        ),
      ],
    );
  }
}
