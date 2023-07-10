import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/tartu_bike_station.dart';
import '../../../map/bloc/map_bloc.dart';
import '../modal_bottom_sheets/modal_bottom_sheet_bike_station_info.dart';

/// Widget, which defines how bike marker(or more precisely speaking - child of
/// marker) would look like.
class BikeMarker extends StatelessWidget {
  /// Constructor of [BikeMarker].
  const BikeMarker({
    required this.bikeStation,
    required this.mapBloc,
    super.key,
  });

  /// [TartuBikeStations] object, defines bike station.
  final TartuBikeStations bikeStation;

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            mapBloc
              ..add(MapEnlargeIcon(bikeStation.id))
              ..add(MapGetSingleBikeStationInfo(bikeStation.id));
            return BlocBuilder<MapBloc, MapState>(
              bloc: mapBloc,
              builder: (context, state) {
                return state.singleBikeStation.isNotEmpty
                    ? ModalBottomSheetBikeStationInfo(
                        singleBikeStation: state.singleBikeStation.last,
                      )
                    : const SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),);
              },
            );
          },
        ).whenComplete(() {
          mapBloc
            ..add(
              const MapEnlargeIcon(''),
            )
            ..add(const MapDeleteSingleBikeStationInfo());
        });
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
    );
  }
}
