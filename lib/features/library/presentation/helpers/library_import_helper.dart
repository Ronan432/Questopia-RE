import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/path_picker_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/library_provider.dart';

/// Folder import flow used by the library screen toolbar and rail.
///
/// Extracted so the screen widget stays within the project line limit.
class LibraryImportHelper {
  LibraryImportHelper._();

  /// Picks a game folder and imports it, reporting the outcome in a snack bar.
  static Future<void> pickAndImport(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final path = await PathPickerHelper.pickGame(context);
    if (!context.mounted || path == null || path.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final game =
          await ref.read(libraryProvider.notifier).importGameFolder(path);
      if (game != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.importedGame(game.title))),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importFailed(e.toString()))),
      );
    }
  }
}
