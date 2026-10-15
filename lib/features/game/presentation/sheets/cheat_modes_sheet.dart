import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/cheat_provider.dart';
import '../../providers/game_engine_provider.dart';
import 'helpers/cheat_sheet_actions.dart';
import 'helpers/cheat_sheet_views.dart';

class CheatModesSheet extends ConsumerStatefulWidget {
  const CheatModesSheet({super.key});

  @override
  ConsumerState<CheatModesSheet> createState() => _CheatModesSheetState();
}

class _CheatModesSheetState extends ConsumerState<CheatModesSheet> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addVarController = TextEditingController();
  final TextEditingController _teleportController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _consoleController = TextEditingController();
  String _consoleOutput = '';
  int _activeTabIndex = 0;

  static const _tabTitleKeys = [
    'variables',
    'locks',
    'teleport',
    'inventory',
    'console',
    'diff',
  ];

  static const _tabIcons = [
    Icons.data_object_rounded,
    Icons.lock_outline_rounded,
    Icons.explore_outlined,
    Icons.inventory_2_outlined,
    Icons.terminal_rounded,
    Icons.difference_outlined,
  ];

  /// Maps a tab index to its localized title.
  String _localizedTabTitle(AppLocalizations l10n, int index) {
    switch (_tabTitleKeys[index]) {
      case 'variables':
        return l10n.variables;
      case 'locks':
        return l10n.locks;
      case 'teleport':
        return l10n.teleport;
      case 'inventory':
        return l10n.inventory;
      case 'console':
        return l10n.console;
      default:
        return l10n.diff;
    }
  }

  @override
  void dispose() {
    ref.read(cheatProvider.notifier).rollbackIfDirty();
    _searchController.dispose();
    _addVarController.dispose();
    _teleportController.dispose();
    _itemController.dispose();
    _consoleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cheat = ref.watch(cheatProvider);
    final notifier = ref.read(cheatProvider.notifier);
    final engineState = ref.watch(gameEngineProvider);
    final l10n = AppLocalizations.of(context)!;

    return QuestopiaSheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestopiaSheetHeaderPill(title: l10n.cheatEngineAndEditor),
          const SizedBox(height: 12),

          // Category Tabs Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _tabTitleKeys.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(_tabIcons[i], size: 16),
                    label: Text(_localizedTabTitle(l10n, i)),
                    selected: _activeTabIndex == i,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(_activeTabIndex == i ? 24 : 8),
                    ),
                    onSelected: (_) {
                      HapticFeedback.lightImpact();
                      setState(() => _activeTabIndex = i);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Tab Content Body
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                CheatVariablesView(
                  cheat: cheat,
                  notifier: notifier,
                  searchController: _searchController,
                  addVarController: _addVarController,
                  onSearchChanged: () => setState(() {}),
                  onEditVar: _showEditVarDialog,
                ),
                CheatLocksView(cheat: cheat, notifier: notifier),
                CheatTeleportView(
                  controller: _teleportController,
                  onTeleport: _doTeleport,
                ),
                CheatInventoryView(
                  engineState: engineState,
                  notifier: notifier,
                  itemController: _itemController,
                  onAddItem: _doAddItem,
                ),
                CheatConsoleView(
                  consoleController: _consoleController,
                  consoleOutput: _consoleOutput,
                  onRunConsole: _runConsole,
                ),
                CheatDiffView(cheat: cheat),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditVarDialog(String varName, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showQuestopiaDialog<void>(
      context: context,
      builder: (ctx) => QuestopiaDialog(
        icon: const Icon(Icons.edit_note_rounded),
        title: Text(l10n.editVarTitle(varName)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.newValue,
            filled: true,
            fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        actions: [
          QuestopiaMorphButton.outlined(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          QuestopiaMorphButton.filled(
            onPressed: () {
              final ok = ref
                  .read(cheatProvider.notifier)
                  .setVar(varName, controller.text);
              Navigator.pop(ctx);
              if (!ok) {
                showSheetSnackBar(context, l10n.engineRejectedValue);
              }
            },
            child: Text(l10n.apply),
          ),
        ],
      ),
    );
  }

  void _doTeleport(String location) {
    final l10n = AppLocalizations.of(context)!;
    final ok = ref.read(cheatProvider.notifier).teleport(location);
    showSheetSnackBar(
      context,
      ok ? l10n.teleportedTo(location) : l10n.teleportFailed,
    );
  }

  void _doAddItem(String name) {
    if (name.trim().isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final ok = ref.read(cheatProvider.notifier).addItem(name);
    if (ok) _itemController.clear();
    showSheetSnackBar(
      context,
      ok ? l10n.itemAdded : l10n.couldNotAddItem,
    );
  }

  void _runConsole() {
    final code = _consoleController.text.trim();
    if (code.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final ok = ref.read(gameEngineProvider.notifier).execCodeBool(code);
    ref.read(cheatProvider.notifier).refresh();
    setState(() {
      // The 'OK'/'Failed' pair is the evaluation result of a QSP statement,
      // not UI chrome, so it is reported through the localized labels anyway.
      final result = ok ? l10n.ok : l10n.consoleFailed;
      _consoleOutput = '$_consoleOutput\n> $code\n$result';
    });
    _consoleController.clear();
  }
}
