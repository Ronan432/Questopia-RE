import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import 'sections/miuix_appearance_general_section.dart';
import 'sections/miuix_sound_storage_about_section.dart';
import 'sections/miuix_typography_media_section.dart';

class MiuixSettingsScreen extends ConsumerStatefulWidget {
  const MiuixSettingsScreen({super.key, this.isInline = false});

  final bool isInline;

  @override
  ConsumerState<MiuixSettingsScreen> createState() =>
      _MiuixSettingsScreenState();
}

class _MiuixSettingsScreenState extends ConsumerState<MiuixSettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _packageInfo = info);
    } catch (_) {
      // Platform channels are unavailable in widget previews.
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    final content = ListView(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        (widget.isInline && settings.isNavBarBlur ? 90 : 32) +
            MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        MiuixAppearanceSection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixGeneralSection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixTypographySection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixMediaSection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixSoundSection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixStorageSection(settings: settings, notifier: notifier),
        const SizedBox(height: 12),
        MiuixAboutSection(
          settings: settings,
          notifier: notifier,
          packageInfo: _packageInfo,
        ),
      ],
    );

    if (widget.isInline) return content;

    return MiuixScaffold(
      topBar: MiuixTopAppBar(title: l10n.settings),
      content: (padding) => Padding(
        padding: padding,
        child: content,
      ),
    );
  }
}
