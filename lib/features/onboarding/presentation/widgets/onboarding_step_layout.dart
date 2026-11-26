import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Shared layout for a single setup step: a centered icon badge, a title,
/// a short description and the step body.
class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final MiuixVectorIcon icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: MiuixIcon(
                    vector: icon,
                    size: 34,
                    tint: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MiuixText(
                title,
                textAlign: TextAlign.center,
                style: miuix.textStyles.title2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              MiuixText(
                description,
                textAlign: TextAlign.center,
                style: miuix.textStyles.body2.copyWith(
                  height: 1.4,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
