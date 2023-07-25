import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/car/car.dart';
import '../../../map/bloc/map_bloc.dart';
import '../modal_bottom_sheets/modal_bottom_sheet_car_info.dart';

/// Widget, which defines how car marker(or more precisely speaking - child of
/// marker) would look like.
class CarMarker extends StatelessWidget {
  /// Constructor of [CarMarker].
  const CarMarker({
    required this.car,
    required this.mapBloc,
    required this.carImagePath,
    super.key,
  });

  /// [Car] object, defines car.
  final Car car;

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  /// Image path for current scooter.
  final String carImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.select(
        (MapBloc bloc) => bloc.state.keyFromOpenedMarker == car.id,
      )
          ? EdgeInsets.zero
          : const EdgeInsets.all(2),
      child: TextButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              mapBloc.add(MapEnlargeIcon(car.id));
              return ModalBottomSheetCarInfo(car: car, mapBloc: mapBloc);
            },
          ).whenComplete(
            () => mapBloc.add(
              const MapEnlargeIcon(''),
            ),
          );
        },
        child: Image.asset(carImagePath),
      ),
    );
  }
}
