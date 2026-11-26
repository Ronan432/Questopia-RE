import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// A tappable Miuix card used by the setup steps for exclusive choices.
class OnboardingOptionCard extends StatelessWidget {
  const OnboardingOptionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.leading,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MiuixCard(
        colors: isSelected
            ? MiuixCardColors(
                color: colors.primary.withValues(alpha: 0.12),
                contentColor: colors.onSurface,
              )
            : null,
        onPressed: onTap,
        child: MiuixBasicComponent(
          title: title,
          summary: subtitle,
          startAction: leading != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: leading!,
                )
              : null,
          endActions: [
            MiuixRadioButton(
              selected: isSelected,
              onChanged: (_) => onTap(),
            ),
          ],
          onClick: onTap,
        ),
      ),
    );
  }
}

/// A compact vertical card for exclusive choices laid out in a row.
class OnboardingChoiceCard extends StatelessWidget {
  const OnboardingChoiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final MiuixVectorIcon icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return MiuixCard(
      colors: isSelected
          ? MiuixCardColors(
              color: colors.primary.withValues(alpha: 0.14),
              contentColor: colors.primary,
            )
          : null,
      onPressed: onTap,
      insideMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiuixIcon(
            vector: icon,
            size: 26,
            tint: isSelected
                ? colors.primary
                : colors.onSurfaceVariantActions,
          ),
          const SizedBox(height: 8),
          MiuixText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.primary : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
