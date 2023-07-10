import 'package:auth_buttons/auth_buttons.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/exceptions/exceptions.dart';
import 'package:mobility_app/screens/settings/auth_bloc/auth_bloc.dart';

import '../../theme/bloc/theme_bloc.dart';
import '../../theme/bloc/theme_event.dart';
import '../../theme/bloc/theme_state.dart';
import '../../widgets/snackbar.dart';
import '../map/bloc/map_bloc.dart';
import 'gtfs/gtfs_bloc.dart';
import 'language_cubit/language_cubit.dart';
import 'widgets/settings_widgets.dart';

/// [Settings] is widget, which is accessed through actions in appbar on
/// MapScreen. There user can change global settings of the app.
class Settings extends StatefulWidget {
  /// Default constructor for [Settings] widget.
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isDownloading == true) {
            context
                .read<ThemeBloc>()
                .add(ToggleDownloadedThemeEvent(isDark: state.settings!['isDark'] as bool));

            final cityString = state.settings!['pickedCity'] as String;
            final city = City.values.firstWhereOrNull((e) => e.name == cityString) ?? City.tartu;
            context.read<MapBloc>().add(MapChangeCity(city));

            final userTripsFilterValueString = state.settings!['userTripsFilterValue'] as String;
            final userTripsFilterValue = GlobalShowTripsForToday.values
                    .firstWhereOrNull((e) => e.name == userTripsFilterValueString) ??
                GlobalShowTripsForToday.all;
            context.read<MapBloc>().add(MapChangeTimetableMode(userTripsFilterValue));

            context
                .read<LanguageCubit>()
                .changeLanguage(Locale(state.settings!['language_code'] as String));
            context.read<AuthBloc>().add(SignInWithGoogleEvent());
          }
          if (state.error is SomeErrorOccurred) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(context, const SomeErrorOccurred()).showSnackBar());
            context.read<AuthBloc>().add(SignInWithGoogleEvent());
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return Scaffold(
                  backgroundColor:
                      context.read<ThemeBloc>().isDarkModeEnabled ? null : const Color(0xFFD8F3E3),
                  appBar: AppBar(
                    backgroundColor: context.read<ThemeBloc>().isDarkModeEnabled
                        ? null
                        : const Color(0xFFeffaf3),
                    title: Text(AppLocalizations.of(context)!.settingsAppBarTitle),
                    centerTitle: true,
                    actions: [
                      if (authState.userCredential != null)
                        IconButton(
                          icon: const Icon(Icons.cloud_upload),
                          onPressed: () {
                            context.read<AuthBloc>().add(UploadUserSettingsEvent());
                          },
                        )
                      else
                        const SizedBox.shrink(),
                      if (authState.userCredential != null)
                        IconButton(
                          icon: const Icon(Icons.cloud_download),
                          onPressed: () {
                            context.read<AuthBloc>().add(DownloadUserSettingsEvent());
                          },
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (authState.userCredential != null)
                        CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: Image.network(
                              authState.userCredential!.user!.photoURL!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          child: authState.userCredential != null
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: Text(
                                    authState.userCredential!.user!.displayName!,
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                )
                              : GoogleAuthButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(SignInWithGoogleEvent());
                                  },
                                  style: const AuthButtonStyle(textStyle: TextStyle()),
                                  darkMode: context.read<ThemeBloc>().isDarkModeEnabled,
                                ),
                        ),
                      ),
                      Card(
                        color: context.read<ThemeBloc>().isDarkModeEnabled
                            ? null
                            : const Color(0xFF66cda2),
                        child: SwitchListTile(
                          title: Row(
                            children: [
                              const Icon(Icons.brightness_6),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.settingsChangeTheme,
                              ),
                            ],
                          ),
                          value: context.read<ThemeBloc>().isDarkModeEnabled,
                          onChanged: (bool value) {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                        ),
                      ),
                      const Divider(),
                      BlocBuilder<MapBloc, MapState>(
                        buildWhen: (previous, current) {
                          return previous.globalShowTripsForToday !=
                              current.globalShowTripsForToday;
                        },
                        builder: (context, state) {
                          return Card(
                            color: context.read<ThemeBloc>().isDarkModeEnabled
                                ? null
                                : const Color(0xFF66cda2),
                            child: ExpansionTile(
                              title: context.read<MapBloc>().state.globalShowTripsForToday ==
                                      GlobalShowTripsForToday.all
                                  ? Text(AppLocalizations.of(context)!.settingsGlobalFilterAll)
                                  : Text(AppLocalizations.of(context)!.settingsGlobalFilterToday),
                              children: <Widget>[
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem(
                                        GlobalShowTripsForToday.all,
                                        AppLocalizations.of(context)!.settingsGlobalFilterAll,
                                      ),
                                      onTap: () {
                                        context.read<MapBloc>().add(const MapChangeTimetableMode(
                                            GlobalShowTripsForToday.all,),);
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                      },
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem(
                                        GlobalShowTripsForToday.today,
                                        AppLocalizations.of(context)!.settingsGlobalFilterToday,
                                      ),
                                      onTap: () {
                                        context.read<MapBloc>().add(
                                              const MapChangeTimetableMode(
                                                GlobalShowTripsForToday.today,
                                              ),
                                            );
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      BlocBuilder<MapBloc, MapState>(
                        buildWhen: (previous, current) {
                          return previous.pickedCity != current.pickedCity;
                        },
                        builder: (context, state) {
                          return Card(
                            color: context.read<ThemeBloc>().isDarkModeEnabled
                                ? null
                                : const Color(0xFF66cda2),
                            child: ExpansionTile(
                              title: context.read<MapBloc>().state.pickedCity == City.tartu
                                  ? Text(
                                      AppLocalizations.of(context)!.settingsTartu,
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(AppLocalizations.of(context)!.settingsTallinn),
                              subtitle: const Text('выберри город'),
                              leading: const Icon(Icons.location_city),
                              children: <Widget>[
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem(
                                        City.tartu,
                                        AppLocalizations.of(context)!.settingsTartu,
                                      ),
                                      onTap: () {
                                        context
                                            .read<MapBloc>()
                                            .add(const MapChangeCity(City.tartu));
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                      },
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem(
                                        City.tallinn,
                                        AppLocalizations.of(context)!.settingsTallinn,
                                      ),
                                      onTap: () {
                                        context
                                            .read<MapBloc>()
                                            .add(const MapChangeCity(City.tallinn));
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      BlocBuilder<LanguageCubit, Locale>(
                        builder: (context, state) {
                          return Card(
                            color: context.read<ThemeBloc>().isDarkModeEnabled
                                ? null
                                : const Color(0xFF66cda2),
                            child: ExpansionTile(
                              leading: const Icon(Icons.language),
                              subtitle: const Text(
                                'выберри язык',
                              ),
                              trailing: const Text('test'),
                              title: context.read<LanguageCubit>().state.languageCode == 'en'
                                  ? Text(AppLocalizations.of(context)!.settingsLanguageEnglish)
                                  : Text(AppLocalizations.of(context)!.settingsLanguageRussian),
                              children: <Widget>[
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem(
                                        'en',
                                        AppLocalizations.of(context)!.settingsLanguageEnglish,
                                      ),
                                      onTap: () {
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                        context
                                            .read<LanguageCubit>()
                                            .changeLanguage(const Locale('en'));
                                      },
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    return ListTile(
                                      title: generateDropdownMenuItem('ru',
                                          AppLocalizations.of(context)!.settingsLanguageRussian,),
                                      onTap: () {
                                        context
                                            .read<LanguageCubit>()
                                            .changeLanguage(const Locale('ru'));
                                        ExpansionTileController.maybeOf(context)!.collapse();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Card(
                        color: context.read<ThemeBloc>().isDarkModeEnabled
                            ? null
                            : const Color(0xFF66cda2),
                        child: BlocProvider(
                          create: (context) => GtfsBloc(),
                          child: BlocBuilder<GtfsBloc, GtfsState>(
                            builder: (context, state) {
                              context.read<GtfsBloc>().add(
                                    GetGtfsData(
                                      localizedString: AppLocalizations.of(context)!
                                          .settingsGtfsFileWasDownloaded,
                                    ),
                                  );
                              if (state is GtfsNoData) {
                                return ListTile(
                                    title: Text(
                                  AppLocalizations.of(context)!.settingsNoGtfsFile,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),);
                              } else if (state is GtfsDataLoaded) {
                                return ListTile(
                                  title: Text(
                                    state.result,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                      const Divider(),
                      if (authState.userCredential != null)
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(SignOutEvent());
                          },
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: Colors.red[700],
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink()
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
