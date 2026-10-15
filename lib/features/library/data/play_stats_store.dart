import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Play statistics for a single game.
class PlayStats {
  final int totalSeconds;
  final DateTime? lastPlayed;

  const PlayStats({this.totalSeconds = 0, this.lastPlayed});

  bool get hasPlayed => totalSeconds > 0 || lastPlayed != null;

  Map<String, dynamic> toJson() => {
        'totalSeconds': totalSeconds,
        'lastPlayed': lastPlayed?.toIso8601String(),
      };

  factory PlayStats.fromJson(Map<String, dynamic> json) => PlayStats(
        totalSeconds: (json['totalSeconds'] as num?)?.toInt() ?? 0,
        lastPlayed: DateTime.tryParse(json['lastPlayed'] as String? ?? ''),
      );
}

/// Persistent, atomic play-time ledger stored in the app support directory.
///
/// Follows the [GameRegistry] discipline: every mutation is serialized through
/// `_locked` and written to a `.tmp` file that is then renamed over the target,
/// so a crash mid-write can never leave a partially written file behind.
class PlayStatsStore {
  PlayStatsStore._(this._file);

  final File _file;
  final Map<String, PlayStats> _cache = {};
  Future<void> _tail = Future.value();
  bool _loaded = false;

  static Future<PlayStatsStore> open() async {
    final dir = await _storageDirectory();
    return PlayStatsStore._(File(p.join(dir.path, 'questopia_play_stats.json')));
  }

  static Future<Directory> _storageDirectory() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (_) {
      return getApplicationDocumentsDirectory();
    }
  }

  /// Sanitizes a game id so it is safe to use as a JSON key and log value.
  static String normalizeId(String id) =>
      id.trim().isEmpty ? 'unknown' : id.trim();

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

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    if (!await _file.exists()) return;
    try {
      final decoded = jsonDecode(await _file.readAsString());
      if (decoded is! Map) return;
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is Map) {
          _cache[entry.key.toString()] =
              PlayStats.fromJson(Map<String, dynamic>.from(value));
        }
      }
    } catch (e) {
      debugPrint('[QUESTOPIA_PLAY_STATS] Read error: $e');
    }
  }

  Future<void> _flush() async {
    if (!await _file.parent.exists()) {
      await _file.parent.create(recursive: true);
    }
    final payload = {
      for (final entry in _cache.entries) entry.key: entry.value.toJson(),
    };
    final tmp = File('${_file.path}.tmp');
    await tmp.writeAsString(jsonEncode(payload), flush: true);
    await tmp.rename(_file.path);
  }

  /// Returns the stats for [gameId], or empty stats when nothing is recorded.
  Future<PlayStats> read(String gameId) => _locked(() async {
        await _ensureLoaded();
        return _cache[normalizeId(gameId)] ?? const PlayStats();
      });

  /// Returns every recorded entry keyed by game id.
  Future<Map<String, PlayStats>> readAll() => _locked(() async {
        await _ensureLoaded();
        return Map<String, PlayStats>.unmodifiable(_cache);
      });

  /// Adds [seconds] to the running total and stamps the last-played time.
  ///
  /// Called periodically while a game is open, so it must stay cheap and never
  /// throw into the caller.
  Future<PlayStats> addPlayTime(
    String gameId, {
    required int seconds,
    DateTime? now,
  }) =>
      _locked(() async {
        await _ensureLoaded();
        final id = normalizeId(gameId);
        final previous = _cache[id] ?? const PlayStats();
        final updated = PlayStats(
          totalSeconds: previous.totalSeconds + (seconds < 0 ? 0 : seconds),
          lastPlayed: now ?? DateTime.now(),
        );
        _cache[id] = updated;
        try {
          await _flush();
        } catch (e) {
          debugPrint('[QUESTOPIA_PLAY_STATS] Write error: $e');
        }
        return updated;
      });

  /// Records a session start without adding time, so "last played" stays exact.
  Future<PlayStats> markPlayed(String gameId, {DateTime? now}) => _locked(() async {
        await _ensureLoaded();
        final id = normalizeId(gameId);
        final previous = _cache[id] ?? const PlayStats();
        final updated = PlayStats(
          totalSeconds: previous.totalSeconds,
          lastPlayed: now ?? DateTime.now(),
        );
        _cache[id] = updated;
        try {
          await _flush();
        } catch (e) {
          debugPrint('[QUESTOPIA_PLAY_STATS] Write error: $e');
        }
        return updated;
      });

  /// Drops the entry for [gameId]; used when a game leaves the library.
  Future<void> remove(String gameId) => _locked(() async {
        await _ensureLoaded();
        if (_cache.remove(normalizeId(gameId)) == null) return;
        try {
          await _flush();
        } catch (e) {
          debugPrint('[QUESTOPIA_PLAY_STATS] Write error: $e');
        }
      });
}
