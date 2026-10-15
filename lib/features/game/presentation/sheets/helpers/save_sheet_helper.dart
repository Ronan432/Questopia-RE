import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../../../core/helpers/sheet_ui_helper.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../providers/game_engine_provider.dart';

/// Helper for importing and exporting .sav files in save slots sheet.
class SaveImportExportRow extends StatelessWidget {
  const SaveImportExportRow({super.key, required this.engineNotifier});

  final GameEngineNotifier engineNotifier;

  Future<void> _handleImport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['sav'],
        withData: true,
      );
    } catch (_) {
      result = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    }

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.single;
      bool ok = false;
      if (pickedFile.bytes != null && pickedFile.bytes!.isNotEmpty) {
        ok = engineNotifier.restoreSaveSnapshot(pickedFile.bytes!);
      } else if (pickedFile.path != null && pickedFile.path!.isNotEmpty) {
        ok = await engineNotifier.importSaveFile(pickedFile.path!);
      }

      if (context.mounted) {
        if (ok) navigator.pop();
        showSheetSnackBar(
          context,
          ok ? l10n.saveImported : l10n.saveImportFailed,
        );
      }
    }
  }

  Future<void> _handleExport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final bytes = engineNotifier.takeSaveSnapshot();
    if (bytes == null || bytes.isEmpty) {
      showSheetSnackBar(context, l10n.noActiveSaveData);
      return;
    }
    String? result;
    try {
      result = await FilePicker.platform.saveFile(
        dialogTitle: l10n.exportSaveFileDialog,
        fileName: 'game_save.sav',
        type: FileType.custom,
        allowedExtensions: ['sav'],
        bytes: bytes,
      );
    } catch (_) {
      result = await FilePicker.platform.saveFile(
        dialogTitle: l10n.exportSaveFileDialog,
        fileName: 'game_save.sav',
        type: FileType.any,
        bytes: bytes,
      );
    }

    if (result != null && result.isNotEmpty) {
      if (!kIsWeb) {
        try {
          final file = File(result);
          await file.writeAsBytes(bytes, flush: true);
        } catch (_) {}
      }
      if (context.mounted) showSheetSnackBar(context, l10n.saveFileExported);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: M3EButton.icon(
            onPressed: () => _handleImport(context),
            size: M3EButtonSize.sm,
            style: M3EButtonStyle.outlined,
            icon: const Icon(Icons.file_upload_outlined, size: 18),
            label: Text(l10n.importSav),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: M3EButton.icon(
            onPressed: () => _handleExport(context),
            size: M3EButtonSize.sm,
            style: M3EButtonStyle.outlined,
            icon: const Icon(Icons.file_download_outlined, size: 18),
            label: Text(l10n.exportSav),
          ),
        ),
      ],
    );
  }
}
