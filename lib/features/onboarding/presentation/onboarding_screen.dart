import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/questopia_morph_button.dart';
import 'widgets/onboarding_basic_steps.dart';
import 'widgets/onboarding_behavior_step.dart';
import 'widgets/onboarding_style_steps.dart';

/// First run setup flow shown once, until the user finishes or skips it.
///
/// Every choice is written straight to [settingsProvider], so the MaterialApp
/// above rebuilds with the new theme, locale and colors on each tap. Only the
/// completion flag is written at the end, by [_finish].
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _stepCount = 7;

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
      OnboardingAccentStep(
        settings: settings,
        onChanged: (value) => notifier.setThemeColor(value),
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
    final colors = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isLastStep = _currentStep == _stepCount - 1;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressRow(colors, l10n),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: _buildSteps(settings),
              ),
            ),
            _buildNavigationRow(l10n, colors, bottomInset, isLastStep),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(ColorScheme colors, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _stepCount,
                minHeight: 5,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentStep + 1} / $_stepCount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.dismiss,
            icon: const Icon(Icons.close_rounded, size: 20),
            visualDensity: VisualDensity.compact,
            onPressed: _finish,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(
    AppLocalizations l10n,
    ColorScheme colors,
    double bottomInset,
    bool isLastStep,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: Row(
        children: [
          if (_currentStep > 0)
            QuestopiaMorphButton.outlined(
              onPressed: () => _goTo(_currentStep - 1),
              child: Text(l10n.prev),
            ),
          const Spacer(),
          if (isLastStep)
            QuestopiaMorphButton.filled(
              icon: const Icon(Icons.rocket_launch_rounded),
              onPressed: _finish,
              child: Text(l10n.getStarted),
            )
          else
            QuestopiaMorphButton.filled(
              icon: const Icon(Icons.arrow_forward_rounded),
              onPressed: () => _goTo(_currentStep + 1),
              child: Text(l10n.next),
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
    final colors = Theme.of(context).colorScheme;

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
                child: Icon(
                  Icons.check_rounded,
                  size: 44,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.onboardingFinishTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.onboardingFinishBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
