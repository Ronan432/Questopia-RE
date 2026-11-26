import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_segmented_list/material_segmented_list.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import '../theme/questopia_theme.dart';
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

  /// Displays a choice modal matching the Settings segmented list style allowing
  /// the user to select between importing a game file/archive or selecting an extracted game folder.
  static Future<String?> pickGame(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.maybeOf(context);

    final int? option;
    if (miuix != null) {
      option = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: miuix.colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => MiuixTheme(
          data: miuix,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: MiuixText(
                      l10n.importGame,
                      textAlign: TextAlign.center,
                      style: miuix.textStyles.title4.copyWith(
                        color: miuix.colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  MiuixCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MiuixArrowPreference(
                          title: l10n.fileOrArchive,
                          summary: l10n.fileOrArchiveHint,
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              color: miuix.colors.primary,
                              size: 22,
                            ),
                          ),
                          onClick: () => Navigator.pop(ctx, 1),
                        ),
                        MiuixArrowPreference(
                          title: l10n.gameFolder,
                          startAction: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MiuixIcon(
                              vector: MiuixIcons.os4.folder,
                              tint: miuix.colors.primary,
                              size: 22,
                            ),
                          ),
                          onClick: () => Navigator.pop(ctx, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  MiuixTextButton(
                    l10n.cancel,
                    onPressed: () => Navigator.pop(ctx, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      option = await showQuestopiaSheet<int>(
      context: context,
      builder: (ctx) {
        return M3ETheme(
          data: QuestopiaTheme.m3eThemeDataFrom(Theme.of(ctx)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuestopiaSheetHeaderPill(title: l10n.importGame),
                SegmentedListSection(
                  children: [
                    SegmentedListTile(
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(l10n.fileOrArchive),
                      subtitle: Text(l10n.fileOrArchiveHint),
                      trailing: const Icon(Icons.chevron_right),
                      minVerticalPadding: 12,
                      onTap: () => Navigator.pop(ctx, 1),
                    ),
                    SegmentedListTile(
                      leading: const Icon(Icons.folder_open_outlined),
                      title: Text(l10n.gameFolder),
                      trailing: const Icon(Icons.chevron_right),
                      minVerticalPadding: 12,
                      onTap: () => Navigator.pop(ctx, 2),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: M3EButton.icon(
                    onPressed: () => Navigator.pop(ctx, 0),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    label: Text(l10n.cancel),
                    style: M3EButtonStyle.outlined,
                    size: M3EButtonSize.lg,
                    shape: M3EButtonShape.round,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    }

    if (!context.mounted || option == null || option == 0) return null;

    if (option == 1) {
      return pickGameFile(context);
    } else if (option == 2) {
      return pickDirectory(context, title: l10n.selectGameFolder);
    }

    return null;
  }
}
