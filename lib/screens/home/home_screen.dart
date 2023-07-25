import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobility_app/screens/home/widgets/bus_icon.dart';
import 'package:mobility_app/screens/home/widgets/refresh_icon.dart';
import 'package:mobility_app/widgets/snackbar.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

import '../../constants/constants.dart';
import '../../data/repositories/settings_repository.dart';
import '../../exceptions/exceptions.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../map/bloc/map_bloc.dart';
import '../map/markers/map_marker.dart';
import '../map/view/map_screen.dart';
import '../settings/settings.dart';
import 'widgets/app_bar_title.dart';
import 'widgets/onboarding_widget.dart';

/// Home Screen of the app.
class HomeScreen extends StatefulWidget {
  /// Home Screen constructor.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      final tutorialPassed = await _settingsRepository.getBoolValue('tutorial_passed');
      final onboarding = funState();
      if (onboarding != null && tutorialPassed == false) {
        onboarding.show();
      }
    });
    super.initState();
  }
  OnboardingState? funState () {
    return Onboarding.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        /// I put scaffold into scaffold because otherwise snackbar with
        /// property SnackBarBehavior.floating goes on top of all FABs
        /// so it places snackbar on top of screen.
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: context.read<ThemeBloc>().isDarkModeEnabled
                ? null
                : AppStyleConstants.appBarColor,
            centerTitle: true,
            title: Focus(focusNode: appBarTitleFocusNode, child: const AppBarTitle()),
            elevation: 2,
            actions: [
              IconButton(
                key: const Key('settings_icon_button'),
                focusNode: settingsIconFocusNode,
                tooltip: AppLocalizations.of(context)!.homeAppBarSettingsIcon,
                onPressed: () {
                  final mapBloc = BlocProvider.of<MapBloc>(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => BlocProvider.value(
                        value: mapBloc,
                        child: const Settings(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
              const RefreshIcon(),
              BlocListener<MapBloc, MapState>(
                listenWhen: (previous, current) {
                  return current.exception.runtimeType != AppException &&
                      previous.exception.toString() != current.exception.toString();
                },
                listener: (context, state) {
                  final mySnackBar = AppSnackBar(context, exception: state.exception);
                  ScaffoldMessenger.of(context).showSnackBar(mySnackBar.showSnackBar());
                },
                child: const SizedBox.shrink(),
              ),
              BlocListener<MapBloc, MapState>(
                listenWhen: (previous, current) {
                  return previous.infoMessage != current.infoMessage &&
                      current.infoMessage != InfoMessage.defaultMessage;
                },
                listener: (context, state) {
                  final mySnackBar = AppSnackBar(context, infoMessage: state.infoMessage);
                  ScaffoldMessenger.of(context).showSnackBar(mySnackBar.showSnackBar());
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
          body: const MapScreen(),
          //
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                tooltip: AppLocalizations.of(context)!.homeStopFAB,
                heroTag: null,
                key: const Key('stop_fab'),
                backgroundColor:
                    context.select((MapBloc bloc) => bloc.state.filters[MapFilters.busStop] ?? true)
                        ? null
                        : Theme.of(context).disabledColor,
                onPressed: context.select(
                          (MapBloc bloc) => bloc.state.tripStatus == TripStatus.loading,
                        ) ||
                        context.select(
                          (MapBloc bloc) =>
                              bloc.state.publicTransportStopAdditionStatus ==
                              PublicTransportStopAdditionStatus.loading,
                        ) ||
                        context.select(
                          (MapBloc bloc) => bloc.state.status == MapStateStatus.loading,
                        )
                    ? null
                    : () {
                        if (context.read<MapBloc>().state.busStopsAdded == false) {
                          context.read<MapBloc>().add(const MapShowBusStops());
                        }
                        if (context.read<MapBloc>().state.busStopsAdded == true) {
                          context
                              .read<MapBloc>()
                              .add(const MapMarkerFilterButtonPressed(MapFilters.busStop));
                        }
                      },
                child: const BusIcon(),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                tooltip: AppLocalizations.of(context)!.homeCarFAB,
                heroTag: null,
                key: const Key('car_fab'),
                backgroundColor:
                context.select((MapBloc bloc) => bloc.state.filters[MapFilters.cars] ?? true)
                    ? null
                    : Theme.of(context).disabledColor,
                onPressed: () {
                  if (context.read<MapBloc>().state.markers.containsKey(MarkerType.car)) {
                    context
                        .read<MapBloc>()
                        .add(const MapMarkerFilterButtonPressed(MapFilters.cars));
                  }
                  else {
                    context
                        .read<MapBloc>()
                        .add(const MapAddRentalCars());
                  }
                },
                child: const Icon(Icons.car_rental),
              ),
              const SizedBox(
                height: 10,
              ),
              Focus(
                focusNode: filtersFocusNode,
                child: FloatingActionButton(
                  tooltip: AppLocalizations.of(context)!.homeScooterFAB,
                  heroTag: null,
                  key: const Key('scooter_fab'),
                  backgroundColor: context
                          .select((MapBloc bloc) => bloc.state.filters[MapFilters.scooters] ?? true)
                      ? null
                      : Theme.of(context).disabledColor,
                  onPressed: () {
                    context
                        .read<MapBloc>()
                        .add(const MapMarkerFilterButtonPressed(MapFilters.scooters));
                  },
                  child: context.select((MapBloc mapBloc) => mapBloc.state.filteringStatus == true)
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.electric_scooter),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                tooltip: AppLocalizations.of(context)!.homeBikeFAB,
                heroTag: null,
                key: const Key('bike_fab'),
                backgroundColor:
                    context.select((MapBloc bloc) => bloc.state.filters[MapFilters.cycles] ?? true)
                        ? null
                        : Theme.of(context).disabledColor,
                onPressed: () {
                  context
                      .read<MapBloc>()
                      .add(const MapMarkerFilterButtonPressed(MapFilters.cycles));
                },
                child: const Icon(Icons.pedal_bike_sharp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
