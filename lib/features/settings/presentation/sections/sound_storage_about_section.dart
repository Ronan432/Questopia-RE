import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_list/material_segmented_list.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/helpers/byte_format.dart';
import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/path_picker_helper.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../library/providers/library_provider.dart';
import '../widgets/settings_tile_builders.dart';

/// Sound settings section.
class SoundSection extends StatelessWidget {
  const SoundSection({
    super.key,
    required this.settings,
    required this.notifier,
  });

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + MediaQuery.paddingOf(context).bottom + 80),
      children: [
        SegmentedListSection(
          children: [
            SettingsTiles.switchTile(
              icon: Icons.volume_up_outlined,
              title: l10n.playSound,
              value: settings.isSoundEnabled,
              onChanged: notifier.setSoundEnabled,
            ),
            SettingsTiles.switchTile(
              icon: Icons.volume_off_outlined,
              title: l10n.muteVideoAudio,
              value: settings.isVideoMute,
              onChanged: notifier.setVideoMute,
            ),
          ],
        ),
      ],
    );
  }
}

/// Storage folder and disk usage settings section.
class StorageSection extends ConsumerStatefulWidget {
  const StorageSection({super.key, required this.settings, required this.notifier});

  final SettingsState settings;
  final SettingsNotifier notifier;

  @override
  ConsumerState<StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends ConsumerState<StorageSection> {
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
    // The notifier reads the folder on demand, so a rescan picks it up at once.
    await ref.read(libraryProvider.notifier).refreshLocalGames(force: true);
    if (!mounted) return;
    await ref.read(libraryProvider.notifier).refreshStorageStats();
  }

  Future<void> _cleanup() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showQuestopiaDialog<bool>(
      context: context,
      builder: (ctx) => QuestopiaConfirmationDialog(
        icon: Icons.cleaning_services_rounded,
        title: l10n.storageCleanup,
        message: l10n.storageCleanupHint,
        confirmLabel: l10n.storageCleanup,
        cancelLabel: l10n.cancel,
      ),
    );
    if (confirmed != true || !mounted) return;

    final freed = await ref.read(libraryProvider.notifier).cleanupOrphanFolders();
    if (!mounted) return;
    final prefix = widget.settings.binaryPrefixes;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          freed > 0
              ? l10n.storageCleanupFreed(formatBytes(freed, binaryPrefix: prefix))
              : l10n.storageNothingToClean,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final library = ref.watch(libraryProvider);
    final stats = library.storageStats;
    final prefix = widget.settings.binaryPrefixes;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + MediaQuery.paddingOf(context).bottom + 80),
      children: [
        SegmentedListSection(
          children: [
            SegmentedListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(l10n.gamesFolder),
              subtitle: Text(
                widget.settings.gamesDirectory.isNotEmpty
                    ? widget.settings.gamesDirectory
                    : l10n.defaultInternalFolder,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              minVerticalPadding: 12,
              onTap: _pickFolder,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SegmentedListSection(
          children: [
            SegmentedListTile(
              leading: const Icon(Icons.sd_storage_outlined),
              title: Text(l10n.storageUsage),
              subtitle: Text(
                library.isLoadingStorage
                    ? l10n.storageCalculating
                    : '${l10n.storageTotal}: '
                        '${formatBytes(stats.totalBytes, binaryPrefix: prefix)}',
              ),
              trailing: Text(
                '${stats.gameCount}',
                style: TextStyle(
                  fontSize: 15,
                  color: colors.onSurfaceVariant,
                ),
              ),
              minVerticalPadding: 12,
            ),
            SegmentedListTile(
              leading: const Icon(Icons.cleaning_services_rounded),
              title: Text(l10n.storageCleanup),
              subtitle: Text(
                l10n.storageCleanupHint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              minVerticalPadding: 12,
              onTap: _cleanup,
            ),
          ],
        ),
      ],
    );
  }
}

/// About, version and open source licenses section.
class AboutSection extends StatelessWidget {
  const AboutSection({
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

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + MediaQuery.paddingOf(context).bottom + 80),
      children: [
        SegmentedListSection(
          children: [
            SegmentedListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.version),
              trailing: Text(
                info == null ? '...' : '${info.version}+${info.buildNumber}',
              ),
              minVerticalPadding: 12,
            ),
            SegmentedListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.openSourceLicenses),
              trailing: const Icon(Icons.chevron_right),
              minVerticalPadding: 12,
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'Questopia',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
