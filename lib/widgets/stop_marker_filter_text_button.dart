import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/map/bloc/map_bloc.dart';

/// Text for filter button/ This button is used on modal bottom sheet, which
/// opens on public transport stop clicked.
class StopMarkerFilterTextButton extends StatefulWidget {
  /// Constructor for filter button
  const StopMarkerFilterTextButton({super.key});

  @override
  State<StopMarkerFilterTextButton> createState() => _StopMarkerFilterTextButtonState();
}

class _StopMarkerFilterTextButtonState extends State<StopMarkerFilterTextButton> {
  @override
  Widget build(BuildContext context) {
    if (context.select((MapBloc mapBloc) => mapBloc.state.tripStatus) == TripStatus.loading) {
      return const CircularProgressIndicator();
    }
    if (context.select((MapBloc mapBloc) => mapBloc.state.showTripsForToday) ==
        ShowTripsForToday.all) {
      return const Text('all');
    }
    if (context.select((MapBloc mapBloc) => mapBloc.state.showTripsForToday) ==
        ShowTripsForToday.today) {
      return const Text('today');
    }
    return const CircularProgressIndicator();
  }
}
