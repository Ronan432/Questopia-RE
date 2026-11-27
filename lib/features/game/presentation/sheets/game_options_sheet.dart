import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../settings/presentation/widgets/miuix_settings_tiles.dart';
import '../../providers/game_engine_provider.dart';
import 'cheat_modes_sheet.dart';
import 'notes_sheet.dart';
import 'save_slots_sheet.dart';

class GameOptionsSheet extends ConsumerWidget {
  const GameOptionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    const rowMargin = EdgeInsets.symmetric(horizontal: 14, vertical: 11);

    final primaryItems = <Widget>[
      MiuixArrowPreference(
        title: l10n.saveAndLoad,
        insideMargin: rowMargin,
        startAction: miuixSettingsIcon(context, 'save'),
        onClick: () {
          Navigator.pop(context);
          showQuestopiaSheet<void>(
            context: context,
            title: l10n.savesAndSlots,
            builder: (_) => const SaveSlotsSheet(),
          );
        },
      ),
      MiuixArrowPreference(
        title: l10n.gameNotes,
        insideMargin: rowMargin,
        startAction: miuixSettingsIcon(context, 'edit'),
        onClick: () {
          Navigator.pop(context);
          showQuestopiaSheet<void>(
            context: context,
            title: l10n.gameNotes,
            builder: (_) => const NotesSheet(),
          );
        },
      ),
      MiuixArrowPreference(
        title: l10n.openSaveFile,
        insideMargin: rowMargin,
        startAction: miuixSettingsIcon(context, 'folder'),
        onClick: () {
          Navigator.pop(context);
          ref.read(gameEngineProvider.notifier).showFileLoad();
        },
      ),
    ];

    final advancedItems = <Widget>[
      if (settings.isCheatsEnabled)
        MiuixArrowPreference(
          title: l10n.cheatEngine,
          insideMargin: rowMargin,
          startAction: miuixSettingsIcon(context, 'tune'),
          onClick: () {
            Navigator.pop(context);
            showQuestopiaSheet<void>(
              context: context,
              title: l10n.cheatEngineAndEditor,
              builder: (_) => const CheatModesSheet(),
            );
          },
        ),
      if (settings.isExecStringEnabled)
        MiuixArrowPreference(
          title: l10n.qspCommandLine,
          insideMargin: rowMargin,
          startAction: miuixSettingsIcon(context, 'memoryFunction'),
          onClick: () {
            Navigator.pop(context);
            ref.read(gameEngineProvider.notifier).showExecutor();
          },
        ),
      MiuixArrowPreference(
        title: l10n.restartGame,
        insideMargin: rowMargin,
        startAction: miuixSettingsIcon(context, 'refresh'),
        onClick: () {
          Navigator.pop(context);
          ref.read(gameEngineProvider.notifier).showRestartConfirmation();
        },
      ),
    ];

    // One merged card for every option, the same shape the settings screen
    // uses, instead of a separate card per group.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: MiuixSettingsGroup(
        children: [...primaryItems, ...advancedItems],
      ),
    );
  }
}
