import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'note_tab.dart';

/// Per-game free-form notes stored as one JSON file per game, holding tabs.
///
/// Notes live in the app support directory under `questopia_notes/`, never in
/// shared external storage, so they survive uninstalls of the game files but
/// stay private to the app. Writes mirror the [GameRegistry] discipline: a
/// `.tmp` file is flushed and then renamed over the target, and all mutations
/// are serialized through `_locked`.
///
/// The older single-Markdown-per-game layout is migrated on first read: the
/// `.md` body becomes the first tab and the `.md` file is deleted, so the
/// move happens exactly once and no note text is ever duplicated on disk.
class GameNotesStore {
  GameNotesStore._(this._dir);

  final Directory _dir;
  Future<void> _tail = Future.value();

  static Future<GameNotesStore> open() async {
    final base = await _supportDirectory();
    return GameNotesStore._(Directory(p.join(base.path, 'questopia_notes')));
  }

  static Future<Directory> _supportDirectory() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (_) {
      return await getApplicationDocumentsDirectory();
    }
  }

  /// Turns a game id into a filename stem that is safe on every platform.
  ///
  /// Slashes, colons and any other reserved character collapse to `_`, and the
  /// result is length-capped so a long folder path cannot overflow the path
  /// limit. A short hash of the original id is appended whenever sanitizing
  /// changed it, keeping two distinct games from colliding on one file.
  static String _stemFor(String gameId) {
    final raw = gameId.trim().isEmpty ? 'unknown' : gameId.trim();
    final sanitized = raw.replaceAll(RegExp(r'[^\w\-]+'), '_');
    final trimmed = sanitized.length > 64 ? sanitized.substring(0, 64) : sanitized;
    if (trimmed == raw && raw.length <= 64) return trimmed;
    return '${trimmed}_${raw.hashCode.toUnsigned(32).toRadixString(16)}';
  }

  /// The JSON filename that holds the tabs of [gameId].
  static String fileNameFor(String gameId) => '${_stemFor(gameId)}.json';

  /// The legacy Markdown filename that held the whole note body of [gameId].
  static String legacyFileNameFor(String gameId) => '${_stemFor(gameId)}.md';

  File _fileFor(String gameId) => File(p.join(_dir.path, fileNameFor(gameId)));

  File _legacyFileFor(String gameId) =>
      File(p.join(_dir.path, legacyFileNameFor(gameId)));

  Future<T> _locked<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.catchError((_) {}).then((_) async {
      try {
        completer.complete(await action());
      } catch (e, s) {
        completer.completeError(e, s);
      }
    });
    return completer.future;
  }

  /// Reads the tabs of [gameId]; an absent file yields an empty list.
  ///
  /// When only the legacy Markdown file exists, its body is carried into the
  /// first tab, written to JSON, and the Markdown file is removed.
  Future<List<NoteTab>> readTabs(String gameId) => _locked(() async {
        final file = _fileFor(gameId);
        try {
          if (await file.exists()) {
            return NoteTabList.decode(await file.readAsString());
          }
          return await _migrateLegacy(gameId);
        } catch (e) {
          debugPrint('[QUESTOPIA_NOTES] Read error: $e');
          return const <NoteTab>[];
        }
      });

  /// One-way migration of the pre-tabs Markdown note into a JSON tab.
  ///
  /// Migration is idempotent: it only runs while the JSON file is missing, and
  /// the source `.md` is deleted after the JSON write succeeds. An empty
  /// legacy file is simply removed.
  Future<List<NoteTab>> _migrateLegacy(String gameId) async {
    final legacy = _legacyFileFor(gameId);
    if (!await legacy.exists()) return const <NoteTab>[];

    final text = await legacy.readAsString();
    if (text.trim().isEmpty) {
      await legacy.delete();
      return const <NoteTab>[];
    }

    final migrated = <NoteTab>[
      NoteTab(id: _newTabId(), title: '', text: text),
    ];
    await _writeTabsFile(gameId, migrated);
    await legacy.delete();
    debugPrint('[QUESTOPIA_NOTES] Migrated Markdown notes for "$gameId"');
    return migrated;
  }

  /// Writes the tabs of [gameId].
  ///
  /// An empty list removes the file, matching the old blank-note behaviour.
  /// Blank tab bodies are preserved: a tab the user opened stays on disk until
  /// the user deletes that tab.
  Future<void> writeTabs(String gameId, List<NoteTab> tabs) =>
      _locked(() async {
        try {
          if (tabs.isEmpty) {
            final file = _fileFor(gameId);
            if (await file.exists()) await file.delete();
            return;
          }
          await _writeTabsFile(gameId, tabs);
          debugPrint('[QUESTOPIA_NOTES] Saved notes for "$gameId"');
        } catch (e) {
          debugPrint('[QUESTOPIA_NOTES] Write error: $e');
        }
      });

  /// Unlocked atomic write shared by [writeTabs] and the migration path.
  Future<void> _writeTabsFile(String gameId, List<NoteTab> tabs) async {
    if (!await _dir.exists()) {
      await _dir.create(recursive: true);
    }
    final file = _fileFor(gameId);
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(NoteTabList.encode(tabs), flush: true);
    await tmp.rename(file.path);
  }

  /// True when the game has any note text on disk, in either format.
  Future<bool> hasNotes(String gameId) => _locked(() async {
        try {
          final tabs = await readTabs(gameId);
          return tabs.any((tab) => tab.text.trim().isNotEmpty);
        } catch (_) {
          return false;
        }
      });

  /// Deletes every notes file for [gameId]; used when a game leaves the library.
  Future<void> remove(String gameId) => _locked(() async {
        for (final file in <File>[_fileFor(gameId), _legacyFileFor(gameId)]) {
          try {
            if (await file.exists()) await file.delete();
          } catch (e) {
            debugPrint('[QUESTOPIA_NOTES] Delete error: $e');
          }
        }
      });

  /// Creates an identifier for a new tab.
  ///
  /// The timestamp keeps ids ordered and human-readable in the JSON file, and
  /// the counter guarantees uniqueness when two tabs are added in the same
  /// millisecond.
  static int _tabCounter = 0;

  static String _newTabId() {
    _tabCounter++;
    return '${DateTime.now().microsecondsSinceEpoch}_$_tabCounter';
  }

  /// Exposes id generation so the provider can build a tab before persisting it.
  static String newTabId() => _newTabId();
}
