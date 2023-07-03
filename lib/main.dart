import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/screens/language_cubit/language_cubit.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';
import 'package:mobility_app/theme/bloc/theme_state.dart';

import 'app_bloc_observer.dart';
import 'domain/vehicle_repository.dart';
import 'home/home_screen.dart';
import 'map/bloc/map_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
}

/// Entry widget of the app.
class MyApp extends StatefulWidget {
  /// Entry widget constructor.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final vehicleRepository = VehicleRepository();

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, theme) {
        return BlocProvider(
          create: (context) => LanguageCubit(),
          child: Builder(
            builder: (context) {
              final locale = context.watch<LanguageCubit>().state;
              return MaterialApp(
                locale: locale,
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  return supportedLocales.contains(deviceLocale)
                      ? deviceLocale
                      : supportedLocales.first;
                },
                theme: theme.themeData,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: BlocProvider(
                  create: (context) => MapBloc(vehicleRepository: vehicleRepository),
                  child: const HomeScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
