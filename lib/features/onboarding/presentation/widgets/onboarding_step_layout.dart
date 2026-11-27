import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Shared layout for a single setup step.
///
/// The step is deliberately plain: the settings rows of the step sit in a
/// centered column with a short heading above them. Nothing else is added, so
/// the setup flow reads exactly like the settings screen.
class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MiuixText(
                title,
                textAlign: TextAlign.center,
                style: miuix.textStyles.title3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              MiuixText(
                description,
                textAlign: TextAlign.center,
                style: miuix.textStyles.footnote1.copyWith(
                  height: 1.4,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
