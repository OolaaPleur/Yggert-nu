import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import 'package:yggert_nu/screens/settings/theme_switch/theme_segmented_buttons.dart';
import 'package:yggert_nu/screens/settings/widgets/animated_icon_button.dart';
import 'package:yggert_nu/screens/settings/widgets/auth_avatar.dart';
import 'package:yggert_nu/screens/settings/widgets/change_low_charge_scooter_visibility.dart';
import 'package:yggert_nu/screens/settings/widgets/show_tutorial_again.dart';
import 'package:yggert_nu/theme/theme_helpers.dart';


import '../../constants/constants.dart';
import '../../exceptions/exceptions.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../../widgets/snackbar.dart';
import '../map/bloc/map_bloc.dart';
import 'auth_bloc/auth_bloc.dart';
import 'language_cubit/language_cubit.dart';
import 'widgets/app_info_text.dart';
import 'widgets/change_city/pick_city_dropdown.dart';
import 'widgets/change_language_dropdown.dart';
import 'widgets/email_developer_list_tile.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/gtfs_file_download_date_card.dart';
import 'widgets/rate_app_tile.dart';
import 'widgets/show_trips_for_today_dropdown.dart';

/// [Settings] is widget, which is accessed through actions in appbar on
/// MapScreen. There user can change global settings of the app.
class Settings extends StatefulWidget {
  /// Default constructor for [Settings] widget.
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  void sendDownloadDataToStates(AuthState state) {
    context
        .read<ThemeBloc>()
        .add(ChangeThemeEvent(appTheme: ThemeHelper.toAppTheme(state.settings!['theme'] as String)));

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
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _controller2;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _animation2 = Tween<double>(begin: 0, end: 1).animate(_controller2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.dataStatus == Status.downloadSuccess) {
          sendDownloadDataToStates(state);
        }
        if (state.error is SomeErrorOccurred) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar(context, exception: const SomeErrorOccurred()).showSnackBar(),
          );
        }
        else if (state.error is NoInternetConnectionInSettings) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar(context, exception: const NoInternetConnectionInSettings()).showSnackBar(),
          );
        }
        else if (state.infoMessage == InfoMessage.userDataDownloadedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar(context, infoMessage: InfoMessage.userDataDownloadedSuccessfully).showSnackBar(),
          );
        }
        else if (state.infoMessage == InfoMessage.userDataUploadedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar(context, infoMessage: InfoMessage.userDataUploadedSuccessfully).showSnackBar(),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return Scaffold(
                backgroundColor: context.read<ThemeBloc>().isDarkMode
                    ? null
                    : AppStyleConstants.scaffoldColor,
                appBar: AppBar(
                  backgroundColor: context.read<ThemeBloc>().isDarkMode
                      ? null
                      : AppStyleConstants.appBarColor,
                  title: Text(AppLocalizations.of(context)!.settingsAppBarTitle),
                  centerTitle: true,
                  actions: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: IconButton(
                        icon: authState.dataStatus == Status.uploading
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(30, (30 * 1).toDouble()),
                                    painter: CloudCustomPainter(),
                                  ),
                                  AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: _animation.value * 100,
                                        child: child!,
                                      );
                                    },
                                    child: CustomPaint(
                                      size: const Size(0.75, 0.75 * 1),
                                      painter: ArrowCustomPainter(),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(30, (30 * 1).toDouble()),
                                    painter: CloudCustomPainter(),
                                  ),
                                  CustomPaint(
                                    size: const Size(0.75, 0.75 * 1),
                                    painter: ArrowCustomPainter(),
                                  ),
                                ],
                              ),
                        onPressed: authState.user != null
                            ? () {
                                context.read<AuthBloc>().add(UploadUserSettingsEvent());
                              }
                            : null, // Disabled state
                      ),
                      secondChild: const Align(child: SizedBox.shrink()),
                      crossFadeState: authState.user != null
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: IconButton(
                        icon: authState.dataStatus == Status.downloading
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(30, (30 * 1).toDouble()),
                                    painter: CloudCustomPainter(),
                                  ),
                                  AnimatedBuilder(
                                    animation: _animation2,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: _animation2.value * 100,
                                        child: Transform.rotate(
                                          angle: pi,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CustomPaint(
                                      size: const Size(0.75, 0.75 * 1),
                                      painter: ArrowCustomPainter(),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(30, (30 * 1).toDouble()),
                                    painter: CloudCustomPainter(),
                                  ),
                                  Transform.rotate(
                                    angle: pi,
                                    child: CustomPaint(
                                      size: const Size(0.75, 0.75 * 1),
                                      painter: ArrowCustomPainter(),
                                    ),
                                  ),
                                ],
                              ),
                        onPressed: authState.user != null
                            ? () {
                                context.read<AuthBloc>().add(DownloadUserSettingsEvent());
                              }
                            : null, // Disabled state
                      ),
                      secondChild: const Align(child: SizedBox.shrink()),
                      crossFadeState: authState.user != null
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    ),
                  ],
                ),
                body: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    UserAvatar(authState: authState),
                    const GoogleSignInButton(),
                    const ThemeSegmentedButtons(),
                    const Divider(),
                    const ShowTripsForTodayDropdown(),
                    const Divider(),
                    const PickCityDropdown(),
                    const Divider(),
                    const ChangeLanguageDropdown(),
                    const Divider(),
                    const ChangeLowChargeScooterVisibility(),
                    const Divider(),
                    const ShowTutorialAgain(),
                    const Divider(),
                    const EmailDeveloperListTile(),
                    const Divider(),
                    const RateAppTile(),
                    const Divider(),
                    const GtfsFileDownloadDateCard(),
                    const Divider(),
                    const AppInfoText(),
                    const Divider(),
                    Center(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: TextButton(
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
                        ),
                        secondChild: const SizedBox.shrink(),
                        crossFadeState: authState.user != null
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
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
