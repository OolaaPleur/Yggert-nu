import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../map/bloc/map_bloc.dart';

/// Widget, that defines how bus icon in FAB should look like.
class BusIcon extends StatelessWidget {
  /// Constructor for Bus.
  const BusIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (context.select(
          (MapBloc bloc) => bloc.state.tripStatus == TripStatus.loading,
    ) ||
        context.select(
              (MapBloc bloc) => bloc.state.status == MapStateStatus.loading,
        ) ||
        context.select(
              (MapBloc bloc) => bloc.state.filteringStatus == true,
        )) {
      return const CircularProgressIndicator(color: Colors.white,);
    }

    if (context.select(
          (MapBloc bloc) =>
      bloc.state.publicTransportStopAdditionStatus == PublicTransportStopAdditionStatus.loading,
    )) {
      return const CircularProgressIndicator(color: Colors.white,
      );
    }
    return const Icon(Icons.directions_bus_sharp);
  }
}
