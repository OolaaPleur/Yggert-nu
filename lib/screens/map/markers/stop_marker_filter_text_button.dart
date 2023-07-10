import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/map_bloc.dart';

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
      return Text(AppLocalizations.of(context)!.settingsLocalFilterAll);
    }
    if (context.select((MapBloc mapBloc) => mapBloc.state.showTripsForToday) ==
        ShowTripsForToday.today) {
      return Text(AppLocalizations.of(context)!.settingsLocalFilterToday);
    }
    return const CircularProgressIndicator();
  }
}
