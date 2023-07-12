import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../exceptions/exceptions.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../../theme/bloc/theme_event.dart';
import '../../theme/bloc/theme_state.dart';
import '../../widgets/snackbar.dart';
import '../map/bloc/map_bloc.dart';
import 'auth_bloc/auth_bloc.dart';
import 'language_cubit/language_cubit.dart';
import 'widgets/change_language_dropdown.dart';
import 'widgets/dark_mode_switch.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/gtfs_file_download_date_card.dart';
import 'widgets/pick_city_dropdown.dart';
import 'widgets/show_trips_for_today_dropdown.dart';

/// [Settings] is widget, which is accessed through actions in appbar on
/// MapScreen. There user can change global settings of the app.
class Settings extends StatefulWidget {
  /// Default constructor for [Settings] widget.
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void sendDownloadDataToStates(AuthState state) {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isDownloading == true) {
          sendDownloadDataToStates(state);
        }
        if (state.error is SomeErrorOccurred) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar(context, exception: const SomeErrorOccurred()).showSnackBar(),
          );
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
                  backgroundColor:
                      context.read<ThemeBloc>().isDarkModeEnabled ? null : const Color(0xFFeffaf3),
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
                    const GoogleSignInButton(),
                    const DarkModeSwitch(),
                    const Divider(),
                    const ShowTripsForTodayDropdown(),
                    const Divider(),
                    const PickCityDropdown(),
                    const Divider(),
                    const ChangeLanguageDropdown(),
                    const Divider(),
                    const GtfsFileDownloadDateCard(),
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
    );
  }
}
