/// Formats a byte count for display.
///
/// [binaryPrefix] selects the divisor: 1024 for KiB and MiB, or 1000 for KB and
/// MB. The unit label follows the chosen divisor so the number and the suffix
/// always agree.
String formatBytes(int bytes, {int binaryPrefix = 1000}) {
  final binary = binaryPrefix == 1024;
  final step = binary ? 1024 : 1000;
  final units = binary
      ? const ['B', 'KiB', 'MiB', 'GiB', 'TiB']
      : const ['B', 'KB', 'MB', 'GB', 'TB'];

  if (bytes <= 0) return '0 ${units.first}';

  var value = bytes.toDouble();
  var unit = 0;
  while (value >= step && unit < units.length - 1) {
    value /= step;
    unit++;
  }

  final digits = unit == 0
      ? 0
      : value >= 100
          ? 0
          : value >= 10
              ? 1
              : 2;
  return '${value.toStringAsFixed(digits)} ${units[unit]}';
}
