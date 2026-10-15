import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';

import '../../../../core/helpers/save_preview_helper.dart';
import '../../../../core/helpers/sheet_helper.dart';
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
    final themeColors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final startSlot = _page * 6;
    final isSaveMode = _selectedTab == 0;

    return QuestopiaSheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestopiaSheetHeaderPill(title: l10n.savesAndSlots),

          // Mode Tabs (Save / Load)
          Row(
            children: [
              Expanded(
                child: M3EButton.icon(
                  onPressed: () => setState(() => _selectedTab = 0),
                  size: M3EButtonSize.sm,
                  style: isSaveMode
                      ? M3EButtonStyle.filled
                      : M3EButtonStyle.outlined,
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: Text(l10n.save),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: M3EButton.icon(
                  onPressed: () => setState(() => _selectedTab = 1),
                  size: M3EButtonSize.sm,
                  style: !isSaveMode
                      ? M3EButtonStyle.filled
                      : M3EButtonStyle.outlined,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(l10n.load),
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
                    _buildAutoSaveSection(engineState, engineNotifier, themeColors),
                    const SizedBox(height: 16),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      isSaveMode ? l10n.selectSlotToSave : l10n.selectSlotToLoad,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeColors.primary,
                          ),
                    ),
                  ),

                  // Manual Slots
                  SegmentedListSection(
                    children: List.generate(6, (index) {
                      final slotIndex = startSlot + index;
                      return _buildSlotTile(
                        slotIndex,
                        isSaveMode,
                        engineNotifier,
                        themeColors,
                      );
                    }),
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

  Widget _buildAutoSaveSection(
    GameEngineState engineState,
    GameEngineNotifier engineNotifier,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            l10n.autoSave,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
          ),
        ),
        SegmentedListSection(
          children: [
            SegmentedListTile(
              leading: Icon(Icons.autorenew_rounded, color: colors.primary),
              title: Text(l10n.autoSaveSlot),
              subtitle: engineState.autoSaveData != null
                  ? _buildSlotSubtitle(
                      engineState.autoSaveData!,
                      engineState.autoSaveTimestamp,
                      colors,
                    )
                  : Text(
                      l10n.noAutoSaveDataFound,
                      style: TextStyle(
                        color: colors.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
              trailing: engineState.autoSaveData != null
                  ? M3EButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        engineNotifier.loadFromSlot(-1);
                      },
                      size: M3EButtonSize.sm,
                      style: M3EButtonStyle.tonal,
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: Text(l10n.load),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the two-line subtitle for an occupied slot: the stripped preview
  /// of the saved game text plus a human readable "saved at" line.
  Widget _buildSlotSubtitle(
    Uint8List data,
    DateTime? savedAt,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final preview = SavePreviewHelper.extractPreview(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          preview.isEmpty ? l10n.savedGameState : preview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: colors.onSurface),
        ),
        const SizedBox(height: 2),
        Text(
          savedAt == null
              ? l10n.emptySlotHint
              : SavePreviewHelper.formatSavedAt(l10n, savedAt),
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  SegmentedListTile _buildSlotTile(
    int slotIndex,
    bool isSaveMode,
    GameEngineNotifier engineNotifier,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final engineState = ref.watch(gameEngineProvider);
    final data = engineState.saveSlots[slotIndex];
    final hasData = data != null && data.isNotEmpty;
    final savedAt = engineState.saveSlotTimestamps[slotIndex];

    final subtitle = hasData
        ? _buildSlotSubtitle(data, savedAt, colors)
        : Text(
            l10n.emptySlotHint,
            style: TextStyle(
              color: colors.outline,
              fontStyle: FontStyle.italic,
            ),
          );

    return SegmentedListTile(
      leading: CircleAvatar(
        backgroundColor:
            hasData ? colors.primaryContainer : colors.surfaceContainerHigh,
        child: Text(
          '${slotIndex + 1}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: hasData ? colors.onPrimaryContainer : colors.outline,
          ),
        ),
      ),
      title: Text(l10n.slotTitle(slotIndex + 1)),
      subtitle: subtitle,
      trailing: isSaveMode
          ? M3EButton.icon(
              onPressed: () {
                engineNotifier.saveToSlot(slotIndex);
                showSheetSnackBar(
                  context,
                  l10n.savedGameToSlot(slotIndex + 1),
                );
              },
              size: M3EButtonSize.sm,
              style: hasData ? M3EButtonStyle.outlined : M3EButtonStyle.filled,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: Text(hasData ? l10n.overwrite : l10n.save),
            )
          : (hasData
              ? M3EButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    engineNotifier.loadFromSlot(slotIndex);
                  },
                  size: M3EButtonSize.sm,
                  style: M3EButtonStyle.filled,
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(l10n.load),
                )
              : null),
    );
  }
}
