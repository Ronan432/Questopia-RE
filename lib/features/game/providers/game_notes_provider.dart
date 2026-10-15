import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/game_notes_store.dart';
import '../data/note_tab.dart';

/// Shared handle to the per-game tabbed notes store.
final gameNotesStoreProvider = FutureProvider<GameNotesStore>((ref) {
  return GameNotesStore.open();
});

/// The note tabs of one game, keyed by game id.
///
/// Tabs are read once when the sheet opens and every mutation writes the whole
/// list back to disk, so the in-memory list and the JSON file never diverge.
/// Blank tab bodies are kept: a tab disappears only through [deleteTab].
final gameNotesTabsProvider =
    AsyncNotifierProvider.family<GameNotesTabsNotifier, List<NoteTab>, String>(
  GameNotesTabsNotifier.new,
);

/// Loads and mutates the note tabs of a single game.
class GameNotesTabsNotifier
    extends FamilyAsyncNotifier<List<NoteTab>, String> {
  GameNotesStore? _store;

  @override
  Future<List<NoteTab>> build(String gameId) async {
    final store = await ref.watch(gameNotesStoreProvider.future);
    _store = store;
    return store.readTabs(gameId);
  }

  /// Persists [tabs] and publishes them as the new state.
  Future<void> _persist(List<NoteTab> tabs) async {
    final store = _store;
    if (store == null) {
      final opened = await ref.read(gameNotesStoreProvider.future);
      _store = opened;
      await opened.writeTabs(arg, tabs);
    } else {
      await store.writeTabs(arg, tabs);
    }
    state = AsyncData<List<NoteTab>>(tabs);
  }

  /// Appends a blank tab named [title] and returns its identifier.
  ///
  /// Returns null while the tab list is still loading, because appending to an
  /// unknown list would silently drop the notes already on disk.
  Future<String?> addTab(String title) async {
    final current = state.valueOrNull;
    if (current == null) return null;
    final tab = NoteTab(id: GameNotesStore.newTabId(), title: title);
    await _persist(<NoteTab>[...current, tab]);
    return tab.id;
  }

  /// Removes the tab with [tabId].
  ///
  /// The last remaining tab is never deleted: the sheet always needs one page
  /// to write in, so this is a no-op for a single-tab list.
  Future<void> deleteTab(String tabId) async {
    final current = state.valueOrNull;
    if (current == null || current.length <= 1) return;
    final remaining = current.where((tab) => tab.id != tabId).toList();
    if (remaining.length == current.length) return;
    await _persist(remaining);
  }

  /// Renames the tab with [tabId], ignoring a blank [title].
  Future<void> renameTab(String tabId, String title) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _persist(<NoteTab>[
      for (final tab in current)
        tab.id == tabId ? tab.copyWith(title: trimmed) : tab,
    ]);
  }

  /// Replaces the body of the tab with [tabId].
  Future<void> updateTabText(String tabId, String text) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await _persist(<NoteTab>[
      for (final tab in current)
        tab.id == tabId ? tab.copyWith(text: text) : tab,
    ]);
  }
}
