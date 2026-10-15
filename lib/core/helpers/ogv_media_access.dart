import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart' as p;

/// Access control for the loopback OGV media server.
///
/// A loopback server is reachable by every process on the device, so it must
/// never serve an arbitrary path. Readable folders are therefore registered
/// in-process, and each `/player` request must present a one-shot token that
/// only this process can mint.
class OgvMediaAccess {
  /// Directories the media endpoint may read from.
  final Set<String> _allowedRoots = <String>{};

  /// One-shot values that each authorise a single `/player` request.
  final Set<String> _pendingTokens = <String>{};

  static String normalize(String path) =>
      p.normalize(p.absolute(path)).toLowerCase();

  /// Registers the game folders the media endpoint may read from and returns
  /// the one-shot token that authorises the matching `/player` request.
  ///
  /// Roots only ever enter through this call, which the app itself performs
  /// while building the WebView URL.
  String registerRoots(Iterable<String> roots) {
    for (final root in roots) {
      final trimmed = root.trim();
      if (trimmed.isNotEmpty) _allowedRoots.add(normalize(trimmed));
    }
    final token = _newToken();
    _pendingTokens.add(token);
    return token;
  }

  /// Consumes [token] and reports whether it was a valid pending value.
  ///
  /// A token is removed on use, so a captured request cannot be replayed and a
  /// guessed value never matches.
  bool consumeToken(String token) {
    if (token.isEmpty) return false;
    return _pendingTokens.remove(token);
  }

  /// Returns true when [path] sits inside one of the registered game folders.
  bool isAllowed(String path) {
    if (_allowedRoots.isEmpty) return false;
    final target = normalize(path);
    for (final root in _allowedRoots) {
      if (target == root || target.startsWith('$root${p.separator}')) {
        return true;
      }
    }
    return false;
  }

  void clear() {
    _allowedRoots.clear();
    _pendingTokens.clear();
  }

  static String _newToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}
