import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

import '../home_screen.dart';

/// Focus node for settings icon.
final settingsIconFocusNode = FocusNode();
/// Focus node for refresh icon.
final refreshIconFocusNode = FocusNode();
/// Focus node for FAB filters.
final filtersFocusNode = FocusNode();
/// Focus node for title in app bar.
final appBarTitleFocusNode = FocusNode();
/// Focus node for final node, text in center of the screen.
final finalNode = FocusNode();

/// Defines onboarding for new users.
class OnboardingWidget extends StatefulWidget {
  /// Constructor for [OnboardingWidget].
  const OnboardingWidget({super.key});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final _settingsRepository = GetIt.I<SettingsRepository>();
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      onEnd: (number) {
        _settingsRepository.setBoolValue('tutorial_passed', value: true);
      },
        debugBoundaries: true,
        steps: [
          OnboardingStep(
            focusNode: appBarTitleFocusNode,
            titleText: AppLocalizations.of(context)!.onboardingTitleTextCity,
            bodyText: AppLocalizations.of(context)!.onboardingBodyTextCity,
            fullscreen: false,
            overlayColor: Colors.blue.withOpacity(0.6),
            overlayShape: const CircleBorder(),
            overlayBehavior: HitTestBehavior.deferToChild,
            textAlign: TextAlign.center,
            showPulseAnimation: true,
          ),
          OnboardingStep(
            focusNode: settingsIconFocusNode,
            titleText: AppLocalizations.of(context)!.homeAppBarSettingsIcon,
            bodyText: AppLocalizations.of(context)!.onboardingBodyTextCustomize,
            shape: const CircleBorder(),
            fullscreen: false,
            overlayColor: Colors.blue.withOpacity(0.6),
            overlayShape: const CircleBorder(),
            textAlign: TextAlign.center,
            showPulseAnimation: true,
          ),
          OnboardingStep(
            focusNode: refreshIconFocusNode,
            titleText: AppLocalizations.of(context)!.homeAppBarRefreshIcon,
            bodyText: AppLocalizations.of(context)!.onboardingBodyTextRefresh,
            shape: const CircleBorder(),
            fullscreen: false,
            overlayColor: Colors.blue.withOpacity(0.6),
            overlayShape: const CircleBorder(),
            textAlign: TextAlign.center,
            showPulseAnimation: true,
          ),
          OnboardingStep(
            focusNode: filtersFocusNode,
            titleText: AppLocalizations.of(context)!.onboardingTitleTextFilters,
            bodyText: AppLocalizations.of(context)!.onboardingBodyTextFiltersExample,
            shape: const CircleBorder(),
            fullscreen: false,
            overlayColor: Colors.blue.withOpacity(0.6),
            overlayShape: const CircleBorder(),
            textAlign: TextAlign.center,
            showPulseAnimation: true,
          ),
          OnboardingStep(
            focusNode: finalNode,
            titleText: AppLocalizations.of(context)!.onboardingTitleTextGoodLuck,
            textAlign: TextAlign.center,
            margin: EdgeInsets.zero,
          ),
        ],
        child: const HomeScreen(),);
  }
}
