/// Result of a storage audit over the local game library.
class StorageStats {
  const StorageStats({this.perGameBytes = const {}});

  const StorageStats.empty() : perGameBytes = const {};

  /// Folder path to the number of bytes that folder occupies on disk.
  final Map<String, int> perGameBytes;

  int get totalBytes =>
      perGameBytes.values.fold(0, (sum, value) => sum + value);

  int get gameCount => perGameBytes.length;

  int bytesFor(String folderPath) => perGameBytes[folderPath] ?? 0;

  bool get isEmpty => perGameBytes.isEmpty;
}
