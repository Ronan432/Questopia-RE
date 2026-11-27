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
  const MiuixSettingsScreen({
    super.key,
    this.isInline = false,
    this.searchQuery = '',
    this.onScrollNotification,
  });

  final bool isInline;
  final String searchQuery;
  final bool Function(ScrollNotification)? onScrollNotification;

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

    final query = widget.searchQuery.trim().toLowerCase();
    final sections = <(String, Widget)>[
      (
        '${l10n.sectionAppearance} ${l10n.theme} ${l10n.language} ${l10n.miuixDynamicColor}',
        MiuixAppearanceSection(settings: settings, notifier: notifier),
      ),
      (
        '${l10n.sectionGeneral} ${l10n.immersiveMode} ${l10n.autoscroll} ${l10n.separatorLine} ${l10n.navBarBlur}',
        MiuixGeneralSection(settings: settings, notifier: notifier),
      ),
      (
        '${l10n.sectionTypography} ${l10n.fontSize}',
        MiuixTypographySection(settings: settings, notifier: notifier),
      ),
      (
        l10n.sectionMedia,
        MiuixMediaSection(settings: settings, notifier: notifier),
      ),
      (
        l10n.sectionSound,
        MiuixSoundSection(settings: settings, notifier: notifier),
      ),
      (
        l10n.sectionStorage,
        MiuixStorageSection(settings: settings, notifier: notifier),
      ),
      (
        '${l10n.sectionAbout} ${l10n.version}',
        MiuixAboutSection(
          settings: settings,
          notifier: notifier,
          packageInfo: _packageInfo,
        ),
      ),
    ];

    final visibleSections = query.isEmpty
        ? [for (final s in sections) s.$2]
        : [
            for (final s in sections)
              if (s.$1.toLowerCase().contains(query)) s.$2,
          ];

    final listView = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        12,
        (widget.isInline ? MediaQuery.paddingOf(context).top : 0) + 6,
        12,
        (widget.isInline ? 110 : 32) + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < visibleSections.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            visibleSections[i],
          ],
        ],
      ),
    );

    final content = widget.onScrollNotification != null
        ? NotificationListener<ScrollNotification>(
            onNotification: widget.onScrollNotification,
            child: listView,
          )
        : listView;

    if (widget.isInline) return content;

    return MiuixScaffold(
      topBar: MiuixSmallTopAppBar(
        title: l10n.settings,
        navigationIcon: Navigator.of(context).canPop()
            ? MiuixIconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: MiuixIcon(
                  vector: MiuixIcons.os4.back,
                  size: 22,
                  contentDescription:
                      MaterialLocalizations.of(context).backButtonTooltip,
                ),
              )
            : null,
      ),
      content: (padding) => Padding(
        padding: padding,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: content,
        ),
      ),
    );
  }
}
