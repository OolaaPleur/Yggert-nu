import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc_observer.dart';
import 'domain/vehicle_repository.dart';
import 'map/bloc/map_bloc.dart';
import 'map/view/map_screen.dart';
import 'screens/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
}

/// Entry widget of the app.
class MyApp extends StatelessWidget {
  /// Entry widget constructor.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleRepository = VehicleRepository();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: BlocProvider(
        create: (context) => MapBloc(vehicleRepository: vehicleRepository),
        child: const HomeScreen(),
      ),
    );
  }
}

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
      }
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
            title: const Text('Tartu Mobility App'),
            elevation: 2,
            actions: [
              IconButton(
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
                  return current.networkException.isNotEmpty;
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
                              child: Text.rich(
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
                heroTag: null,
                key: UniqueKey(),
                backgroundColor:
                    context.select((MapBloc bloc) => bloc.state.filters[MapFilters.busStop] ?? true)
                        ? Colors.lightBlue[300]
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
                        context
                            .read<MapBloc>()
                            .add(const MapMarkerFilterButtonPressed(MapFilters.busStop));
                      },
                child: context.select(
                          (MapBloc bloc) => bloc.state.tripStatus == TripStatus.loading,
                        ) ||
                        context.select(
                          (MapBloc bloc) =>
                              bloc.state.publicTransportStopAdditionStatus ==
                              PublicTransportStopAdditionStatus.loading,
                        ) ||
                        context.select(
                          (MapBloc bloc) => bloc.state.status == MapStateStatus.loading,
                        ) ||
                        context.select(
                          (MapBloc bloc) => bloc.state.filteringStatus == true,
                        )
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.directions_bus_sharp, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: null,
                key: UniqueKey(),
                backgroundColor: context
                        .select((MapBloc bloc) => bloc.state.filters[MapFilters.scooters] ?? true)
                    ? Colors.lightBlue[300]
                    : Theme.of(context).disabledColor,
                onPressed: () {
                  context
                      .read<MapBloc>()
                      .add(const MapMarkerFilterButtonPressed(MapFilters.scooters));
                },
                child: context.select((MapBloc mapBloc) => mapBloc.state.filteringStatus == true)
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.electric_scooter, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: null,
                key: UniqueKey(),
                backgroundColor:
                    context.select((MapBloc bloc) => bloc.state.filters[MapFilters.cycles] ?? true)
                        ? Colors.lightBlue[300]
                        : Theme.of(context).disabledColor,
                onPressed: () {
                  context
                      .read<MapBloc>()
                      .add(const MapMarkerFilterButtonPressed(MapFilters.cycles));
                },
                child: const Icon(Icons.pedal_bike_sharp, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
