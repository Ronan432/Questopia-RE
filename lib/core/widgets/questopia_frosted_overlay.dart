import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../theme/glass_effect.dart';

/// Applies a single advanced-texture blur pass behind an overlay stack.
class QuestopiaFrostedOverlay extends ConsumerWidget {
  const QuestopiaFrostedOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return GlassEffect.wrap(
      context,
      enabled: settings.isNavBarBlur,
      percent: settings.navBarBlurPercent,
      child: child,
    );
  }
}
