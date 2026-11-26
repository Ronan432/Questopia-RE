import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/miuix_design.dart';
import 'widgets/onboarding_basic_steps.dart';
import 'widgets/onboarding_behavior_step.dart';
import 'widgets/onboarding_style_steps.dart';

/// First run setup flow shown once, until the user finishes or skips it.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _stepCount = 6;

  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    final target = step.clamp(0, _stepCount - 1);
    setState(() => _currentStep = target);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
  }

  List<Widget> _buildSteps(SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);

    return [
      const OnboardingWelcomeStep(),
      OnboardingLanguageStep(
        settings: settings,
        onChanged: (value) => notifier.setLanguage(value),
      ),
      OnboardingThemeStep(
        settings: settings,
        onChanged: (value) => notifier.setThemeMode(value),
      ),
      OnboardingReadingStep(
        settings: settings,
        onFontSizeChanged: (value) => notifier.setFontSize(value),
        onReadingThemeChanged: (value) => notifier.setReadingTheme(value),
      ),
      OnboardingBehaviorStep(
        isImmersiveMode: settings.isImmersiveMode,
        isUseAutoscroll: settings.isUseAutoscroll,
        isAutosaveEnabled: settings.isAutosaveEnabled,
        isCheatsEnabled: settings.isCheatsEnabled,
        onImmersiveModeChanged: (value) => notifier.setImmersiveMode(value),
        onAutoscrollChanged: (value) => notifier.setAutoscroll(value),
        onAutosaveChanged: (value) => notifier.setAutosave(value),
        onCheatsChanged: (value) => notifier.setCheatsEnabled(value),
      ),
      const OnboardingFinishStep(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    final isLastStep = _currentStep == _stepCount - 1;

    return MiuixDesignTheme(
      child: Builder(
        builder: (miuixCtx) {
          final miuix = MiuixTheme.of(miuixCtx);
          return MiuixScaffold(
            content: (padding) => SafeArea(
              child: Column(
                children: [
                  _buildProgressRow(miuix, l10n),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (index) =>
                          setState(() => _currentStep = index),
                      children: _buildSteps(settings),
                    ),
                  ),
                  _buildNavigationRow(miuixCtx, miuix, l10n, isLastStep),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressRow(MiuixThemeData miuix, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: MiuixLinearProgressIndicator(
              progress: (_currentStep + 1) / _stepCount,
            ),
          ),
          const SizedBox(width: 12),
          MiuixText(
            '${_currentStep + 1} / $_stepCount',
            style: miuix.textStyles.footnote1.copyWith(
              fontWeight: FontWeight.w600,
              color: miuix.colors.onSurfaceVariantSummary,
            ),
          ),
          const SizedBox(width: 4),
          MiuixIconButton(
            onPressed: _finish,
            minWidth: 40,
            minHeight: 40,
            child: MiuixIcon(
              vector: MiuixIcons.os4.close,
              size: 20,
              contentDescription: l10n.dismiss,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(
    BuildContext context,
    MiuixThemeData miuix,
    AppLocalizations l10n,
    bool isLastStep,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (_currentStep > 0)
            MiuixButton(
              onPressed: () => _goTo(_currentStep - 1),
              minHeight: 38,
              insideMargin:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiuixIcon(
                    vector: MiuixIcons.os4.back,
                    size: 16,
                    tint: miuix.colors.onSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(l10n.prev),
                ],
              ),
            ),
          const Spacer(),
          MiuixButton(
            onPressed: isLastStep ? _finish : () => _goTo(_currentStep + 1),
            colors: MiuixButtonDefaults.buttonColorsPrimary(context),
            minHeight: 38,
            insideMargin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLastStep ? l10n.getStarted : l10n.next),
                const SizedBox(width: 6),
                MiuixIcon(
                  vector: isLastStep
                      ? MiuixIcons.basic.check
                      : MiuixIcons.basic.arrowRight,
                  size: 16,
                  tint: miuix.colors.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Final step: confirms that the chosen options were saved.
class OnboardingFinishStep extends StatelessWidget {
  const OnboardingFinishStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: MiuixIcon(
                  vector: MiuixIcons.basic.check,
                  size: 44,
                  tint: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              MiuixText(
                l10n.onboardingFinishTitle,
                textAlign: TextAlign.center,
                style: miuix.textStyles.title2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              MiuixText(
                l10n.onboardingFinishBody,
                textAlign: TextAlign.center,
                style: miuix.textStyles.body2.copyWith(
                  height: 1.4,
                  color: colors.onSurfaceVariantSummary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
