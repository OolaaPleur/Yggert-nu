import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';
import 'package:mobility_app/screens/map/bloc/map_bloc.dart';
import 'package:mobility_app/screens/settings/auth_bloc/auth_bloc.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';
import 'package:mobility_app/theme/bloc/theme_event.dart';
import 'package:mobility_app/theme/bloc/theme_state.dart';
import 'package:mocktail/mocktail.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState> implements ThemeBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// Create a mock for your SettingsRepository
class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  MockMapBloc? mockMapBloc;
  //MockThemeBloc? mockThemeBloc;
  MockSettingsRepository? mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    //mockThemeBloc = MockThemeBloc();
    mockMapBloc = MockMapBloc();

    // add your settingsRepository to GetIt service locator
    GetIt.I.registerSingleton<SettingsRepository>(mockSettingsRepository!);
  });

  tearDown(() {
    mockMapBloc?.close();
    //  mockThemeBloc?.close();
    GetIt.I.unregister<SettingsRepository>(); // don't forget to unregister it after the test run
  });

  testWidgets('should send MapMarkerFilterButtonPressed when scooter and bike FAB is pressed'
      'and two actions for bus FAB',
      (WidgetTester tester) async {
    when(() => mockMapBloc?.state).thenReturn(const MapState());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<MapBloc>.value(
            value: mockMapBloc!,
            child: Column(
              children: [
                FloatingActionButton(
                  key: const Key('bike_fab'),
                  onPressed: () {
                    mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.cycles));
                  },
                  child: const Icon(Icons.pedal_bike_sharp),
                ),
                FloatingActionButton(
                  key: const Key('scooter_fab'),
                  onPressed: () {
                    mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.scooters));
                  },
                  child: const Icon(Icons.electric_scooter),
                ),
                FloatingActionButton(
                  key: const Key('stop_fab'),
                  onPressed: () {
                    if (mockMapBloc?.state.busStopsAdded == false) {
                      mockMapBloc?.add(const MapShowBusStops());
                    }
                    if (mockMapBloc?.state.busStopsAdded ?? true) {
                      mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.busStop));
                    }
                  },
                  child: const Icon(Icons.directions_bus_sharp),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bike_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('scooter_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('stop_fab')));
    await tester.pumpAndSettle();

    verify(() => mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.cycles))).called(1);
    verify(() => mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.scooters))).called(1);
    verify(() => mockMapBloc?.add(const MapShowBusStops())).called(1);

    when(() => mockMapBloc?.state).thenReturn(const MapState(busStopsAdded: true));
    await tester.tap(find.byKey(const Key('stop_fab')));
    await tester.pumpAndSettle();
    verify(() => mockMapBloc?.add(const MapMarkerFilterButtonPressed(MapFilters.busStop))).called(1);
  });
}
