import 'package:flutter/material.dart';

/// Deterministic offline poster stand-in: a coloured tile with the game initial.
///
/// The colour is derived from the title hash, so the same game always renders
/// the same tile across sessions and devices without any stored state.
class PosterFallback extends StatelessWidget {
  const PosterFallback({
    super.key,
    required this.title,
    required this.colors,
  });

  final String title;
  final ColorScheme colors;

  /// Distinct hues that stay legible with white foreground text.
  static const List<int> _palette = <int>[
    0xFF5C6BC0,
    0xFF26A69A,
    0xFFEF6C00,
    0xFF8E24AA,
    0xFF00897B,
    0xFFD81B60,
    0xFF3949AB,
    0xFF6D4C41,
  ];

  Color get _background {
    if (title.isEmpty) return colors.secondaryContainer;
    var hash = 0;
    for (final unit in title.codeUnits) {
      hash = (hash * 31 + unit) & 0x7FFFFFFF;
    }
    return Color(_palette[hash % _palette.length]);
  }

  String get _initial {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortest = constraints.biggest.shortestSide;
        final usable = shortest.isFinite && shortest > 0 ? shortest : 96.0;
        return Container(
          color: _background,
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                _initial,
                style: TextStyle(
                  fontSize: usable * 0.46,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
