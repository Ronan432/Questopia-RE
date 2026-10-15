import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/sheet_helper.dart';
import '../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../library/providers/play_session_tracker.dart';
import '../../data/note_tab.dart';
import '../../providers/game_notes_provider.dart';
import 'helpers/notes_editor.dart';
import 'helpers/notes_tab_strip.dart';

/// Bottom sheet that lets the reader keep per-game notes across several tabs.
///
/// Saving is explicit: the Save button commits the active tab, and leaving a
/// tab with unsaved changes asks for confirmation first. An explicit commit
/// suits a note-taking surface better than debounced auto-save, because a
/// half-typed thought is never silently persisted and the user always knows
/// whether work is safe.
class NotesSheet extends ConsumerStatefulWidget {
  const NotesSheet({super.key});

  @override
  ConsumerState<NotesSheet> createState() => _NotesSheetState();
}

class _NotesSheetState extends ConsumerState<NotesSheet> {
  final TextEditingController _controller = TextEditingController();

  /// Text last loaded into the editor, used to detect unsaved edits.
  String _savedText = '';

  /// Id of the tab currently shown in the editor.
  String? _activeTabId;

  /// Whether the tab strip is folded to the active tab alone.
  bool _isTabStripCollapsed = false;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _gameId => ref.read(activeGameKeyProvider);

  bool get _isDirty => _controller.text != _savedText;

  /// Loads [tab] into the editor, replacing whatever was shown before.
  void _showTab(NoteTab tab) {
    _activeTabId = tab.id;
    _savedText = tab.text;
    _controller.text = tab.text;
  }

  /// The tab the editor is bound to, falling back to the first one.
  NoteTab? _activeTab(List<NoteTab> tabs) {
    if (tabs.isEmpty) return null;
    for (final tab in tabs) {
      if (tab.id == _activeTabId) return tab;
    }
    return tabs.first;
  }

  Future<void> _save() async {    final id = _gameId;
    final tabId = _activeTabId;
    if (id == null || tabId == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);
    await ref
        .read(gameNotesTabsProvider(id).notifier)
        .updateTabText(tabId, _controller.text);
    if (!mounted) return;
    setState(() {
      _savedText = _controller.text;
      _isSaving = false;
    });
    HapticFeedback.lightImpact();
    showSheetSnackBar(context, l10n.notesTabSaved);
  }

  /// Switches the editor to [tabId], confirming first when edits are pending.
  Future<void> _selectTab(List<NoteTab> tabs, String tabId) async {
    if (tabId == _activeTabId) return;
    final target = tabs.where((tab) => tab.id == tabId).firstOrNull;
    if (target == null) return;
    if (_isDirty && !await _confirmDiscardEdits()) return;
    if (!mounted) return;
    setState(() => _showTab(target));
  }

  /// Appends a tab and switches to it.
  Future<void> _addTab(List<NoteTab> tabs) async {
    final id = _gameId;
    if (id == null) return;
    if (_isDirty && !await _confirmDiscardEdits()) return;
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final title = l10n.notesTabDefaultTitle(tabs.length + 1);
    final newId =
        await ref.read(gameNotesTabsProvider(id).notifier).addTab(title);
    final created = (ref.read(gameNotesTabsProvider(id)).valueOrNull ?? tabs)
        .where((tab) => tab.id == newId)
        .firstOrNull;
    if (!mounted || created == null) return;
    setState(() => _showTab(created));
  }

  /// Prompts for a new name and renames [tab].
  Future<void> _renameTab(NoteTab tab) async {
    final id = _gameId;
    if (id == null) return;
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: tab.title);
    final name = await showQuestopiaDialog<String>(
      context: context,
      builder: (ctx) => QuestopiaDialog(
        icon: const Icon(Icons.edit_rounded),
        title: Text(l10n.notesRenameTabTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.notesRenameTabHint,
            filled: true,
            fillColor:
                Theme.of(ctx).colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
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
              final value = controller.text.trim();
              Navigator.pop(ctx, value.isEmpty ? null : value);
            },
            child: Text(l10n.apply),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty || !mounted) return;
    await ref.read(gameNotesTabsProvider(id).notifier).renameTab(tab.id, name);
    if (!mounted) return;
    setState(() {
      if (tab.id == _activeTabId) _savedText = _controller.text;
    });
  }

