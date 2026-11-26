import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../providers/library_provider.dart';

/// Compact Miuix pagination bar for browsing remote catalog pages.
class CatalogPaginationBar extends ConsumerWidget {
  const CatalogPaginationBar({
    super.key,
    this.isInsideOverlay = false,
    this.miuix = true,
  });

  final bool isInsideOverlay;
  final bool miuix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final notifier = ref.read(libraryProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final miuixTheme = MiuixTheme.of(context);
    final colors = miuixTheme.colors;

    final bottomPadding = MediaQuery.paddingOf(context).bottom > 0 ? 4.0 : 8.0;
    final prevEnabled = state.currentPage > 1 && !state.isLoadingRemote;
    final nextEnabled =
        state.currentPage < state.totalPages && !state.isLoadingRemote;

    final row = Row(
      children: [
        _MiuixPageButton(
          label: l10n.prev,
          icon: MiuixIcons.os4.back,
          iconLeading: true,
          enabled: prevEnabled,
          onPressed: () => notifier.setCatalogPage(state.currentPage - 1),
        ),
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: state.isLoadingRemote
                  ? const MiuixCircularProgressIndicator(
                      key: ValueKey('catalog_page_loading'),
                    )
                  : Container(
                      key: ValueKey(
                        'catalog_page_${state.currentPage}_${state.totalPages}',
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: ShapeDecoration(
                        color: colors.surfaceContainerHigh,
                        shape: MiuixSquircleBorder(cornerRadius: 14),
                      ),
                      child: MiuixText(
                        l10n.pageOf(state.currentPage, state.totalPages),
                        style: miuixTheme.textStyles.footnote1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        _MiuixPageButton(
          label: l10n.next,
          icon: MiuixIcons.basic.arrowRight,
          iconLeading: false,
          enabled: nextEnabled,
          onPressed: () => notifier.setCatalogPage(state.currentPage + 1),
        ),
      ],
    );

    if (isInsideOverlay) {
      return Padding(
        padding: EdgeInsets.fromLTRB(4, 6, 4, 2),
        child: row,
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
      color: settings.isNavBarBlur
          ? colors.surface.withValues(alpha: 0.72)
          : colors.surface,
      child: row,
    );
  }
}

class _MiuixPageButton extends StatelessWidget {
  const _MiuixPageButton({
    required this.label,
    required this.icon,
    required this.iconLeading,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final MiuixVectorIcon icon;
  final bool iconLeading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;
    final fg = enabled ? colors.primary : colors.disabledOnSurface;
    final bg = enabled
        ? colors.primary.withValues(alpha: 0.12)
        : colors.surfaceContainer.withValues(alpha: 0.6);

    return MiuixPressable(
      enabled: enabled,
      onPressed: enabled
          ? () {
              HapticFeedback.selectionClick();
              onPressed();
            }
          : null,
      shape: MiuixSquircleBorder(cornerRadius: 16),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: ShapeDecoration(
          color: bg,
          shape: MiuixSquircleBorder(cornerRadius: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconLeading) ...[
              MiuixIcon(vector: icon, size: 15, tint: fg),
              const SizedBox(width: 5),
            ],
            MiuixText(
              label,
              style: miuix.textStyles.footnote1.copyWith(
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
            if (!iconLeading) ...[
              const SizedBox(width: 5),
              MiuixIcon(vector: icon, size: 15, tint: fg),
            ],
          ],
        ),
      ),
    );
  }
}
