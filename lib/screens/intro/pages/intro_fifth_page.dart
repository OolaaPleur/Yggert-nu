import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yggert_nu/screens/settings/theme_switch/theme_segmented_buttons.dart';

import '../../../constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';

/// Fifth page of intro.
PageViewModel introFifthPage(BuildContext context) {
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkMode == true)
        ? const PageDecoration()
        : PageDecoration(
            boxDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFfff284), AppStyleConstants.introBottomColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
    titleWidget: Column(
      children: [
        const SizedBox(
          height: AppStyleConstants.firstSizeBoxHeight,
        ),
        ClipOval(
          child: Image.asset(
            'assets/intro/intro_theme_change.png',
            semanticLabel: 'Medieval lantern with fire inside',
            scale: 6,
          ),
        ),
        const SizedBox(
          height: AppStyleConstants.secondSizeBoxHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.introFourthScreenHeader,
            textScaler: const TextScaler.linear(AppStyleConstants.introTitleTextScale),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    bodyWidget: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.introFourthScreenBody,
            textScaleFactor: AppStyleConstants.introBodyTextScale,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkMode == true)
                ? const BoxDecoration()
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[200]!, AppStyleConstants.introBottomColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
            child: const ThemeSegmentedButtons(),
          ),
        ),
      ],
    ),
  );
}
