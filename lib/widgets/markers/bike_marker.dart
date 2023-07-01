import 'package:flutter/material.dart';

import '../../domain/tartu_bike_station/tartu_bike_station.dart';
import '../../domain/vehicle_repository.dart';
import '../../map/bloc/map_bloc.dart';
import 'modal_bottom_sheets/modal_bottom_sheet_bike_station_info.dart';

class BikeMarker extends StatelessWidget {
  const BikeMarker({
    required this.vehicleRepository, required this.bikeStation, required this.mapBloc, super.key,
  });

  final VehicleRepository vehicleRepository;
  final TartuBikeStations bikeStation;
  final MapBloc mapBloc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
                      child: Text(asyncSnapshot.error.toString().substring(11), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18),),
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
    );
  }

}
