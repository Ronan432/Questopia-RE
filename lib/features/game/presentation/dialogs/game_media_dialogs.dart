import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/media/poster_menu_sheet.dart';
import '../../../../core/media/qsp_media_kind.dart';
import '../../../../core/providers/settings_provider.dart';
import 'game_media_viewer.dart';

/// Image and video preview dialog.
class GameImagePreviewDialog extends ConsumerWidget {
  const GameImagePreviewDialog({
    super.key,
    required this.imageUrl,
    required this.onClose,
  });

  final String imageUrl;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVideo = detectMediaKind(imageUrl) == QspMediaKind.video;
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return QuestopiaDialog(
      maxWidth: settings.isFullscreenImages ? 640 : 380,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isVideo ? l10n.videoPreview : l10n.imagePreview),
          if (imageUrl.isNotEmpty)
            IconButton(
              tooltip: l10n.options,
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () => showPosterMenuSheet(
                context: context,
                imageUri: imageUrl,
              ),
            ),
        ],
      ),
      content: GameMediaViewer(
        mediaPath: imageUrl,
        maxHeight: 320,
        enableZoom: settings.isPinchZoomEnabled,
        forceFullscreen: settings.isFullscreenImages,
      ),
      actions: [
        QuestopiaMorphButton.filled(
          onPressed: onClose,
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

/// Restart game confirmation dialog.
class GameRestartConfirmationDialog extends StatelessWidget {
  const GameRestartConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return QuestopiaConfirmationDialog(
      icon: Icons.restart_alt_rounded,
      isDestructive: true,
      title: l10n.restartGameTitle,
      message: l10n.restartGameMessage,
      confirmLabel: l10n.restart,
      cancelLabel: l10n.cancel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}

/// QSP console executor modal dialog.
class GameExecutorDialog extends StatefulWidget {
  const GameExecutorDialog({
    super.key,
    required this.output,
    required this.onRun,
    required this.onClose,
  });

  final String output;
  final ValueChanged<String> onRun;
  final VoidCallback onClose;

  @override
  State<GameExecutorDialog> createState() => _GameExecutorDialogState();
}

class _GameExecutorDialogState extends State<GameExecutorDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return QuestopiaDialog(
      maxWidth: 360,
      icon: const Icon(Icons.terminal_rounded),
      title: Text(l10n.qspConsole),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.output.isEmpty ? l10n.noOutputYet : widget.output,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: colors.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              style: TextStyle(color: colors.onSurface),
              decoration: InputDecoration(
                hintText: l10n.qspCodeHint,
                hintStyle: TextStyle(color: colors.onSurfaceVariant),
                filled: true,
                fillColor: colors.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onRun(value.trim());
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        QuestopiaMorphButton.outlined(
          onPressed: widget.onClose,
          child: Text(l10n.cancel),
        ),
        QuestopiaMorphButton.filled(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onRun(_controller.text.trim());
              _controller.clear();
            }
          },
          child: Text(l10n.run),
        ),
      ],
    );
  }
}
