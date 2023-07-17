import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/scooter/scooter.dart';
import '../../../map/bloc/map_bloc.dart';
import '../modal_bottom_sheets/modal_bottom_sheet_scooter_info.dart';

/// Widget, which defines how scooter marker(or more precisely speaking - child of
/// marker) would look like.
class ScooterMarker extends StatelessWidget {
  /// Constructor of [ScooterMarker].
  const ScooterMarker({
    required this.scooter,
    required this.mapBloc,
    required this.scooterImagePath,
    super.key,
  });

  /// [Scooter] object, defines scooter.
  final Scooter scooter;

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;
  /// Image path for current scooter.
  final String scooterImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.select(
        (MapBloc bloc) => bloc.state.keyFromOpenedMarker == scooter.id,
      )
          ? EdgeInsets.zero
          : const EdgeInsets.all(2),
      child: TextButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              mapBloc.add(MapEnlargeIcon(scooter.id));
              return ModalBottomSheetScooterInfo(scooter: scooter, mapBloc: mapBloc);
            },
          ).whenComplete(
            () => mapBloc.add(
              const MapEnlargeIcon(''),
            ),
          );
        },
        child: scooter.charge > 30
            ? Image.asset(scooterImagePath)
            : Image.asset(
                'assets/scooter_low_battery.png',
              ),
      ),
    );
  }
}
