import 'package:flutter/material.dart';
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
    final primaryItems = <Widget>[
      miuixArrowPreference(
        context: context,
        title: l10n.saveAndLoad,
        iconName: 'save',
        onClick: () {
          Navigator.pop(context);
          showQuestopiaSheet<void>(
            context: context,
            title: l10n.savesAndSlots,
            builder: (_) => const SaveSlotsSheet(),
          );
        },
      ),
      miuixArrowPreference(
        context: context,
        title: l10n.gameNotes,
        iconName: 'edit',
        onClick: () {
          Navigator.pop(context);
          showQuestopiaSheet<void>(
            context: context,
            title: l10n.gameNotes,
            builder: (_) => const NotesSheet(),
          );
        },
      ),
      miuixArrowPreference(
        context: context,
        title: l10n.openSaveFile,
        iconName: 'folder',
        onClick: () {
          Navigator.pop(context);
          ref.read(gameEngineProvider.notifier).showFileLoad();
        },
      ),
    ];

    final advancedItems = <Widget>[
      if (settings.isCheatsEnabled)
        miuixArrowPreference(
          context: context,
          title: l10n.cheatEngine,
          iconName: 'tune',
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
        miuixArrowPreference(
          context: context,
          title: l10n.qspCommandLine,
          iconName: 'memoryFunction',
          onClick: () {
            Navigator.pop(context);
            ref.read(gameEngineProvider.notifier).showExecutor();
          },
        ),
      miuixArrowPreference(
        context: context,
        title: l10n.restartGame,
        iconName: 'refresh',
        onClick: () {
          Navigator.pop(context);
          ref.read(gameEngineProvider.notifier).showRestartConfirmation();
        },
      ),
    ];

    // One merged card for every option, the same shape the settings screen
    // uses, instead of a separate card per group.
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: MiuixSettingsGroup(
        children: [...primaryItems, ...advancedItems],
      ),
    );
  }
}
