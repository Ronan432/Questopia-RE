import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/helpers/byte_format.dart';
import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/path_picker_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
import '../../../library/providers/library_provider.dart';
import '../widgets/miuix_settings_tiles.dart';

class MiuixSoundSection extends StatelessWidget {
  const MiuixSoundSection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionSound),
        MiuixSettingsGroup(
          children: [
            miuixSwitchPreference(
              context: context,
              title: l10n.playSound,
              iconName: 'volumeUp',
              value: settings.isSoundEnabled,
              onChanged: notifier.setSoundEnabled,
            ),
            miuixSwitchPreference(
              context: context,
              title: l10n.muteVideoAudio,
              iconName: 'volumeOff',
              value: settings.isVideoMute,
              onChanged: notifier.setVideoMute,
            ),
          ],
        ),
      ],
    );
  }
}

class MiuixStorageSection extends ConsumerStatefulWidget {
  const MiuixStorageSection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  ConsumerState<MiuixStorageSection> createState() =>
      _MiuixStorageSectionState();
}

class _MiuixStorageSectionState extends ConsumerState<MiuixStorageSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(libraryProvider.notifier).refreshStorageStats();
    });
  }

  Future<void> _pickFolder() async {
    final selected = await PathPickerHelper.pickDirectory(
      context,
      currentPath: widget.settings.gamesDirectory,
    );
    if (selected == null || selected.isEmpty || !mounted) return;
    await widget.notifier.setGamesDirectory(selected);
    if (!mounted) return;
    await ref.read(libraryProvider.notifier).refreshLocalGames(force: true);
    if (!mounted) return;
    await ref.read(libraryProvider.notifier).refreshStorageStats();
  }

  Future<void> _cleanup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showQuestopiaDialog<bool>(
      context: context,
      builder: (ctx) => QuestopiaConfirmationDialog(
        miuixVectorIcon: miuixVector('delete', fallback: MiuixIcons.os4.delete),
        title: l10n.storageCleanup,
        message: l10n.storageCleanupHint,
        confirmLabel: l10n.storageCleanup,
        cancelLabel: l10n.cancel,
      ),
    );
    if (confirmed != true || !mounted) return;
    final freed =
        await ref.read(libraryProvider.notifier).cleanupOrphanFolders();
    if (!mounted) return;
    final prefix = widget.settings.binaryPrefixes;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          freed > 0
              ? l10n
                  .storageCleanupFreed(formatBytes(freed, binaryPrefix: prefix))
              : l10n.storageNothingToClean,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final library = ref.watch(libraryProvider);
    final stats = library.storageStats;
    final prefix = widget.settings.binaryPrefixes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionStorage),
        MiuixSettingsGroup(
          children: [
            miuixArrowPreference(
              context: context,
              title: l10n.gamesFolder,
              iconName: 'folder',
              fallbackIcon: MiuixIcons.os4.folder,
              summary: widget.settings.gamesDirectory.isNotEmpty
                  ? widget.settings.gamesDirectory
                  : l10n.defaultInternalFolder,
              onClick: _pickFolder,
            ),
            miuixInfoPreference(
              context: context,
              title: l10n.storageUsage,
              iconName: 'backup',
              summary: library.isLoadingStorage
                  ? l10n.storageCalculating
                  : '${l10n.storageTotal}: '
                      '${formatBytes(stats.totalBytes, binaryPrefix: prefix)}',
              endAction: MiuixText('${stats.gameCount}'),
            ),
            miuixArrowPreference(
              context: context,
              title: l10n.storageCleanup,
              iconName: 'delete',
              fallbackIcon: MiuixIcons.os4.delete,
              summary: l10n.storageCleanupHint,
              onClick: _cleanup,
            ),
          ],
        ),
      ],
    );
  }
}

class MiuixAboutSection extends StatelessWidget {
  const MiuixAboutSection({
    super.key,
    required this.settings,
    required this.notifier,
    required this.packageInfo,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;
  final PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = packageInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MiuixSettingsSectionTitle(l10n.sectionAbout),
        MiuixSettingsGroup(
          children: [
            miuixInfoPreference(
              context: context,
              title: l10n.version,
              iconName: 'info',
              endAction: MiuixText(
                info == null ? '...' : '${info.version}+${info.buildNumber}',
              ),
            ),
            miuixArrowPreference(
              context: context,
              title: l10n.openSourceLicenses,
              iconName: 'file',
              onClick: () => showLicensePage(
                context: context,
                applicationName: l10n.appTitle,
              ),
            ),
            miuixArrowPreference(
              context: context,
              title: l10n.onboardingRestart,
              iconName: 'refresh',
              fallbackIcon: MiuixIcons.os4.refresh,
              summary: l10n.onboardingRestartHint,
              onClick: notifier.restartOnboarding,
            ),
          ],
        ),
      ],
    );
  }
}
