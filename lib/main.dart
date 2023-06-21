import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/app_bloc_observer.dart';
import 'domain/vehicle_repository.dart';
import 'map/bloc/map_bloc.dart';
import 'map/view/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VehicleRepository vehicleRepository = VehicleRepository();
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            backgroundColor: context.select((MapBloc bloc) =>
                    bloc.state.filters[MapFilters.scooters] == true)
                ? Colors.lightBlue[300]
                : Theme.of(context).disabledColor,
            onPressed: () {
              Map<MapFilters, bool> mapfilters =
                  context.read<MapBloc>().state.filters;
              Map<MapFilters, bool> filters = {
                MapFilters.cycles: mapfilters[MapFilters.cycles]!,
                MapFilters.scooters: !mapfilters[MapFilters.scooters]!,
                MapFilters.cars: mapfilters[MapFilters.cars]!
              };
              context.read<MapBloc>().add(MapFilteringMarkers(filters));
            },
            child: const Icon(Icons.electric_scooter, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: context.select((MapBloc bloc) =>
                    bloc.state.filters[MapFilters.cycles] == true)
                ? Colors.lightBlue[300]
                : Theme.of(context).disabledColor,
            onPressed: () {
              Map<MapFilters, bool> mapfilters =
                  context.read<MapBloc>().state.filters;
              Map<MapFilters, bool> filters = {
                MapFilters.cycles: !mapfilters[MapFilters.cycles]!,
                MapFilters.scooters: mapfilters[MapFilters.scooters]!,
                MapFilters.cars: mapfilters[MapFilters.cars]!
              };
              context.read<MapBloc>().add(MapFilteringMarkers(filters));
            },
            child: const Icon(Icons.pedal_bike_sharp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
