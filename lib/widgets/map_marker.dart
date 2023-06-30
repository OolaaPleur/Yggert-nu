import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport.dart';
import 'package:mobility_app/map/bloc/map_bloc.dart';
import 'package:mobility_app/widgets/text_for_filter_button.dart';

import '../domain/bolt_scooter/bolt_scooter.dart';
import '../domain/tartu_bike_station/tartu_bike_station.dart';
import '../domain/vehicle_repository.dart';
import 'modal_bottom_sheet_bike_station_info.dart';
import 'modal_bottom_sheet_scooter_info.dart';

/// Type of the marker.
enum MarkerType {
  /// Public transport stop.
  stop,

  /// Bolt scooter.
  scooter,

  /// Tartu smart bike.
  bike,

  /// Default marker type.
  none
}

/// Map marker class.
class MapMarker extends Marker {
  /// Map marker constructor.
  MapMarker({
    required this.markerType,
    double? width,
    double? height,
    LatLng? point,
    WidgetBuilder? builder,
    Key? key,
  }) : super(
          width: width ?? 0,
          height: height ?? 0,
          point: point ?? LatLng(0, 0),
          builder: builder ?? (_) => Container(),
          key: key ?? const Key('no_key_from_server'),
        );

  /// Type of the marker.
  final MarkerType markerType;
}

/// Class for markers creation.
class CreateMapMarkerList {
  /// Create map marker, so after it could be returned.
  MapMarker mapMarker = MapMarker(markerType: MarkerType.none);

  /// Access vehicle repository. In this file it needs it because when user
  /// press the bike station icon, we need to make request to server, to get
  /// info about total count of bikes, as well on pedelec and usual bikes.
  final vehicleRepository = VehicleRepository();

  /// Function to create markers.
  MapMarker mapMarkerMakeMarkers(dynamic vehicleOrStop, MapBloc mapBloc) {
    switch (vehicleOrStop.runtimeType) {
      case TartuBikeStations:
        {
          final bikeStation = vehicleOrStop as TartuBikeStations;
          mapMarker = MapMarker(
            markerType: MarkerType.bike,
            key: Key(bikeStation.id),
            height: 65,
            width: 65,
            builder: (context) => Container(
              margin: context.select(
        (MapBloc bloc) => bloc.state.keyFromOpenedMarker == bikeStation.id,
        )
        ? EdgeInsets.zero
            : const EdgeInsets.all(2),
              child: TextButton(
                onPressed: () {
                  final bikeInfo = vehicleRepository;
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      mapBloc.add(MapEnlargeIcon(bikeStation.id));
                      return FutureBuilder<SingleBikeStation>(
                        future: bikeInfo.getBikeInfo(bikeStation.id),
                        builder:
                            (BuildContext context, AsyncSnapshot<SingleBikeStation> asyncSnapshot) {
                          if (asyncSnapshot.hasError) {
                            return Container(
                              color: Colors.red,
                              // Display an error message with red background
                              height: 100,
                              width: double.infinity,
                              child: Center(
                                child: Text('Error: ${asyncSnapshot.error}'),
                              ),
                            );
                          }
                          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              color: Colors.white12,
                              // Display a loading indicator with grey background
                              height: 100,
                              width: double.infinity,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (asyncSnapshot.connectionState == ConnectionState.done) {
                            return ModalBottomSheetBikeStationInfo(
                              singleBikeStation: asyncSnapshot.data,
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    },
                  ).whenComplete(
                        () => mapBloc.add(
                      const MapEnlargeIcon(''),
                    ),
                  );
                },
                child: Center(
                  child: Stack(
                    children: [
                      Image.asset('assets/bicycle.png', height: 60, width: 60),
                      Center(
                        child: Text(
                          bikeStation.totalLockedCycleCount.toString(),
                          style: const TextStyle(fontSize: 22, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            point: LatLng(bikeStation.latitude, bikeStation.longitude),
          );
        }
      case BoltScooter:
        {
          final scooter = vehicleOrStop as BoltScooter;
          mapMarker = MapMarker(
            markerType: MarkerType.scooter,
            key: Key(scooter.id.toString()),
            height: 65,
            width: 65,
            builder: (context) => BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                return Container(
                  margin: context.select(
                    (MapBloc bloc) => bloc.state.keyFromOpenedMarker == scooter.id.toString(),
                  )
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(2),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          mapBloc.add(MapEnlargeIcon(scooter.id.toString()));
                          return ModalBottomSheetScooterInfo(boltScooter: scooter);
                        },
                      ).whenComplete(
                        () => mapBloc.add(
                          const MapEnlargeIcon(''),
                        ),
                      );
                    },
                    child: scooter.charge > 30
                        ? Image.asset('assets/scooter.png')
                        : Image.asset(
                            'assets/scooter_low_battery.png',
                          ),
                  ),
                );
              },
            ),
            point: LatLng(scooter.latitude, scooter.longitude),
          );
        }
      case Stop:
        {
          final stop = vehicleOrStop as Stop;
          mapMarker = MapMarker(
            markerType: MarkerType.stop,
            key: Key(stop.stopId),
            height: 55,
            width: 55,
            builder: (context) => StopMarkerButton(
              mapBloc: mapBloc,
              stop: stop,
            ),
            point: LatLng(stop.latitude, stop.longitude),
          );
        }
    }
    return mapMarker;
  }
}

/// Class defines child of Stop marker.
class StopMarkerButton extends StatelessWidget {
  /// Constructor of [StopMarkerButton].
  const StopMarkerButton({required this.mapBloc, required this.stop, super.key});

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  /// [Stop] object, defines current picked stop.
  final Stop stop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.select(
            (MapBloc bloc) => bloc.state.keyFromOpenedMarker == stop.stopId,
      )
          ? EdgeInsets.zero
          : const EdgeInsets.all(2),
      child: TextButton(
        onPressed: () {
          mapBloc.add(
            MapShowTripsForCurrentStop(stop),
          );
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              mapBloc.add(MapEnlargeIcon(stop.stopId),);
              return ModalBottomSheetTimeTable(
                mapBloc: mapBloc,
                stop: stop,
              );
            },
          ).whenComplete(() {
            mapBloc..add(const MapCloseStopTimesModalBottomSheet())
            ..add(
                const MapEnlargeIcon(''),);
          });
        },
        child: Image.asset(
          'assets/bus.png',
        ),
      ),
    );
  }
}

