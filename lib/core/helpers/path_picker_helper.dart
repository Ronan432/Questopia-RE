import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import '../theme/miuix_icons_helper.dart';
import 'sheet_helper.dart';

class PathPickerHelper {
  /// Allowed extensions for game file selection.
  static const List<String> gameFileExtensions = [
    'qsp',
    'gam',
    'zip',
    'rar',
    'aqsp',
    '7z',
    'tar',
    'gz',
  ];

  /// Ensures storage and manage external storage permissions are requested on Android.
  static Future<bool> ensureStoragePermissions() async {
    if (!Platform.isAndroid) return true;

    try {
      if (await Permission.manageExternalStorage.isGranted) return true;
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      if (await Permission.storage.isGranted) return true;
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) return true;

      // Direct user to app settings if permission is denied
      if (status.isPermanentlyDenied ||
          status.isDenied ||
          storageStatus.isPermanentlyDenied) {
        await openAppSettings();
      }

      return await Permission.manageExternalStorage.isGranted ||
          await Permission.storage.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Opens the native file picker to select a game file or archive (.qsp, .gam, .zip, .rar, .aqsp, .7z).
  static Future<String?> pickGameFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    debugPrint('[QUESTOPIA_IMPORT] [PICKER] pickGameFile called');
    await ensureStoragePermissions();
    try {
      final file = await FilePicker.pickFile(
        type: FileType.any,
        dialogTitle: l10n.selectGameFileOrArchive,
      );

      if (file == null) {
        debugPrint(
            '[QUESTOPIA_IMPORT] [PICKER] pickGameFile cancelled by user');
        return null;
      }

      debugPrint(
          '[QUESTOPIA_IMPORT] [PICKER] File picked: name="${file.name}", path="${file.path}", size=${file.lengthSync()}');

      String pickedPath;
      if (file.path != null && file.path!.trim().isNotEmpty) {
        pickedPath = file.path!.trim();
      } else {
        final bytes = await file.readAsBytes();
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(p.join(tempDir.path, file.name));
        await tempFile.writeAsBytes(bytes);
        pickedPath = tempFile.path;
        debugPrint(
            '[QUESTOPIA_IMPORT] [PICKER] Wrote in-memory bytes to temporary file: $pickedPath');
      }

      if (pickedPath.isNotEmpty) {
        final ext = p.extension(pickedPath).replaceFirst('.', '').toLowerCase();
        debugPrint(
            '[QUESTOPIA_IMPORT] [PICKER] Resolved file path: "$pickedPath" with extension: "$ext"');
        if (gameFileExtensions.contains(ext)) {
          debugPrint(
              '[QUESTOPIA_IMPORT] [PICKER] Extension "$ext" is VALID. Returning path: "$pickedPath"');
          return pickedPath;
        } else {
          debugPrint(
              '[QUESTOPIA_IMPORT] [PICKER] Extension "$ext" is INVALID. Supported: $gameFileExtensions');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.unsupportedGameFormat(ext)),
              ),
            );
          }
        }
      }
    } catch (e, st) {
      debugPrint('[QUESTOPIA_IMPORT] [PICKER] FilePicker ERROR: $e\n$st');
    }
    return null;
  }

  /// Opens the native directory picker.
  static Future<String?> pickDirectory(
    BuildContext context, {
    String currentPath = '',
    String? title,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    debugPrint(
        '[QUESTOPIA_IMPORT] [PICKER] pickDirectory called (currentPath: "$currentPath")');
    await ensureStoragePermissions();

    try {
      final selectedPath = await FilePicker.getDirectoryPath(
        dialogTitle: title ?? l10n.selectFolder,
        initialDirectory: currentPath.isNotEmpty ? currentPath : null,
      );

      debugPrint(
          '[QUESTOPIA_IMPORT] [PICKER] Directory picker returned: "$selectedPath"');
      if (selectedPath != null && selectedPath.trim().isNotEmpty) {
        return selectedPath.trim();
      }
    } catch (e, st) {
      debugPrint('[QUESTOPIA_IMPORT] [PICKER] getDirectoryPath ERROR: $e\n$st');
    }

    return null;
  }

  /// Displays a Miuix import modal allowing the user to select between
  /// importing a game file/archive or selecting an extracted game folder.
  static Future<String?> pickGame(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final option = await showQuestopiaSheet<int>(
      context: context,
      title: l10n.importGame,
      builder: (ctx) {
        final miuix = MiuixTheme.of(ctx);
        final colors = miuix.colors;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MiuixCard(
                cornerRadius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MiuixArrowPreference(
                      title: l10n.fileOrArchive,
                      summary: l10n.fileOrArchiveHint,
                      insideMargin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      startAction: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: miuixIcon(
                          'file',
                          size: 20,
                          tint: colors.primary,
                          fallback: MiuixIcons.os4.folder,
                        ),
                      ),
                      onClick: () => Navigator.pop(ctx, 1),
                    ),
                    MiuixArrowPreference(
                      title: l10n.gameFolder,
                      insideMargin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      startAction: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: MiuixIcon(
                          vector: MiuixIcons.os4.folder,
                          tint: colors.primary,
                          size: 20,
                        ),
                      ),
                      onClick: () => Navigator.pop(ctx, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              MiuixButton(
                onPressed: () => Navigator.pop(ctx, 0),
                minHeight: 42,
                child: Text(l10n.cancel),
              ),
            ],
          ),
        );
      },
    );

    if (!context.mounted || option == null || option == 0) return null;

    if (option == 1) {
      return pickGameFile(context);
    } else if (option == 2) {
      return pickDirectory(context, title: l10n.selectGameFolder);
    }

    return null;
  }
}
