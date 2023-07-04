
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/home/widgets/bus_icon.dart';

import '../map/bloc/map_bloc.dart';
import '../map/view/map_screen.dart';
import '../screens/settings.dart';

/// Home Screen of the app.
class HomeScreen extends StatefulWidget {
  /// Home Screen constructor.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  List<InlineSpan>? errorText(Map<String, List<String>> messageMap) {
    if (messageMap.isNotEmpty) {
      final message = messageMap.keys.first;
      final highlightedWords = messageMap[message]!;

      if (messageMap.values.first.contains('Bolt')) {
        final messageSpans = message.split(' ').map((word) {
          return highlightedWords.contains(word)
              ? TextSpan(
            text: '$word ',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          )
              : TextSpan(text: '$word ');
        }).toList();
        return messageSpans;
      } else if (messageMap.values.first.contains('Tartu')) {
        final messageSpans = message.split(' ').map((word) {
          return highlightedWords.contains(word)
              ? TextSpan(
            text: '$word ',
            style:
            const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
          )
              : TextSpan(text: '$word ');
        }).toList();
        return messageSpans;
      } if (messageMap.keys.first == 'No need to download') {
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoNeedToDownload)];
      }
      return [TextSpan(text: message)];
    }
    return null;
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
            title: Text(AppLocalizations.of(context)!.homeAppBarTitle),
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
                icon: context.select((MapBloc bloc) => bloc.state.status == MapStateStatus.loading)
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                )
                    : const Icon(Icons.refresh_sharp),
              ),
              BlocListener<MapBloc, MapState>(
                listenWhen: (previous, current) {
                  //print('${previous.networkException} ${current.networkException}');
                  return current.networkException.isNotEmpty &&
                      previous.networkException.keys.toString() !=
                          current.networkException.keys.toString();
                },
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 10),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child:
                              Text.rich(
                                TextSpan(
                                  children: errorText(state.networkException),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: const StadiumBorder(),
                      width: MediaQuery.of(context).size.width * 0.9,
                      dismissDirection: DismissDirection.none,
                    ),
                  );
                },
                child: const SizedBox.shrink(),
              )
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
