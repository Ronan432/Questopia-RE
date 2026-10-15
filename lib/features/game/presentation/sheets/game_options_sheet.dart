import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../providers/game_engine_provider.dart';
import 'cheat_modes_sheet.dart';
import 'notes_sheet.dart';
import 'save_slots_sheet.dart';

class GameOptionsSheet extends ConsumerWidget {
  const GameOptionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    // The cheat engine and the console are gated by their settings, which used
    // to be stored but never checked.
    final settings = ref.watch(settingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestopiaSheetHeaderPill(title: l10n.gameOptions),
          const SizedBox(height: 8),
          SegmentedListSection(
            children: [
              SegmentedListTile(
                leading: const Icon(Icons.save_outlined, size: 22),
                title: Text(l10n.saveAndLoad,
                    style: const TextStyle(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(context);
                  showQuestopiaSheet<void>(
                    context: context,
                    builder: (_) => const SaveSlotsSheet(),
                  );
                },
              ),
              SegmentedListTile(
                leading: const Icon(Icons.edit_note_rounded, size: 22),
                title: Text(l10n.gameNotes,
                    style: const TextStyle(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(context);
                  showQuestopiaSheet<void>(
                    context: context,
                    builder: (_) => const NotesSheet(),
                  );
                },
              ),
              if (settings.isCheatsEnabled)
                SegmentedListTile(
                  leading: const Icon(Icons.tune_rounded, size: 22),
                  title: Text(l10n.cheatEngine,
                      style: const TextStyle(fontSize: 16)),
                  trailing:
                      Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                  onTap: () {
                    Navigator.pop(context);
                    showQuestopiaSheet<void>(
                      context: context,
                      builder: (_) => const CheatModesSheet(),
                    );
                  },
                ),
              SegmentedListTile(
                leading: const Icon(Icons.restart_alt_rounded, size: 22),
                title: Text(l10n.restartGame, style: const TextStyle(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(gameEngineProvider.notifier).showRestartConfirmation();
                },
              ),
              if (settings.isExecStringEnabled)
                SegmentedListTile(
                  leading: const Icon(Icons.terminal_rounded, size: 22),
                  title:
                      Text(l10n.qspConsole, style: const TextStyle(fontSize: 16)),
                  trailing:
                      Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(gameEngineProvider.notifier).showExecutor();
                  },
                ),
              SegmentedListTile(
                leading: const Icon(Icons.file_open_outlined, size: 22),
                title: Text(l10n.openSaveFile, style: const TextStyle(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(gameEngineProvider.notifier).showFileLoad();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
