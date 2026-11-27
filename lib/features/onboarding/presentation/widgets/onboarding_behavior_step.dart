import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../settings/presentation/widgets/miuix_settings_tiles.dart';
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
      title: l10n.onboardingBehaviorTitle,
      description: l10n.onboardingBehaviorBody,
      child: MiuixSettingsGroup(
        children: [
          miuixSwitchPreference(
            context: context,
            title: l10n.immersiveMode,
            iconName: 'screenMirroring',
            value: isImmersiveMode,
            onChanged: onImmersiveModeChanged,
          ),
          miuixSwitchPreference(
            context: context,
            title: l10n.autoscroll,
            iconName: 'expandMore',
            value: isUseAutoscroll,
            onChanged: onAutoscrollChanged,
          ),
          miuixSwitchPreference(
            context: context,
            title: l10n.autoSave,
            iconName: 'save',
            value: isAutosaveEnabled,
            onChanged: onAutosaveChanged,
          ),
          miuixSwitchPreference(
            context: context,
            title: l10n.cheatEngine,
            iconName: 'lock',
            value: isCheatsEnabled,
            onChanged: onCheatsChanged,
          ),
        ],
      ),
    );
  }
}
