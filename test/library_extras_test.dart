import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questopia_re/core/error/crash_reporter.dart';
import 'package:questopia_re/features/library/data/game_repository.dart';
import 'package:questopia_re/features/library/data/local_game.dart';

/// Answers path_provider's channel with a temp directory so [GameRegistry] can
/// write its registry file without a real platform implementation.
void _mockPathProvider(String root) {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    switch (call.method) {
      case 'getApplicationSupportDirectory':
      case 'getApplicationDocumentsDirectory':
        return root;
      default:
        return null;
    }
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('questopia_registry');
    _mockPathProvider(sandbox.path);
  });

  tearDown(() async {
    if (sandbox.existsSync()) {
      await sandbox.delete(recursive: true);
    }
  });

  test('crash reporter returns null without a stored report', () async {
    expect(await CrashReporter.takePendingReport(), isNull);
  });

  test('toggleFavorite flips and persists the flag', () async {
    final root = await Directory.systemTemp.createTemp('questopia_fav');
    addTearDown(() => root.delete(recursive: true));
    final folder = Directory('${root.path}/game1');
    await folder.create();
    final repository = GameRepository();

    const game = LocalGame(
      id: 'game1',
      title: 'Game 1',
      author: 'Author',
      folderPath: '',
      gameFilePath: '',
    );
    final withFolder = game.copyWith(folderPath: folder.path);

    final fav = await repository.toggleFavorite(withFolder);
    expect(fav.isFavorite, isTrue);

    final unfav = await repository.toggleFavorite(fav);
    expect(unfav.isFavorite, isFalse);
  });
}
