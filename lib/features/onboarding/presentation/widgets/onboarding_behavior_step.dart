import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';
import 'onboarding_step_layout.dart';

/// Behavior step: the helper switches that are worth deciding before the first
/// game is opened, including the cheat engine.
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
      child: MiuixCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiuixSwitchPreference(
              title: l10n.immersiveMode,
              startAction: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.fullscreen_rounded, size: 22),
              ),
              value: isImmersiveMode,
              onChanged: onImmersiveModeChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.autoscroll,
              startAction: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.vertical_align_bottom_rounded, size: 22),
              ),
              value: isUseAutoscroll,
              onChanged: onAutoscrollChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.autoSave,
              startAction: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.save_outlined, size: 22),
              ),
              value: isAutosaveEnabled,
              onChanged: onAutosaveChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.cheatEngine,
              startAction: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.bug_report_outlined, size: 22),
              ),
              value: isCheatsEnabled,
              onChanged: onCheatsChanged,
            ),
          ],
        ),
      ),
    );
  }
}
