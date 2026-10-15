import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/app_localizations.dart';
import 'onboarding_step_layout.dart';

/// Behavior step: the helper switches that are worth deciding before the first
/// game is opened, including the cheat engine.
///
/// Each entry writes straight through [onChanged], so the value the user sees
/// is the value stored by [settingsProvider].
class OnboardingBehaviorStep extends StatelessWidget {
  const OnboardingBehaviorStep({
    super.key,
    required this.isImmersiveMode,
    required this.isUseAutoscroll,
    required this.isAutosaveEnabled,
    required this.isCheatsEnabled,
    required this.onImmersiveModeChanged,
    required this.onAutoscrollChanged,
    required this.onAutosaveChanged,
    required this.onCheatsChanged,
  });

  final bool isImmersiveMode;
  final bool isUseAutoscroll;
  final bool isAutosaveEnabled;
  final bool isCheatsEnabled;
  final ValueChanged<bool> onImmersiveModeChanged;
  final ValueChanged<bool> onAutoscrollChanged;
  final ValueChanged<bool> onAutosaveChanged;
  final ValueChanged<bool> onCheatsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingStepLayout(
      icon: Icons.tune_rounded,
      title: l10n.onboardingBehaviorTitle,
      description: l10n.onboardingBehaviorBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ToggleCard(
            icon: Icons.fullscreen_rounded,
            title: l10n.immersiveMode,
            value: isImmersiveMode,
            onChanged: onImmersiveModeChanged,
          ),
          _ToggleCard(
            icon: Icons.vertical_align_bottom_rounded,
            title: l10n.autoscroll,
            value: isUseAutoscroll,
            onChanged: onAutoscrollChanged,
          ),
          _ToggleCard(
            icon: Icons.save_outlined,
            title: l10n.autoSave,
            value: isAutosaveEnabled,
            onChanged: onAutosaveChanged,
          ),
          _ToggleCard(
            icon: Icons.bug_report_outlined,
            title: l10n.cheatEngine,
            value: isCheatsEnabled,
            onChanged: onCheatsChanged,
          ),
        ],
      ),
    );
  }
}

/// A single switch row shaped like the surrounding onboarding cards, so the
/// step keeps the same visual language as the exclusive choice steps.
class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Material(
        color: value ? colors.secondaryContainer : colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            onChanged(!value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: value
                    ? colors.primary
                    : colors.outlineVariant.withValues(alpha: 0.5),
                width: value ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: value ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: (next) {
                    HapticFeedback.lightImpact();
                    onChanged(next);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
