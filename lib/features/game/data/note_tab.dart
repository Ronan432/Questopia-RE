import 'dart:convert';

/// One named note page inside a game's notes file.
///
/// A tab always exists once the user created it, even while its [text] is
/// still blank, so an empty page never disappears under the reader's cursor.
/// Only an explicit delete removes a tab.
class NoteTab {
  const NoteTab({
    required this.id,
    required this.title,
    this.text = '',
  });

  /// Stable identity of the tab, generated once and never reused.
  final String id;

  /// Display name shown on the tab strip; user editable.
  final String title;

  /// Markdown text held by this tab.
  final String text;

  NoteTab copyWith({String? title, String? text}) {
    return NoteTab(
      id: id,
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }

  /// Reads one tab from its decoded JSON map, tolerating missing fields.
  factory NoteTab.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final text = json['text'];
    return NoteTab(
      id: id is String && id.trim().isNotEmpty ? id : '',
      title: title is String ? title : '',
      text: text is String ? text : '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'text': text,
      };

  @override
  String toString() => 'NoteTab($id, $title, ${text.length} chars)';
}

/// Serialization helpers for the whole tab list persisted for one game.
///
/// The on-disk shape is a small versioned envelope so a future format change
/// can be detected instead of silently misread.
class NoteTabList {
  NoteTabList._();

  /// Schema version written by this build.
  static const int schemaVersion = 1;

  /// Envelope key holding the schema version.
  static const String keyVersion = 'version';

  /// Envelope key holding the serialized tab array.
  static const String keyTabs = 'tabs';

  /// Encodes [tabs] into the JSON text stored on disk.
  static String encode(List<NoteTab> tabs) {
    return jsonEncode(<String, dynamic>{
      keyVersion: schemaVersion,
      keyTabs: tabs.map((tab) => tab.toJson()).toList(),
    });
  }

  /// Decodes stored JSON text into tabs.
  ///
  /// Anything unreadable yields an empty list rather than throwing, and tabs
  /// missing an id are dropped because their identity could not be persisted.
  static List<NoteTab> decode(String raw) {
    if (raw.trim().isEmpty) return const <NoteTab>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return const <NoteTab>[];
      final entries = decoded[keyTabs];
      if (entries is! List) return const <NoteTab>[];

      final tabs = <NoteTab>[];
      for (final entry in entries) {
        if (entry is! Map) continue;
        final tab = NoteTab.fromJson(Map<String, dynamic>.from(entry));
        if (tab.id.isEmpty) continue;
        tabs.add(tab);
      }
      return tabs;
    } catch (_) {
      return const <NoteTab>[];
    }
  }
}
