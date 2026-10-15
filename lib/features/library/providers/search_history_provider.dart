import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Maximum number of catalog search queries kept in the history.
const int kSearchHistoryLimit = 10;

/// Persisted list of recent catalog search queries, newest first.
class SearchHistoryState {
  /// Queries in display order: most recent first, unique, already trimmed.
  final List<String> queries;

  /// True until the stored history has been read from disk.
  final bool isLoading;

  const SearchHistoryState({
    this.queries = const [],
    this.isLoading = true,
  });

  bool get isEmpty => queries.isEmpty;
  bool get isNotEmpty => queries.isNotEmpty;

  SearchHistoryState copyWith({
    List<String>? queries,
    bool? isLoading,
  }) {
    return SearchHistoryState(
      queries: queries ?? this.queries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Stores the catalog search history in [SharedPreferences].
///
/// The history belongs to the repository/catalog tab only; the local library
/// keeps its own filtering and never records anything here.
class SearchHistoryNotifier extends StateNotifier<SearchHistoryState> {
  SearchHistoryNotifier() : super(const SearchHistoryState()) {
    _load();
  }

  static const String _kSearchHistory = 'pref_catalog_search_history';

  /// Reads the persisted history once, newest entry first.
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_kSearchHistory) ?? const <String>[];
      if (!mounted) return;
      state = SearchHistoryState(
        queries: List<String>.unmodifiable(stored),
        isLoading: false,
      );
    } catch (_) {
      // A failed read must not block the search box, so an empty history wins.
      if (!mounted) return;
      state = const SearchHistoryState(isLoading: false);
    }
  }

  /// Records [rawQuery] as the newest entry.
  ///
  /// Blank queries are ignored, duplicates move to the front instead of being
  /// added twice, and the list is clipped to [kSearchHistoryLimit]. A query
  /// that is already the newest entry leaves the state untouched so typing the
  /// same search repeatedly does not rebuild the dropdown.
  Future<void> record(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) return;
    if (state.queries.isNotEmpty && state.queries.first == query) return;

    final updated = <String>[
      query,
      ...state.queries.where((q) => q != query),
    ];
    if (updated.length > kSearchHistoryLimit) {
      updated.removeRange(kSearchHistoryLimit, updated.length);
    }
    await _persist(updated);
  }

  /// Removes a single [query] from the history.
  Future<void> remove(String query) async {
    if (!state.queries.contains(query)) return;
    final updated = state.queries.where((q) => q != query).toList();
    await _persist(updated);
  }

  /// Drops every stored query.
  Future<void> clear() async {
    if (state.queries.isEmpty) return;
    await _persist(const <String>[]);
  }

  /// Writes [queries] to both the in-memory state and [SharedPreferences].
  Future<void> _persist(List<String> queries) async {
    state = state.copyWith(queries: List<String>.unmodifiable(queries));
    try {
      final prefs = await SharedPreferences.getInstance();
      if (queries.isEmpty) {
        await prefs.remove(_kSearchHistory);
      } else {
        await prefs.setStringList(_kSearchHistory, queries);
      }
    } catch (_) {
      // The in-memory history stays usable even when persistence fails.
    }
  }
}

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, SearchHistoryState>((ref) {
  return SearchHistoryNotifier();
});
