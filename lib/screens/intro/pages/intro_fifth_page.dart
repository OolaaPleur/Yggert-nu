import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../constants/constants.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../../../theme/bloc/theme_event.dart';
/// Fifth page of intro.
PageViewModel introFifthPage(BuildContext context) {
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
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
            textScaleFactor: AppStyleConstants.introTitleTextScale,
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
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const BoxDecoration()
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[200]!, AppStyleConstants.introBottomColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
            child: ElevatedButton.icon(
              key: const Key('intro_change_theme_button'),
              style: ButtonStyle(
                backgroundColor: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                    ? MaterialStateProperty.all(Colors.pink[200])
                    : MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                context.read<ThemeBloc>().add(ToggleThemeEvent());
              },
              icon: Icon(
                Icons.brightness_6,
                color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                    ? Colors.white
                    : Colors.black,
              ),
              label: Text(
                AppLocalizations.of(context)!.settingsChangeTheme,
                textScaleFactor: AppStyleConstants.introBodyTextScale,
                style: TextStyle(
                  color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
