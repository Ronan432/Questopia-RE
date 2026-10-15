import '../../data/local_game.dart';
import '../../data/remote_game.dart';

/// Pure query filtering for the library and catalog grids.
///
/// Extracted from the library screen so that screen stays within the project
/// line limit and the matching rules can be reasoned about in isolation.
class LibraryFilterHelper {
  LibraryFilterHelper._();

  /// Local games matching [rawQuery] by title or author.
  ///
  /// When [favoritesOnly] is set, only favourite games survive the filter.
  static List<LocalGame> filterLocalGames(
    List<LocalGame> games,
    String rawQuery, {
    required bool favoritesOnly,
  }) {
    final query = rawQuery.trim().toLowerCase();
    return games
        .where((game) =>
            (query.isEmpty ||
                game.title.toLowerCase().contains(query) ||
                game.author.toLowerCase().contains(query)) &&
            (!favoritesOnly || game.isFavorite))
        .toList();
  }

  /// Catalog games matching [rawQuery] by name, author, or description.
  static List<RemoteGame> filterRemoteGames(
    List<RemoteGame> games,
    String rawQuery,
  ) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return games.toList();
    return games
        .where((game) =>
            game.displayName.toLowerCase().contains(query) ||
            game.author.toLowerCase().contains(query) ||
            game.descriptionText.toLowerCase().contains(query))
        .toList();
  }
}
