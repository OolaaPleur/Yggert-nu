import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport.dart';
import 'package:mobility_app/map/bloc/map_bloc.dart';
import '../domain/bolt_scooter/bolt_scooter.dart';
import '../domain/tartu_bike_station/tartu_bike_station.dart';
import '../domain/vehicle_repository.dart';
import 'modal_bottom_sheet_bike_station_info.dart';
import 'modal_bottom_sheet_scooter_info.dart';

enum MarkerType { busStop, scooter, bike, none }

class MapMarker extends Marker {
  final MarkerType markerType;

  MapMarker({
    required this.markerType,
    width,
    height,
    point,
    builder,
    key,
  }) : super(
          width: width ?? 0,
          height: height ?? 0,
          point: point ?? LatLng(0, 0),
          builder: builder ?? (_) => Container(),
          key: key ?? const Key('no_key_from_server'),
        );

  MapMarker copyWith({
    MarkerType? markerType,
  }) {
    return MapMarker(
      markerType: markerType ?? this.markerType,
    );
  }
}

class CreateMapMarkerList {
  MapMarker mapMarker = MapMarker(markerType: MarkerType.none);

  MapMarker mapMarkerMakeMarkers(dynamic vehicle, MapBloc mapBloc) {
    switch (vehicle.runtimeType) {
      case TartuBikeStations:
        {
          VehicleRepository tartuBikeStationRepository = VehicleRepository();
          mapMarker = mapMarker.copyWith(markerType: MarkerType.bike);
          mapMarker = MapMarker(
            markerType: MarkerType.bike,
            key: Key(vehicle.id.toString()),
            height: 65.0,
            width: 65.0,
            builder: (context) => TextButton(
              onPressed: () async {
                VehicleRepository bikeInfo = tartuBikeStationRepository;

                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<SingleBikeStation>(
                          future: bikeInfo.getBikeInfo(vehicle.id),
                          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return Container(
                                color: Colors.red,
                                // Display an error message with red background
                                height: 100,
                                width: double.infinity,
                                child: Center(child: Text('Error: ${asyncSnapshot.error}')),
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
                              return ModalBottomSheetBikeStationInfo(singleBikeStationState: asyncSnapshot.data);
                            }
                            return const SizedBox();
                          });
                    });
              },
              child: Center(
                child: Stack(
                  children: [
                    Image.asset('assets/bicycle.png', height: 60, width: 60),
                    Center(
                      child: Text(
                        vehicle.totalLockedCycleCount.toString(),
                        style: const TextStyle(fontSize: 22, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            point: LatLng(vehicle.latitude, vehicle.longitude),
          );
        }
      case BoltScooter:
        {
          mapMarker = mapMarker.copyWith(markerType: MarkerType.scooter);
          mapMarker = MapMarker(
            markerType: MarkerType.scooter,
            key: Key(vehicle.id.toString()),
            height: 65.0,
            width: 65.0,
            builder: (context) => Stack(
              children: [
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalBottomSheetScooterInfo(boltScooter: vehicle);
                          }).whenComplete(() {});
                    },
                    child: vehicle.charge > 30
                        ? Image.asset(
                            'assets/scooter.png',
                          )
                        : Image.asset(
                            'assets/scooter_low_battery.png',
                          )),
              ],
            ),
            point: LatLng(vehicle.latitude, vehicle.longitude),
          );
        }
      case Stop:
        {
          mapMarker = mapMarker.copyWith(markerType: MarkerType.busStop);
          mapMarker = MapMarker(
            markerType: MarkerType.busStop,
            key: Key(vehicle.stopId.toString()),
            height: 55.0,
            width: 55.0,
            builder: (context) => Stack(
              children: [
                TextButton(
                    onPressed: () {
                      mapBloc.add(
                        MapGetTripsForStopTimesForOneStop('', vehicle),
                      );
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalBottomSheetTimeTable(
                              mapBloc: mapBloc,
                              vehicle: vehicle,
                            );
                          }).whenComplete(() => mapBloc.add(const MapCloseStopTimesModalBottomSheet()));
                    },
                    child: Image.asset(
                      'assets/bus.png',
                    ))
              ],
            ),
            point: LatLng(vehicle.latitude, vehicle.longitude),
          );
        }
    }
    return mapMarker;
  }
}

class ModalBottomSheetTimeTable extends StatelessWidget {
  final MapBloc mapBloc;
  final Stop vehicle;

  const ModalBottomSheetTimeTable({super.key, required this.mapBloc, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            vehicle.name,
            style: TextStyle(fontSize: 25),
          ),
        )),
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: TextField(
                      onSubmitted: (value) {
                        mapBloc.add(MapGetTripsForStopTimesForOneStop(value, vehicle));
                      },
                    ))),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 5),
              child: Chip(
                label: BlocBuilder<MapBloc, MapState>(
                  bloc: mapBloc,
                  builder: (context, state) {
                    return Text(state.filteredByUserTrips.length.toString());
                  },
                ),
              ),
            ),
            BlocBuilder<MapBloc, MapState>(
                bloc: mapBloc,
                builder: (context, state) {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          mapBloc.add(
                            const MapShowTripsForToday(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mapBloc.state.showTripsForToday == ShowTripsForToday.success
                                ? Colors.amber
                                : Colors.white),
                        child: changeShowTripsForTodayButtonText(state),
                      ));
                }),
          ],
        ),
        BlocBuilder<MapBloc, MapState>(
            bloc: mapBloc,
            builder: (context, state) {
              if (state.tripStatus == TripStatus.initial) {
                print('stadia');
                return const Center(child: CircularProgressIndicator());
              } else if (state.tripStatus == TripStatus.loading) {
                print('stadia');
                return const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CircularProgressIndicator(),
                );
              } else if (state.tripStatus == TripStatus.success) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: mapBloc.state.filteredByUserTrips.length,
                      itemBuilder: (context, index) {
                        print(state.filteredByUserTrips[index].tripId);
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
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                    'Start Stop: ${state.presentTripStartStopTimes[index]!.stopId} ${state.presentTripStartStop[index]!.name}'
                                    ' - ${state.presentTripStartStopTimes[index]!.departureTime.substring(0, state.presentTripStartStopTimes[index]!.departureTime.length - 3)}'),
                                Text(
                                    'End Stop: ${state.presentTripEndStopTimes[index]!.stopId} ${state.presentTripEndStop[index]!.name}'
                                    ' - ${state.presentTripEndStopTimes[index]!.departureTime.substring(0, state.presentTripEndStopTimes[index]!.departureTime.length - 3)}'),
                                Text(state.filteredByUserTrips[index].tripId)
                                ,Text('${state.presentTripCalendar[index]}'),
                              ],
                            ),
                            trailing: CircleAvatar(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
              ;
              return SizedBox();
            }),
      ],
    );
  }

  Widget changeShowTripsForTodayButtonText (MapState state) {
    if (state.showTripsForToday == ShowTripsForToday.loadingForAllWeekdays ||
        state.showTripsForToday == ShowTripsForToday.loadingForToday) {
    }
    if (state.showTripsForToday == ShowTripsForToday.initial) {
      return const Text('all');
    }
    if (state.showTripsForToday == ShowTripsForToday.success) {
      return const Text('today');
    }
    return const SizedBox();
  }
}
