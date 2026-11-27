import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/save_preview_helper.dart';
import '../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/game_engine_provider.dart';
import 'helpers/save_sheet_helper.dart';

class SaveSlotsSheet extends ConsumerStatefulWidget {
  const SaveSlotsSheet({super.key});

  @override
  ConsumerState<SaveSlotsSheet> createState() => _SaveSlotsSheetState();
}

class _SaveSlotsSheetState extends ConsumerState<SaveSlotsSheet> {
  int _selectedTab = 0; // 0: Save Mode, 1: Load Mode
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final engineState = ref.watch(gameEngineProvider);
    final engineNotifier = ref.read(gameEngineProvider.notifier);
    final miuix = MiuixTheme.of(context);
    final mColors = miuix.colors;
    final l10n = AppLocalizations.of(context)!;

    final startSlot = _page * 6;
    final isSaveMode = _selectedTab == 0;

    return QuestopiaSheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode Tabs (Save / Load)
          Row(
            children: [
              Expanded(
                child: _buildModeTabButton(
                  context: context,
                  label: l10n.save,
                  icon: Icons.save_rounded,
                  selected: isSaveMode,
                  onPressed: () => setState(() => _selectedTab = 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeTabButton(
                  context: context,
                  label: l10n.load,
                  icon: Icons.download_rounded,
                  selected: !isSaveMode,
                  onPressed: () => setState(() => _selectedTab = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Content Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSaveMode) ...[
                    _buildAutoSaveSection(engineState, engineNotifier, miuix),
                    const SizedBox(height: 16),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: MiuixText(
                      isSaveMode ? l10n.selectSlotToSave : l10n.selectSlotToLoad,
                      style: miuix.textStyles.footnote1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: mColors.primary,
                      ),
                    ),
                  ),

                  // Manual Slots
                  MiuixCard(
                    cornerRadius: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int index = 0; index < 6; index++) ...[
                          if (index > 0)
                            const Padding(
                              padding: EdgeInsets.only(left: 60),
                              child: MiuixHorizontalDivider(),
                            ),
                          _buildSlotTile(
                            startSlot + index,
                            isSaveMode,
                            engineState,
                            engineNotifier,
                            miuix,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Page Navigation Bar
          QuestopiaSheetPageNav(
            currentPage: _page,
            totalPages: 10,
            onPrev: _page == 0 ? null : () => setState(() => _page--),
            onNext: _page == 9 ? null : () => setState(() => _page++),
          ),

          const SizedBox(height: 12),

          // Import / Export Actions
          SaveImportExportRow(engineNotifier: engineNotifier),
        ],
      ),
    );
  }

  Widget _buildModeTabButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    final miuix = MiuixTheme.of(context);
    final mColors = miuix.colors;
    final fg = selected ? mColors.onPrimary : mColors.onSurface;

    return MiuixButton(
      onPressed: onPressed,
      cornerRadius: 16,
      minHeight: 40,
      insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      colors: selected
          ? MiuixButtonDefaults.buttonColorsPrimary(context)
          : MiuixButtonColors(
              color: mColors.surfaceContainerHigh,
              disabledColor: mColors.disabledSecondary,
              contentColor: mColors.onSurface,
              disabledContentColor: mColors.disabledOnSecondary,
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
          MiuixText(
            label,
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveSection(
    GameEngineState engineState,
    GameEngineNotifier engineNotifier,
    MiuixThemeData miuix,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final mColors = miuix.colors;
    final hasAutoSave = engineState.autoSaveData != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: MiuixText(
            l10n.autoSave,
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: FontWeight.w600,
              color: mColors.primary,
            ),
          ),
        ),
        MiuixCard(
          cornerRadius: 20,
          child: MiuixBasicComponent(
            title: l10n.autoSaveSlot,
            summary: hasAutoSave
                ? _buildSlotSummary(
                    engineState.autoSaveData!,
                    engineState.autoSaveTimestamp,
                    l10n,
                  )
                : l10n.noAutoSaveDataFound,
            insideMargin: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            startAction: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.autorenew_rounded,
                color: mColors.primary,
                size: 22,
              ),
            ),
            endActions: [
              if (hasAutoSave)
                _buildActionButton(
                  context: context,
                  label: l10n.load,
                  icon: Icons.play_arrow_rounded,
                  isPrimary: true,
                  onPressed: () {
                    Navigator.pop(context);
                    engineNotifier.loadFromSlot(-1);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Formats the two-line summary for an occupied slot: the stripped preview
  /// of the saved game text plus a human readable "saved at" line.
  String _buildSlotSummary(
    Uint8List data,
    DateTime? savedAt,
    AppLocalizations l10n,
  ) {
    final preview = SavePreviewHelper.extractPreview(data);
    final previewLine = preview.isEmpty ? l10n.savedGameState : preview;
    final timeLine = savedAt == null
        ? l10n.emptySlotHint
        : SavePreviewHelper.formatSavedAt(l10n, savedAt);
    return '$previewLine\n$timeLine';
  }

  Widget _buildSlotTile(
    int slotIndex,
    bool isSaveMode,
    GameEngineState engineState,
    GameEngineNotifier engineNotifier,
    MiuixThemeData miuix,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final mColors = miuix.colors;
    final data = engineState.saveSlots[slotIndex];
    final hasData = data != null && data.isNotEmpty;
    final savedAt = engineState.saveSlotTimestamps[slotIndex];

    final summary = hasData
        ? _buildSlotSummary(data, savedAt, l10n)
        : l10n.emptySlotHint;

    return MiuixBasicComponent(
      title: l10n.slotTitle(slotIndex + 1),
      summary: summary,
      insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      startAction: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: hasData
                ? mColors.primaryContainer
                : mColors.surfaceContainerHigh,
            shape: MiuixSquircleBorder(cornerRadius: 10),
          ),
          child: MiuixText(
            '${slotIndex + 1}',
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: FontWeight.bold,
              color: hasData
                  ? mColors.onPrimaryContainer
                  : mColors.onSurfaceVariantSummary,
            ),
          ),
        ),
      ),
      endActions: [
        if (isSaveMode)
          _buildActionButton(
            context: context,
            label: hasData ? l10n.overwrite : l10n.save,
            icon: Icons.save_rounded,
            isPrimary: !hasData,
            onPressed: () {
              engineNotifier.saveToSlot(slotIndex);
              showSheetSnackBar(
                context,
                l10n.savedGameToSlot(slotIndex + 1),
              );
            },
          )
        else if (hasData)
          _buildActionButton(
            context: context,
            label: l10n.load,
            icon: Icons.play_arrow_rounded,
            isPrimary: true,
            onPressed: () {
              Navigator.pop(context);
              engineNotifier.loadFromSlot(slotIndex);
            },
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    final miuix = MiuixTheme.of(context);
    final mColors = miuix.colors;
    final fg = isPrimary ? mColors.onPrimary : mColors.onSurface;

    return MiuixButton(
      onPressed: onPressed,
      cornerRadius: 14,
      minHeight: 34,
      insideMargin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      colors: isPrimary
          ? MiuixButtonDefaults.buttonColorsPrimary(context)
          : MiuixButtonColors(
              color: mColors.surfaceContainerHigh,
              disabledColor: mColors.disabledSecondary,
              contentColor: mColors.onSurface,
              disabledContentColor: mColors.disabledOnSecondary,
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isPrimary ? mColors.onPrimary : mColors.primary,
          ),
          const SizedBox(width: 6),
          MiuixText(
            label,
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