  /// Deletes [tab] after confirmation, keeping at least one tab alive.
  Future<void> _deleteTab(List<NoteTab> tabs, NoteTab tab) async {
    final id = _gameId;
    if (id == null) return;
    final l10n = AppLocalizations.of(context)!;
    if (tabs.length <= 1) {
      showSheetSnackBar(context, l10n.notesLastTabHint);
      return;
    }

    final label =
        tab.title.trim().isEmpty ? l10n.notesUntitledTab : tab.title.trim();
    final confirmed = await showQuestopiaDialog<bool>(
      context: context,
      builder: (ctx) => QuestopiaConfirmationDialog(
        title: l10n.notesDeleteTabTitle,
        message: l10n.notesDeleteTabMessage(label),
        confirmLabel: l10n.delete,
        cancelLabel: l10n.cancel,
        isDestructive: true,
        icon: Icons.delete_outline_rounded,
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(gameNotesTabsProvider(id).notifier).deleteTab(tab.id);
    if (!mounted) return;
    if (tab.id == _activeTabId) {
      final remaining = ref.read(gameNotesTabsProvider(id)).valueOrNull ?? [];
      setState(() {
        final next = remaining.isEmpty ? null : remaining.first;
        if (next == null) {
          _activeTabId = null;
          _savedText = '';
          _controller.text = '';
        } else {
          _showTab(next);
        }
      });
    } else {
      setState(() {});
    }
  }

  /// Confirms before dropping unsaved edits in the active tab.
  Future<bool> _confirmDiscardEdits() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showQuestopiaDialog<bool>(
      context: context,
      builder: (ctx) => QuestopiaConfirmationDialog(
        title: l10n.notesSwitchDiscardTitle,
        message: l10n.notesSwitchDiscardMessage,
        confirmLabel: l10n.notesSwitchDiscard,
        cancelLabel: l10n.notesKeepEditing,
        isDestructive: true,
        icon: Icons.edit_note_rounded,
      ),
    );
    return confirmed == true;
  }

  /// Confirms before dropping unsaved edits, then closes the sheet.
  Future<void> _confirmClose() async {
    if (!_isDirty || await _confirmDiscardEdits()) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final id = _gameId;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _confirmClose();
      },
      child: QuestopiaSheetContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestopiaSheetHeaderPill(
              title: l10n.gameNotes,
              icon: Icons.edit_note_rounded,
            ),
            if (id == null)
              Expanded(
                child: QuestopiaSheetEmptyState(
                  icon: Icons.edit_note_rounded,
                  message: l10n.noStatusInformation,
                ),
              )
            else
              ..._buildTabbed(l10n, id),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTabbed(AppLocalizations l10n, String id) {
    final asyncTabs = ref.watch(gameNotesTabsProvider(id));

    return <Widget>[
      Expanded(
        child: asyncTabs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => QuestopiaSheetEmptyState(
            icon: Icons.error_outline_rounded,
            message: l10n.noStatusInformation,
          ),
          data: (tabs) => _buildLoaded(l10n, tabs),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: QuestopiaMorphButton.filled(
          onPressed: _isSaving || !_isDirty ? null : _save,
          child: Text(l10n.save),
        ),
      ),
    ];
  }

  Widget _buildLoaded(AppLocalizations l10n, List<NoteTab> tabs) {
    final active = _activeTab(tabs);

    // The editor binds to the resolved tab on first paint, and to the freshly
    // loaded list whenever tabs change from outside the editor.
    if (active != null && active.id != _activeTabId && !_isDirty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _showTab(active));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotesTabStrip(
          tabs: tabs,
          selectedId: active?.id,
          addTooltip: l10n.notesAddTab,
          renameTooltip: l10n.notesRenameTab,
          deleteTooltip: l10n.notesDeleteTab,
          isCollapsed: _isTabStripCollapsed,
          onToggleCollapsed: () =>
              setState(() => _isTabStripCollapsed = !_isTabStripCollapsed),
          onSelect: (tabId) => unawaited(_selectTab(tabs, tabId)),
          onAdd: () => unawaited(_addTab(tabs)),
          onRename: (tab) => unawaited(_renameTab(tab)),
          onDelete: (tab) => unawaited(_deleteTab(tabs, tab)),
        ),
        const SizedBox(height: 12),
        Expanded(child: NotesEditor(controller: _controller)),
      ],
    );
  }
}
