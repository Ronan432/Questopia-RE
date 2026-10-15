/// Variable name discovery for the cheat console.
///
/// Discovery works by probing the engine for a candidate name and keeping it
/// only when the engine reports a value. Reading raw engine memory is
/// deliberately not an option: the native variable table (`qspVars`) is not
/// part of the exported C-API symbol set, so it cannot be resolved, and guessing
/// the struct stride would walk past the end of a real allocation.
library;

/// Candidate names probed in addition to the tokens found in the game text.
///
/// These are the counters and stats QSP games almost universally define, so the
/// list gives the cheat console something useful to show in a fresh game whose
/// descriptions do not name their variables yet.
const List<String> kCommonQspVarNames = [
  'money', 'gold', 'cash', 'rub', 'rubles', 'coins', 'hp', 'health',
  'maxhp', 'mana', 'mp', 'energy', 'stamina', 'exp', 'level', 'lvl',
  'stat', 'points', 'str', 'agi', 'dex', 'int', 'vit', 'cha', 'luc',
  'day', 'hour', 'min', 'sec', 'month', 'year', 'score', 'age',
  'mood', 'hunger', 'thirst', 'sleep', 'hygiene', 'reputation', 'fame',
  'lust', 'arousal', 'stress', 'weight', 'height', 'curloc', 'loc',
  'caller', 'args', 'result',
];

/// Extracts candidate identifier tokens from the game description text.
///
/// The result is unsorted and may repeat a name; callers probe each entry and
/// collect the survivors into a set.
List<String> extractVarTokens(String varsDesc, String mainDesc) {
  final text = '$varsDesc $mainDesc';
  if (text.trim().isEmpty) return const [];

  final tokens = <String>[];
  for (final match in RegExp(r'\b([a-zA-Z_][a-zA-Z0-9_]{0,35})\b').allMatches(text)) {
    final token = match.group(1);
    if (token != null && token.length >= 2) tokens.add(token);
  }
  return tokens;
}
