import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String kCrashReportFileName = 'crash_report.txt';

/// Captures uncaught Flutter/framework errors to a file so the next launch
/// can offer the report, mirroring the legacy crash report dialog.
final class CrashReporter {
  CrashReporter._();

  static bool _installed = false;

  static Future<File> _reportFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, kCrashReportFileName));
  }

  static void install() {
    if (_installed) return;
    _installed = true;
    final previousFlutterOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterOnError?.call(details);
      _persist(
        'FlutterError: ${details.exceptionAsString()}\n${details.stack ?? ''}',
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _persist('Uncaught: $error\n$stack');
      return true;
    };
  }

  static Future<void> _persist(String text) async {
    try {
      final file = await _reportFile();
      final stamped = '[${DateTime.now().toIso8601String()}]\n$text\n\n';
      await file.writeAsString(stamped, mode: FileMode.append);
      await _trim(file);
    } catch (_) {
      // Reporting must never crash the app.
    }
  }

  /// Upper bound for the on-disk crash log.
  ///
  /// The log used to grow forever: a repeating error could fill the storage of
  /// the device on its own.
  static const int maxReportBytes = 64 * 1024;

  /// Keeps only the newest [maxReportBytes] of the log.
  static Future<void> _trim(File file) async {
    try {
      final length = await file.length();
      if (length <= maxReportBytes) return;
      final content = await file.readAsString();
      final keepFrom = content.length - maxReportBytes;
      // Cut on an entry boundary so the log never starts mid report.
      final cut = content.indexOf('\n[', keepFrom);
      final trimmed =
          cut >= 0 ? content.substring(cut + 1) : content.substring(keepFrom);
      await file.writeAsString(trimmed, flush: true);
    } catch (_) {
      // Trimming is best-effort.
    }
  }

  static Future<String?> takePendingReport() async {
    try {
      final file = await _reportFile();
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      if (content.trim().isEmpty) return null;
      await file.delete();
      return content;
    } catch (_) {
      return null;
    }
  }
}
