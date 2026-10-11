import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/qsp_media.dart';
import '../../../../core/media/qsp_path_resolver.dart';
import '../../providers/game_engine_provider.dart';

/// Embedded media viewer for game dialogs supporting images and videos.
class GameMediaViewer extends ConsumerStatefulWidget {
  const GameMediaViewer({
    super.key,
    required this.mediaPath,
    this.gameFolderPath,
    this.maxHeight = 260,
    this.enableZoom = false,
    this.forceFullscreen = false,
  });

  final String mediaPath;
  final String? gameFolderPath;
  final double maxHeight;

  /// Enables pinch to zoom over the media, honouring the pinch zoom setting.
  final bool enableZoom;

  /// Lets the media use most of the screen height instead of the compact box.
  final bool forceFullscreen;

  @override
  ConsumerState<GameMediaViewer> createState() => _GameMediaViewerState();
}

class _GameMediaViewerState extends ConsumerState<GameMediaViewer> {
  QspPathResolver? _resolver;
  String? _resolverKey;

  /// Reuses one resolver per game folder instead of rebuilding the index on
  /// every frame, which used to walk the whole game directory repeatedly.
  QspPathResolver? _resolverFor(String? folder) {
    if (folder == null || folder.isEmpty) return null;
    if (_resolver == null || _resolverKey != folder) {
      _resolverKey = folder;
      _resolver = QspPathResolver([folder]);
    }
    return _resolver;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final folder = widget.gameFolderPath ??
        ref.watch(gameEngineProvider).activeGame?.folderPath;
    final resolver = _resolverFor(folder);

    final media = QspMedia(
      src: widget.mediaPath,
      resolver: resolver,
      allowedRoots: resolver?.basePaths ?? const [],
      fit: BoxFit.contain,
      autoplay: true,
      loop: true,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: widget.forceFullscreen
                ? MediaQuery.sizeOf(context).height * 0.72
                : widget.maxHeight,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: widget.enableZoom
              ? InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  clipBehavior: Clip.none,
                  child: media,
                )
              : media,
        ),
      ),
    );
  }
}
