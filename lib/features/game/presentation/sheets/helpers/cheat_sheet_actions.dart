import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

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
    final miuix = MiuixTheme.of(context);
    final miuixColors = miuix.colors;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: MiuixText(
              l10n.jumpToLocationHint,
              style: miuix.textStyles.body2.copyWith(
                color: miuixColors.onSurfaceSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.locationNameHint,
              prefixIcon: Icon(
                Icons.location_on_rounded,
                size: 18,
                color: miuixColors.onSurfaceVariantActions,
              ),
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
          MiuixButton(
            onPressed: () => onTeleport(controller.text),
            colors: MiuixButtonDefaults.buttonColorsPrimary(context),
            cornerRadius: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: miuixColors.onPrimary,
                ),
                const SizedBox(width: 8),
                MiuixText(
                  l10n.teleport,
                  style: miuix.textStyles.button.copyWith(
                    color: miuixColors.onPrimary,
                  ),
                ),
              ],
            ),
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
    final miuix = MiuixTheme.of(context);
    final miuixColors = miuix.colors;
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
                onSubmitted: onAddItem,
              ),
            ),
            const SizedBox(width: 8),
            MiuixButton(
              onPressed: () => onAddItem(itemController.text),
              minHeight: 40,
              cornerRadius: 14,
              insideMargin: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              colors: MiuixButtonDefaults.buttonColorsPrimary(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: miuixColors.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  MiuixText(
                    l10n.add,
                    style: miuix.textStyles.footnote1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: miuixColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: objects.isEmpty
              ? QuestopiaSheetEmptyState(
                  icon: Icons.inventory_2_rounded,
                  message: l10n.inventoryIsEmpty,
                )
              : ListView(
                  children: [
                    MiuixCard(
                      cornerRadius: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < objects.length; i++) ...[
                            if (i > 0)
                              const Padding(
                                padding: EdgeInsets.only(left: 48),
                                child: MiuixHorizontalDivider(),
                              ),
                            MiuixBasicComponent(
                              title: objects[i].name,
                              insideMargin: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 11,
                              ),
                              startAction: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.inventory_2_rounded,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              ),
                              endActions: [
                                IconButton(
                                  tooltip: l10n.remove,
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: colors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    final ok =
                                        notifier.removeItem(objects[i].name);
                                    if (!ok) {
                                      showSheetSnackBar(
                                        context,
                                        l10n.couldNotRemoveItem,
                                      );
                                    }
                                  },
                                ),
                              ],
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
    final miuix = MiuixTheme.of(context);
    final miuixColors = miuix.colors;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: MiuixCard(
            cornerRadius: 20,
            insideMargin: const EdgeInsets.all(14),
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
            MiuixButton(
              onPressed: onRunConsole,
              minHeight: 40,
              cornerRadius: 14,
              insideMargin: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              colors: MiuixButtonDefaults.buttonColorsPrimary(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 18,
                    color: miuixColors.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  MiuixText(
                    l10n.run,
                    style: miuix.textStyles.footnote1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: miuixColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
