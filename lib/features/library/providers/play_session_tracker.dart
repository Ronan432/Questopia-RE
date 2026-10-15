import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../game/providers/game_engine_provider.dart';
import '../data/play_stats_store.dart';

/// How often accumulated seconds are flushed to disk.
///
/// A short interval keeps a crash from losing more than half a minute of play
/// time while staying far too infrequent to matter for battery or IO.
const Duration playStatsFlushInterval = Duration(seconds: 30);

/// Counts how long the game screen has been open and loaded.
///
/// The tracker owns its own periodic timer rather than sharing the engine's:
/// the engine timer drives game logic, and mixing the two would make play-time
/// accounting depend on engine internals. Flushing is delegated to
/// [PlayStatsStore], which serializes and atomically writes every update.
class PlaySessionTracker {
  PlaySessionTracker({PlayStatsStore? store}) : _store = store;

  PlayStatsStore? _store;
  String? _gameId;
  Timer? _timer;

  /// Seconds counted since the last successful flush.
  int _pendingSeconds = 0;

  /// True while the app is in the foreground and the game screen is visible.
  bool _isActive = false;

  bool get isTracking => _gameId != null && _isActive;
  String? get gameId => _gameId;

  /// Begins counting for [gameId].
  ///
  /// Restarting with the same id keeps the accumulated pending seconds so a
  /// brief lifecycle bounce does not discard time.
  Future<void> start(String gameId) async {
    if (_gameId == gameId && _timer != null) {
      _isActive = true;
      return;
    }
    await stop();
    _gameId = gameId;
    _pendingSeconds = 0;
    _isActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    final store = await _resolveStore();
    await store.markPlayed(gameId);
    debugPrint('[QUESTOPIA_PLAY_STATS] Session started for "$gameId"');
  }

  /// Pauses counting without dropping the accumulated seconds.
  void pause() {
    _isActive = false;
  }

  /// Resumes counting after a pause.
  void resume() {
    if (_gameId == null) return;
    _isActive = true;
  }

  /// Stops counting, flushes the remainder and clears the session.
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    final id = _gameId;
    _gameId = null;
    _isActive = false;
    if (id == null) {
      _pendingSeconds = 0;
      return;
    }
    await _flush(id, force: true);
  }

  /// Writes any pending seconds without ending the session.
  Future<void> flush() async {
    final id = _gameId;
    if (id == null) return;
    await _flush(id, force: true);
  }

  void _tick() {
    if (!_isActive) return;
    _pendingSeconds++;
    if (_pendingSeconds >= playStatsFlushInterval.inSeconds) {
      unawaited(_flush(_gameId, force: false));
    }
  }

  Future<void> _flush(String? id, {required bool force}) async {
    if (id == null) return;
    final seconds = _pendingSeconds;
    if (seconds <= 0) return;
    if (!force && seconds < playStatsFlushInterval.inSeconds) return;
    _pendingSeconds = 0;
    final store = await _resolveStore();
    await store.addPlayTime(id, seconds: seconds);
    debugPrint(
        '[QUESTOPIA_PLAY_STATS] Flushed ${seconds}s for "$id"');
  }

  Future<PlayStatsStore> _resolveStore() async {
    return _store ??= await PlayStatsStore.open();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _gameId = null;
    _isActive = false;
    _pendingSeconds = 0;
  }
}

/// Owns the single [PlaySessionTracker] for the app.
final playSessionTrackerProvider =
    Provider<PlaySessionTracker>((ref) {
  final tracker = PlaySessionTracker();
  ref.onDispose(tracker.dispose);
  return tracker;
});

/// The id used to file notes and play statistics for the running game.
///
/// Falls back to the folder path when a registry entry has no id, matching how
/// the registry itself resolves identity.
final activeGameKeyProvider = Provider<String?>((ref) {
  final game = ref.watch(gameEngineProvider).activeGame;
  if (game == null) return null;
  final id = game.id.trim();
  if (id.isNotEmpty) return id;
  final folder = game.folderPath.trim();
  return folder.isEmpty ? null : folder;
});
