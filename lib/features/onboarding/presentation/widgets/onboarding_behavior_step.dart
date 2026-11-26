import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/miuix_icons_helper.dart';
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
      icon: MiuixIcons.os4.tune,
      title: l10n.onboardingBehaviorTitle,
      description: l10n.onboardingBehaviorBody,
      child: MiuixCard(
        cornerRadius: 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiuixSwitchPreference(
              title: l10n.immersiveMode,
              insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              startAction: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: miuixIcon('fullscreen', size: 20),
              ),
              value: isImmersiveMode,
              onChanged: onImmersiveModeChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.autoscroll,
              insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              startAction: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: miuixIcon('arrow_down', size: 20),
              ),
              value: isUseAutoscroll,
              onChanged: onAutoscrollChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.autoSave,
              insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              startAction: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: miuixIcon('save', size: 20),
              ),
              value: isAutosaveEnabled,
              onChanged: onAutosaveChanged,
            ),
            MiuixSwitchPreference(
              title: l10n.cheatEngine,
              insideMargin: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              startAction: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: miuixIcon('lock', size: 20),
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
