import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/native/qsp_models.dart';

/// Engine input prompt modal dialog.
class GameInputDialog extends StatefulWidget {
  const GameInputDialog({
    super.key,
    required this.prompt,
    required this.prefill,
    required this.onSubmit,
    required this.onCancel,
  });

  final String prompt;
  final String prefill;
  final ValueChanged<String> onSubmit;
  final VoidCallback onCancel;

  @override
  State<GameInputDialog> createState() => _GameInputDialogState();
}

class _GameInputDialogState extends State<GameInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.prefill);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final cleanPrompt = widget.prompt
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<[^>]*>', caseSensitive: false, dotAll: true), '')
        .trim();

    return QuestopiaDialog(
      title: Text(cleanPrompt.isNotEmpty ? cleanPrompt : l10n.input),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(color: colors.onSurface, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colors.outline),
          ),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: widget.onSubmit,
      ),
      actions: [
        QuestopiaMorphButton.outlined(
          onPressed: widget.onCancel,
          child: Text(l10n.cancel),
        ),
        QuestopiaMorphButton.filled(
          onPressed: () => widget.onSubmit(_controller.text),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Engine choose menu dialog.
class GameMenuDialog extends StatelessWidget {
  const GameMenuDialog({
    super.key,
    required this.items,
    required this.onSelect,
    required this.onCancel,
  });

  final List<QspMenuItem> items;
  final ValueChanged<int> onSelect;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return QuestopiaDialog(
      title: Text(l10n.choose),
      content: SizedBox(
        width: double.maxFinite,
        child: items.isEmpty
            ? Text(
                l10n.noOptions,
                style: TextStyle(color: colors.onSurfaceVariant),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final cleanTitle = items[index]
                      .name
                      .replaceAll(
                        RegExp(r'<[^>]*>', caseSensitive: false, dotAll: true),
                        '',
                      )
                      .trim();
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      cleanTitle.isNotEmpty ? cleanTitle : items[index].name,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => onSelect(index),
                  );
                },
              ),
      ),
      actions: [
        QuestopiaMorphButton.outlined(
          onPressed: onCancel,
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

/// Engine error dialog.
class GameErrorDialog extends StatelessWidget {
  const GameErrorDialog({super.key, required this.error, required this.onClose});

  final QspErrorInfo? error;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final details = [
      if (error != null) ...[
        l10n.errorNumber(error!.errorNum, error!.errorDesc),
        if (error!.locName.isNotEmpty) l10n.errorLocation(error!.locName),
        if (error!.lineNum > 0) l10n.errorLine(error!.lineNum),
        if (error!.codeLine.isNotEmpty) l10n.errorCode(error!.codeLine),
      ] else
        l10n.unknownEngineError,
    ].join('\n');

    return QuestopiaDialog(
      icon: const Icon(Icons.error_outline_rounded),
      title: Text(l10n.engineError),
      content: Text(
        details,
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      actions: [
        QuestopiaMorphButton.filled(
          onPressed: onClose,
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Save file picker modal dialog.
class GameFileLoadDialog extends StatelessWidget {
  const GameFileLoadDialog({super.key, required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return QuestopiaDialog(
      icon: const Icon(Icons.folder_open_rounded),
      title: Text(l10n.openSaveFile),
      content: Text(
        l10n.openSaveFileHint,
        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 15),
      ),
      actions: [
        QuestopiaMorphButton.outlined(
          onPressed: onClose,
          child: Text(l10n.cancel),
        ),
        QuestopiaMorphButton.filled(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['sav'],
            );
            final path = result?.files.singleOrNull?.path;
            if (path != null && path.isNotEmpty) onPick(path);
          },
          child: Text(l10n.pickFile),
        ),
      ],
    );
  }
}
