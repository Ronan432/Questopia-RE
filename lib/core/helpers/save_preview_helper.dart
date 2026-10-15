import 'dart:typed_data';

import '../l10n/app_localizations.dart';
import 'html_processor.dart';

/// Extracts a short human readable preview from raw QSP save data.
///
/// The engine serializes a save as a UTF-16 stream of CRLF separated fields.
/// Field 0 is the magic header ("QSPSAVEDGAME"), field 1 the engine version and
/// field 8 the main game description rendered when the save was taken. Text is
/// stored through the QSP character encoding, where every code unit is shifted
/// by [qspCharOffset], so the bytes must be shifted back before decoding.
class SavePreviewHelper {
  SavePreviewHelper._();

  /// Index of the main description field inside the serialized save.
  static const int _descriptionFieldIndex = 8;

  /// Number of leading fields that must be skipped to reach the description.
  static const int _headerFieldCount = _descriptionFieldIndex;

  /// QSP shifts every stored code unit by this amount (`QSP_CODREMOV`).
  static const int qspCharOffset = 5;

  /// Sentinel code unit that maps back to a literal 5 instead of 0.
  static const int qspSentinelUnit = 0xFFFB;

  /// Maximum length of the returned preview, ellipsis included.
  static const int previewLength = 60;

  /// Sentinel returned by [extractPreview] when no text could be recovered.
  static const String _empty = '';

  /// Builds a preview from the save file header without needing the game text.
  ///
  /// Returns an empty string when [data] is null, empty or unreadable, which
  /// lets the caller fall back to its own placeholder text.
  static String extractPreview(Uint8List? data) {
    final text = _describeField(data);
    if (text == null) return _empty;
    return summarize(text);
  }

  /// Collapses markup and whitespace in [raw] into a short single line.
  ///
  /// HTML tags are removed with the shared [HtmlProcessor] so the preview never
  /// leaks engine markup, and the result is clipped to [previewLength] with an
  /// ellipsis when it was longer.
  static String summarize(String raw) {
    final plain = _stripMarkup(raw);
    if (plain.isEmpty) return _empty;
    if (plain.length <= previewLength) return plain;
    return '${plain.substring(0, previewLength - 1).trimRight()}\u2026';
  }

  /// Removes HTML tags, entities and collapsed whitespace from [raw].
  static String _stripMarkup(String raw) {
    if (raw.isEmpty) return _empty;

    // Reuse the shared processor first so [img] and exec: markup is normalized
    // exactly the way the game view normalizes it.
    var text = HtmlProcessor.processHtml(raw);

    // Drop whole elements whose text content is never meant to be read.
    text = text.replaceAll(
      RegExp(r'<(script|style)\b[^>]*>.*?</\1>',
          caseSensitive: false, dotAll: true),
      ' ',
    );
    // Replace structural breaks with spaces before tags are removed so the
    // words on either side stay separated instead of being glued together.
    text = text.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      ' ',
    );
    text = text.replaceAll(
      RegExp(r'</(p|div|li|tr|h[1-6])\s*>', caseSensitive: false),
      ' ',
    );
    text = text.replaceAll(RegExp(r'<[^>]*>', dotAll: true), _empty);
    text = _decodeEntities(text);
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Characters that QSP games reference by name often enough to matter here.
  static const Map<String, String> _namedEntities = {
    'nbsp': ' ',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    'laquo': '\u00AB',
    'raquo': '\u00BB',
    'ldquo': '\u201C',
    'rdquo': '\u201D',
    'lsquo': '\u2018',
    'rsquo': '\u2019',
    'mdash': '\u2014',
    'ndash': '\u2013',
    'hellip': '\u2026',
    'copy': '\u00A9',
    'deg': '\u00B0',
    'times': '\u00D7',
  };

  /// Expands the HTML entities QSP games actually emit.
  ///
  /// Numeric references are resolved by code point and named references by
  /// [_namedEntities]; anything unrecognized is dropped along with its
  /// delimiters so a stray `\u0026laquo;` never shows up inside a preview.
  static String _decodeEntities(String text) {
    var result = text.replaceAllMapped(
      RegExp(r'&#(x?)([0-9a-fA-F]+);'),
      (m) {
        final isHex = m.group(1)!.isNotEmpty;
        final code = int.tryParse(m.group(2)!, radix: isHex ? 16 : 10);
        if (code == null || code <= 0 || code > 0x10FFFF) return _empty;
        return String.fromCharCode(code);
      },
    );
    result = result.replaceAllMapped(
      RegExp(r'&([a-zA-Z][a-zA-Z0-9]{1,10});'),
      (m) {
        final name = m.group(1)!.toLowerCase();
        // Ampersand is resolved from the table so it is not re-scanned.
        return _namedEntities[name] ?? _empty;
      },
    );
    return result;
  }

  /// Reads the main description field out of the serialized [data].
  static String? _describeField(Uint8List? data) {
    final fields = splitFields(data);
    if (fields.length <= _descriptionFieldIndex) return null;
    return fields[_descriptionFieldIndex];
  }

  /// Splits raw save [data] into its CRLF separated, decoded fields.
  ///
  /// Returns an empty list when the payload is too small or is not a save.
  static List<String> splitFields(Uint8List? data) {
    if (data == null || data.length < 4) return const [];
    final units = _decodeUnits(data);
    if (units.isEmpty) return const [];

    final fields = <String>[];
    final buffer = StringBuffer();
    for (final unit in units) {
      if (unit == 0x0D) continue; // CR is a separator only when paired with LF.
      if (unit == 0x0A) {
        fields.add(buffer.toString());
        buffer.clear();
        continue;
      }
      buffer.writeCharCode(unit);
    }
    fields.add(buffer.toString());
    return fields;
  }

  /// Converts the UTF-16 payload back into QSP code units.
  static List<int> _decodeUnits(Uint8List data) {
    final count = data.length ~/ 2;
    final units = <int>[];
    final view = ByteData.sublistView(data);
    for (var i = 0; i < count; i++) {
      final stored = view.getUint16(i * 2, Endian.little);
      // The shift is inverted here; the sentinel keeps a literal five intact.
      units.add(stored == qspSentinelUnit ? qspCharOffset : stored - qspCharOffset);
    }
    return units;
  }

  /// Confirms that [data] starts with the QSP save magic header.
  static bool looksLikeSaveData(Uint8List? data) {
    final fields = splitFields(data);
    if (fields.length <= _headerFieldCount) return false;
    return fields.first.startsWith('QSPSAVEDGAME');
  }

  /// Formats the age of [timestamp] using localized, human readable wording.
  ///
  /// Falls back to an absolute numeric date for anything older than a week.
  static String formatSavedAt(AppLocalizations l10n, DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.isNegative || diff.inMinutes < 1) return l10n.saveTimeJustNow;
    if (diff.inMinutes < 60) return l10n.saveTimeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.saveTimeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.saveTimeYesterday;
    if (diff.inDays < 7) return l10n.saveTimeDaysAgo(diff.inDays);
    return formatAbsoluteDate(timestamp);
  }

  /// Formats [timestamp] as a short numeric date, matching the library cards.
  static String formatAbsoluteDate(DateTime timestamp) {
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    return '$day.$month.${timestamp.year}';
  }
}
