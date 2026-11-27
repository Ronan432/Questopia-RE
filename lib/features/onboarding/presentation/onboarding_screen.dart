import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/helpers/platform_helper.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/miuix_design.dart';
import '../../../core/widgets/window_title_bar.dart';
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
          final scaffold = MiuixScaffold(
            content: (padding) => SafeArea(
              child: Stack(
                children: [
                  Column(
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
                    ],
                  ),
                  // The step arrows float in the vertical center of each side
                  // instead of sitting in a bottom button row.
                  if (_currentStep > 0)
                    _SideArrow(
                      alignment: Alignment.centerLeft,
                      icon: MiuixIcons.os4.back,
                      tooltip: l10n.prev,
                      onPressed: () => _goTo(_currentStep - 1),
                    ),
                  _SideArrow(
                    alignment: Alignment.centerRight,
                    icon: isLastStep
                        ? MiuixIcons.basic.check
                        : MiuixIcons.os4.forward,
                    tooltip: isLastStep ? l10n.getStarted : l10n.next,
                    onPressed:
                        isLastStep ? _finish : () => _goTo(_currentStep + 1),
                  ),
                ],
              ),
            ),
          );
          if (!isDesktopPlatform) return scaffold;
          // The desktop window hides the native title bar, so the first run
          // flow needs the same draggable window row as the main shell.
          return Column(
            children: [
              const WindowTitleBar(),
              Expanded(child: scaffold),
            ],
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
}

/// A single page arrow pinned to the vertical center of one side.
class _SideArrow extends StatelessWidget {
  const _SideArrow({
    required this.alignment,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Alignment alignment;
  final MiuixVectorIcon icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: MiuixIconButton(
          onPressed: onPressed,
          minWidth: 44,
          minHeight: 44,
          child: MiuixIcon(
            vector: icon,
            size: 24,
            contentDescription: tooltip,
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiuixIcon(
                vector: MiuixIcons.basic.check,
                size: 40,
                tint: colors.primary,
              ),
              const SizedBox(height: 14),
              MiuixText(
                l10n.onboardingFinishTitle,
                textAlign: TextAlign.center,
                style: miuix.textStyles.title2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
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