/// Class defines modal bottom sheet content of stop marker.
class ModalBottomSheetTimeTable extends StatefulWidget {
  /// Constructor for [ModalBottomSheetTimeTable].
  const ModalBottomSheetTimeTable({required this.mapBloc, required this.stop, super.key});

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  /// [Stop] object, defines current picked stop.
  final Stop stop;

  @override
  State<ModalBottomSheetTimeTable> createState() => _ModalBottomSheetTimeTableState();
}

class _ModalBottomSheetTimeTableState extends State<ModalBottomSheetTimeTable> {
  final TextEditingController _typeAheadController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              widget.stop.name,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    onTapOutside: (event) {
                      focusNode.unfocus();
                    },
                    focusNode: focusNode,
                    controller: _typeAheadController,
                  ),
                  suggestionsCallback: (pattern) async {
                    final matches = <Stop>[...widget.mapBloc.state.currentStops];

                    final startsWithMatches = matches
                        .where((s) => s.name.toLowerCase().startsWith(pattern.toLowerCase()))
                        .toList();

                    final containsMatches = matches
                        .where((s) => s.name.toLowerCase().contains(pattern.toLowerCase()))
                        .toList();

                    startsWithMatches.addAll(containsMatches);
                    return startsWithMatches.toSet().toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    widget.mapBloc.add(MapSearchByTheQuery(suggestion.name));
                    _typeAheadController.text = suggestion.name;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 5),
              child: Chip(
                label: BlocBuilder<MapBloc, MapState>(
                  bloc: widget.mapBloc,
                  builder: (context, state) {
                    return Text(state.filteredByUserTrips.length.toString());
                  },
                ),
              ),
            ),
            BlocBuilder<MapBloc, MapState>(
              bloc: widget.mapBloc,
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.mapBloc.add(
                        const MapPressFilterButton(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.mapBloc.state.showTripsForToday == ShowTripsForToday.today
                              ? Colors.amber
                              : Colors.white,
                    ),
                    child: BlocProvider<MapBloc>.value(
                      value: widget.mapBloc,
                      child: const TextForFilterButton(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        BlocBuilder<MapBloc, MapState>(
          bloc: widget.mapBloc,
          builder: (context, state) {
            switch (state.tripStatus) {
              case TripStatus.initial:
                return const Center(child: CircularProgressIndicator());
              case TripStatus.loading:
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              case TripStatus.success:
                return Expanded(
                  child: ListView.builder(
                    itemCount: widget.mapBloc.state.filteredByUserTrips.length,
                    itemBuilder: (context, index) {
                      //log('shapeId ${state.filteredByUserTrips[index].shapeId} tripId ${state.filteredByUserTrips[index].tripId}');
                      return Card(
                        elevation: 10,
                        color: Colors.white70,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.asset('assets/county_bus.png'),
                          ),
                          title: Center(
                            child: Text(
                              '${state.presentStopStopTimeList[index]!.departureTime.substring(0, state.presentStopStopTimeList[index]!.departureTime.length - 3)}'
                              ' - ${state.presentTripEndStopTimes[index]!.departureTime.substring(0, state.presentTripEndStopTimes[index]!.departureTime.length - 3)}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                'Start Stop: ${state.presentTripStartStopTimes[index]!.stopId} ${state.presentTripStartStop[index]!.name}'
                                ' - ${state.presentTripStartStopTimes[index]!.departureTime.substring(0, state.presentTripStartStopTimes[index]!.departureTime.length - 3)}',
                              ),
                              Text(
                                'End Stop: ${state.presentTripEndStopTimes[index]!.stopId} ${state.presentTripEndStop[index]!.name}'
                                ' - ${state.presentTripEndStopTimes[index]!.departureTime.substring(0, state.presentTripEndStopTimes[index]!.departureTime.length - 3)}',
                              ),
                              Text(state.filteredByUserTrips[index].tripId),
                              Text('${state.presentTripCalendar[index]}'),
                            ],
                          ),
                          trailing: CircleAvatar(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              case TripStatus.failure:
                return const Expanded(child: Text('An error occurred'));
            }
          },
        )
      ],
    );
  }
}
