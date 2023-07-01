import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/bolt_scooter/bolt_scooter.dart';
import '../../map/bloc/map_bloc.dart';
import 'modal_bottom_sheets/modal_bottom_sheet_scooter_info.dart';

class ScooterMarker extends StatelessWidget {
  const ScooterMarker({
    required this.scooter, required this.mapBloc, super.key,
  });

  final BoltScooter scooter;
  final MapBloc mapBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
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
    );
  }
}
