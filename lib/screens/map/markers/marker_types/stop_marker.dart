import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/estonia_public_transport.dart';
import '../../../map/bloc/map_bloc.dart';
import '../modal_bottom_sheets/modal_bottom_sheet_stop_marker.dart';

/// Widget, which defines how stop marker(or more precisely speaking - child of
/// marker) would look like.
class StopMarker extends StatelessWidget {
  /// Constructor of [StopMarker].
  const StopMarker({required this.mapBloc, required this.stop, super.key});

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  /// [Stop] object, defines stop.
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
            //isScrollControlled: true,
            context: context,
            builder: (context) {
              mapBloc.add(
                MapEnlargeIcon(stop.stopId),
              );
              return ModalBottomSheetTimeTable(
                mapBloc: mapBloc,
                stop: stop,
              );
            },
          ).whenComplete(() {
            mapBloc
              ..add(const MapCloseStopTimesModalBottomSheet())
              ..add(
                const MapEnlargeIcon(''),
              );
          });
        },
        child: Image.asset(
          'assets/bus.png',
        ),
      ),
    );
  }
}
