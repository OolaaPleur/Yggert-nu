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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: const MapScreen(),
      //
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            key: UniqueKey(),
            backgroundColor:
                context.select((MapBloc bloc) => bloc.state.filters[MapFilters.busStop] ?? true)
                    ? Colors.lightBlue[300]
                    : Theme.of(context).disabledColor,
            onPressed: () {
              if (context.read<MapBloc>().state.busStopsAdded == false) {
                context.read<MapBloc>().add(const MapShowBusStops());
              }
              context.read<MapBloc>().add(const MapMarkerFilterButtonPressed(MapFilters.busStop));
            },
            child: context.select(
              (MapBloc bloc) => bloc.state.busStopAdditionStatus == BusStopAdditionStatus.loading,
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
            backgroundColor:
                context.select((MapBloc bloc) => bloc.state.filters[MapFilters.scooters] ?? true)
                    ? Colors.lightBlue[300]
                    : Theme.of(context).disabledColor,
            onPressed: () {
              context.read<MapBloc>().add(const MapMarkerFilterButtonPressed(MapFilters.scooters));
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
              context.read<MapBloc>().add(const MapMarkerFilterButtonPressed(MapFilters.cycles));
            },
            child: const Icon(Icons.pedal_bike_sharp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
