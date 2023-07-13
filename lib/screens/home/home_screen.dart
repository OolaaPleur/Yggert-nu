import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/screens/home/widgets/bus_icon.dart';
import 'package:mobility_app/widgets/snackbar.dart';

import '../../constants/constants.dart';
import '../../exceptions/exceptions.dart';
import '../map/bloc/map_bloc.dart';
import '../map/view/map_screen.dart';
import '../settings/settings.dart';

/// Home Screen of the app.
class HomeScreen extends StatefulWidget {
  /// Home Screen constructor.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  Widget refreshIcon(BuildContext context) {
    const Widget icon = SizedBox(
      width: 24,
      height: 24,
      child: Icon(Icons.refresh_sharp),
    );

    const Widget spinner = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.blue,
        strokeWidth: 2,
      ),
    );

    if (context.select((MapBloc bloc) => bloc.state.tripStatus == TripStatus.loading) ||
        context.select((MapBloc bloc) => bloc.state.status == MapStateStatus.loading) ||
        context.select((MapBloc bloc) => bloc.state.filteringStatus == true)) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: icon,
        secondChild: spinner,
        crossFadeState: CrossFadeState.showSecond,
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
      );
    } else {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: icon,
        secondChild: spinner,
        crossFadeState: CrossFadeState.showFirst,
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
      );
    }
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
            centerTitle: true,
            title: BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                return context.read<MapBloc>().state.pickedCity == City.tartu
                    ? Text(
                        AppLocalizations.of(context)!.settingsTartu,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    : Text(
                        AppLocalizations.of(context)!.settingsTallinn,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      );
              },
            ),
            elevation: 2,
            actions: [
              IconButton(
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
              IconButton(
                tooltip: AppLocalizations.of(context)!.homeAppBarRefreshIcon,
                onPressed: () {
                  context.read<MapBloc>().add(const MapMarkersPlacingOnMap());
                },
                icon: refreshIcon(context),
              ),
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
                key: UniqueKey(),
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
                tooltip: AppLocalizations.of(context)!.homeScooterFAB,
                heroTag: null,
                key: UniqueKey(),
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
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                tooltip: AppLocalizations.of(context)!.homeBikeFAB,
                heroTag: null,
                key: UniqueKey(),
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
