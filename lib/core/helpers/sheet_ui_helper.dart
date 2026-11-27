import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../l10n/app_localizations.dart';
import '../theme/questopia_theme.dart';

/// Standard responsive container wrapper for bottom sheets.
class QuestopiaSheetContainer extends StatelessWidget {
  const QuestopiaSheetContainer({
    super.key,
    required this.child,
    this.heightFactor = 0.85,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 20),
  });

  final Widget child;
  final double heightFactor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return M3ETheme(
      data: QuestopiaTheme.m3eThemeDataFrom(Theme.of(context)),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * heightFactor,
          child: Padding(
            padding: padding,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const ClampingScrollPhysics(),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard empty placeholder for lists and searches in bottom sheets.
class QuestopiaSheetEmptyState extends StatelessWidget {
  const QuestopiaSheetEmptyState({
    super.key,
    this.icon,
    this.miuixVectorIcon,
    required this.message,
  });

  final IconData? icon;
  final MiuixVectorIcon? miuixVectorIcon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (miuixVectorIcon != null)
            MiuixIcon(vector: miuixVectorIcon!, size: 40, tint: colors.outline)
          else if (icon != null)
            Icon(icon, size: 40, color: colors.outline),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Standard search field for bottom sheets.
class QuestopiaSheetSearchBar extends StatelessWidget {
  const QuestopiaSheetSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: MiuixIcon(vector: MiuixIcons.basic.search, size: 18),
        ),
        isDense: true,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

/// Standard page navigation bar for paginated sheets (e.g. Save slots).
class QuestopiaSheetPageNav extends StatelessWidget {
  const QuestopiaSheetPageNav({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        MiuixButton(
          onPressed: onPrev,
          minHeight: 36,
          insideMargin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiuixIcon(vector: MiuixIcons.os4.back, size: 14),
              const SizedBox(width: 4),
              Text(l10n.prev),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: MiuixText(
              l10n.pageOfPages(currentPage + 1, totalPages),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        MiuixButton(
          onPressed: onNext,
          minHeight: 36,
          insideMargin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.next),
              const SizedBox(width: 4),
              MiuixIcon(vector: MiuixIcons.basic.arrowRight, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper to show a standard snack bar message.
void showSheetSnackBar(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
