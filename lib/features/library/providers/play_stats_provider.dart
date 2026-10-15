import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../library/data/play_stats_store.dart';

/// Shared handle to the on-disk play statistics ledger.
///
/// The store is opened lazily and the same instance is reused for every
/// provider that needs it, so the in-memory cache stays warm.
final playStatsStoreProvider = FutureProvider<PlayStatsStore>((ref) {
  return PlayStatsStore.open();
});

/// Play statistics for one game, keyed by game id.
///
/// Invalidating this provider re-reads the entry from the store's cache, which
/// is how the library card picks up time written by a finished session.
final playStatsProvider =
    FutureProvider.family<PlayStats, String>((ref, gameId) async {
  final store = await ref.watch(playStatsStoreProvider.future);
  return store.read(gameId);
});
