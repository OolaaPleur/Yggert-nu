import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobility_app/screens/intro/pages/intro_fifth_page.dart';
import 'package:mobility_app/screens/intro/pages/intro_first_page.dart';
import 'package:mobility_app/screens/intro/pages/intro_sixth_page.dart';
import 'package:mobility_app/screens/intro/pages/intro_third_page.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';

import '../../constants/constants.dart';
import '../../data/repositories/settings_repository.dart';
import '../home/home_screen.dart';
import '../home/widgets/onboarding_widget.dart';
import 'pages/intro_fourth_page.dart';
import 'pages/intro_second_page.dart';
import 'pages/intro_seventh_page.dart';

/// Class, defines introduction screen for user, who use app for the first time.
class Intro extends StatefulWidget {
  /// Constructor for [Intro].
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
            ? null
            : Colors.red[200],
      ),
    );
    return Scaffold(
      body: IntroductionScreen(
        scrollPhysics: const ClampingScrollPhysics(),
        next: const Icon(Icons.navigate_next),
        showBackButton: true,
        back: const Icon(Icons.navigate_before),
        onDone: () async {
          final navigator = Navigator.of(context);
          final settingsRepository = GetIt.I<SettingsRepository>();
          await settingsRepository.setBoolValue('first_load', value: true);
          await navigator.pushAndRemoveUntil(
            MaterialPageRoute<HomeScreen>(
              builder: (context) => const OnboardingWidget(),
            ),
            (Route<dynamic> route) => false,
          );
        },
        done:
            Text(key: const Key('intro_done_button'), AppLocalizations.of(context)!.doneButtonText),
        dotsFlex: 2,
        dotsContainerDecorator: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
            ? const BoxDecoration()
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppStyleConstants.introBottomColor,
                    Colors.red[200]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
        dotsDecorator: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
            ? const DotsDecorator()
            : DotsDecorator(
                size: const Size.square(10),
                activeSize: const Size(20, 10),
                activeColor: Theme.of(context).colorScheme.secondary,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
        pages: [
          introFirstPage(context),
          introSecondPage(context),
          introThirdPage(context),
          introFourthPage(context),
          introFifthPage(context),
          introSixthPage(context),
          introSeventhPage(context),
        ],
      ),
    );
  }
}
