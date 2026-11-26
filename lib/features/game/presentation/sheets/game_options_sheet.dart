import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
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
    final colors = MiuixTheme.of(context).colors;
    const rowMargin = EdgeInsets.symmetric(horizontal: 14, vertical: 11);

    Widget lead(String name, {MiuixVectorIcon? fallback}) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: miuixIcon(
            name,
            size: 20,
            tint: colors.onSurfaceVariantActions,
            fallback: fallback,
          ),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuestopiaSheetHeaderPill(title: l10n.gameOptions),
          MiuixCard(
            cornerRadius: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MiuixArrowPreference(
                  title: l10n.saveAndLoad,
                  insideMargin: rowMargin,
                  startAction: lead('save'),
                  onClick: () {
                    Navigator.pop(context);
                    showQuestopiaSheet<void>(
                      context: context,
                      builder: (_) => const SaveSlotsSheet(),
                    );
                  },
                ),
                MiuixArrowPreference(
                  title: l10n.gameNotes,
                  insideMargin: rowMargin,
                  startAction: lead('edit'),
                  onClick: () {
                    Navigator.pop(context);
                    showQuestopiaSheet<void>(
                      context: context,
                      builder: (_) => const NotesSheet(),
                    );
                  },
                ),
                if (settings.isCheatsEnabled)
                  MiuixArrowPreference(
                    title: l10n.cheatEngine,
                    insideMargin: rowMargin,
                    startAction: lead('tune'),
                    onClick: () {
                      Navigator.pop(context);
                      showQuestopiaSheet<void>(
                        context: context,
                        builder: (_) => const CheatModesSheet(),
                      );
                    },
                  ),
                MiuixArrowPreference(
                  title: l10n.restartGame,
                  insideMargin: rowMargin,
                  startAction: lead('refresh', fallback: MiuixIcons.os4.refresh),
                  onClick: () {
                    Navigator.pop(context);
                    ref
                        .read(gameEngineProvider.notifier)
                        .showRestartConfirmation();
                  },
                ),
                if (settings.isExecStringEnabled)
                  MiuixArrowPreference(
                    title: l10n.qspCommandLine,
                    insideMargin: rowMargin,
                    startAction: lead('code'),
                    onClick: () {
                      Navigator.pop(context);
                      ref.read(gameEngineProvider.notifier).showExecutor();
                    },
                  ),
                MiuixArrowPreference(
                  title: l10n.openSaveFile,
                  insideMargin: rowMargin,
                  startAction: lead('folder', fallback: MiuixIcons.os4.folder),
                  onClick: () {
                    Navigator.pop(context);
                    ref.read(gameEngineProvider.notifier).showFileLoad();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
