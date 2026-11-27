import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../helpers/sheet_helper.dart';
import '../l10n/app_localizations.dart';
import 'game_media.dart';

Future<void> showPosterMenuSheet({
  required BuildContext context,
  required String imageUri,
  MediaService? mediaService,
  String languageCode = 'en',
}) {
  final service = mediaService ?? MediaService();
  final l10n = AppLocalizations.of(context)!;
  return showQuestopiaSheet<void>(
    context: context,
    title: l10n.imageOptions,
    showDragHandle: true,
    builder: (sheetContext) {
      final miuix = MiuixTheme.of(sheetContext);
      final colors = miuix.colors;
      final sheetL10n = AppLocalizations.of(sheetContext)!;
      Future<void> run(
        Future<bool> Function() action,
        String ok,
        String fail,
      ) async {
        Navigator.of(sheetContext).pop();
        final messenger = ScaffoldMessenger.of(context);
        final succeeded = await action();
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text(succeeded ? ok : fail)),
        );
      }

      Widget buildPreview() {
        if (imageUri.startsWith('http://') || imageUri.startsWith('https://')) {
          return Image.network(imageUri, fit: BoxFit.cover);
        }
        return Image.file(File(imageUri), fit: BoxFit.cover);
      }

      const rowMargin = EdgeInsets.symmetric(horizontal: 14, vertical: 12);

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                color: colors.surfaceContainerHigh,
                child: buildPreview(),
              ),
            ),
            const SizedBox(height: 14),
            // One seamless card, the same shape the settings rows use.
            MiuixCard(
              cornerRadius: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiuixBasicComponent(
                    title: sheetL10n.copyImage,
                    insideMargin: rowMargin,
                    startAction: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 20,
                        color: colors.onSurfaceVariantActions,
                      ),
                    ),
                    onClick: () => run(
                      () => service.copyImage(imageUri),
                      sheetL10n.imageReferenceCopied,
                      sheetL10n.couldNotCopyImage,
                    ),
                  ),
                  MiuixBasicComponent(
                    title: sheetL10n.saveToGallery,
                    insideMargin: rowMargin,
                    startAction: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.download_rounded,
                        size: 20,
                        color: colors.onSurfaceVariantActions,
                      ),
                    ),
                    onClick: () => run(
                      () => service.saveToGallery(imageUri),
                      sheetL10n.imageSavedToGallery,
                      sheetL10n.couldNotSaveImage,
                    ),
                  ),
                  MiuixBasicComponent(
                    title: sheetL10n.searchImageOnYandex,
                    insideMargin: rowMargin,
                    startAction: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.image_search_rounded,
                        size: 20,
                        color: colors.onSurfaceVariantActions,
                      ),
                    ),
                    onClick: () => run(
                      () => service.searchImage(
                        imageUri,
                        languageCode: languageCode,
                      ),
                      sheetL10n.openingYandexSearch,
                      sheetL10n.couldNotOpenYandexSearch,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
