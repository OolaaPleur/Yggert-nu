import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';
import 'package:mobility_app/screens/settings/language_cubit/language_cubit.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';
import 'package:mobility_app/theme/bloc/theme_state.dart';

import '../screens/home/widgets/onboarding_widget.dart';
import '../screens/intro/intro.dart';
import '../screens/map/bloc/map_bloc.dart';
import '../screens/settings/auth_bloc/auth_bloc.dart';
import '../theme/bloc/theme_event.dart';

/// Entry widget of the app.
class MyApp extends StatefulWidget {
  /// Entry widget constructor.
  const MyApp({super.key, this.locale});

  /// Set locale, used for TEST ONLY.
  final Locale? locale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _settingsRepository = GetIt.I<SettingsRepository>();
  late Future<bool> firstLoadFuture;

  @override
  void initState() {
    super.initState();
    firstLoadFuture = _settingsRepository.getBoolValue('first_load');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()
            ..add(
              LoadThemeEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => AuthBloc()..add(AutoSignIn()),
        ),
        BlocProvider(

          create: (context) => MapBloc(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          return MaterialApp(
            locale: widget.locale ?? context.watch<LanguageCubit>().state,
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              return supportedLocales.contains(deviceLocale)
                  ? deviceLocale
                  : supportedLocales.first;
            },
            theme: theme.themeData,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: FutureBuilder<bool>(
              future: firstLoadFuture,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == false) {
                    return const Intro();
                  } else {
                    return const OnboardingWidget();
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
