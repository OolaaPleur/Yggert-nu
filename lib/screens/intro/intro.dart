import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';

import '../../data/repositories/settings_repository.dart';
import '../../theme/bloc/theme_event.dart';
import '../../utils/record_type_generator.dart';
import '../../utils/string_to_enum.dart';
import '../home/home_screen.dart';
import '../home/widgets/onboarding_widget.dart';
import '../map/bloc/map_bloc.dart';

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
    final recordTypes = RecordTypeGenerator().generate(context);
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
        done: Text(AppLocalizations.of(context)!.doneButtonText),
        dotsFlex: 2,
        dotsContainerDecorator: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
            ? const BoxDecoration()
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[300]!,
                    Colors.red[200]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                //color: Colors.pink[200]
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
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFfffad0), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/launcher_icon/launcher_icon.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introFirstScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introFirstScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFfff8b7), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_city.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introSecondScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introSecondScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                DropdownButton<String>(
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                  value: context.select((MapBloc bloc) => bloc.state.pickedCity.name),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      context.read<MapBloc>().add(MapChangeCity(getMyEnumFromStr(newValue!)!));
                    });
                  },
                  items: recordTypes
                      .map<DropdownMenuItem<String>>(
                        (recordType) => DropdownMenuItem<String>(
                          value: recordType.key,
                          child: Text(recordType.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.changeCity,
                  textScaleFactor: 1.2,
                ),
              ],
            ),
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
              boxDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFf7aa), Colors.red[300]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_please_note.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introSecondAndHalfScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introSecondAndHalfScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFfff59d), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_bus_stop.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introThirdScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introThirdScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFfff284), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_theme_change.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introFourthScreenHeader,
                    textScaleFactor: 1.7,
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
                    textScaleFactor: 1.2,
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
                              colors: [Colors.red[200]!, Colors.red[300]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
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
                        textScaleFactor: 1.2,
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
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      //gradient: RadialGradient(colors: [Colors.blue[200]!, Colors.red[300]!], radius: 0.8),
                      gradient: LinearGradient(
                        colors: [const Color(0xFFfff06a), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_google_sign_in.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introFifthScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introFifthScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          PageViewModel(
            decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
                ? const PageDecoration()
                : PageDecoration(
                    boxDecoration: BoxDecoration(
                      //gradient: RadialGradient(colors: [Colors.blue[200]!, Colors.red[300]!], radius: 0.8),
                      gradient: LinearGradient(
                        colors: [const Color(0xFFffed51), Colors.red[300]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
            titleWidget: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/intro/intro_end.png',
                    scale: 6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.introSixthScreenHeader,
                    textScaleFactor: 1.7,
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
                    AppLocalizations.of(context)!.introSecondScreenBody,
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
