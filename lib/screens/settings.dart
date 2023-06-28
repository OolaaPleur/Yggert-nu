import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/map/view/map_screen.dart';

import '../map/bloc/map_bloc.dart';

/// [Settings] is widget, which is accessed through actions in appbar on
/// [MapScreen]. There user can change global settings of the app.
class Settings extends StatefulWidget {
  /// Default constructor for [Settings] widget.
  const Settings({super.key});


  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    var filter = context.read<MapBloc>().state.globalShowTripsForToday;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.6,
                child: SegmentedButton<GlobalShowTripsForToday>(
                  segments: const <ButtonSegment<GlobalShowTripsForToday>>[
                    ButtonSegment<GlobalShowTripsForToday>(
                      value: GlobalShowTripsForToday.all,
                      label: Text('All'),
                    ),
                    ButtonSegment<GlobalShowTripsForToday>(
                      value: GlobalShowTripsForToday.today,
                      label: Text('Today'),
                    ),
                  ],
                  selected: <GlobalShowTripsForToday>{filter},
                  onSelectionChanged: (Set<GlobalShowTripsForToday> newSelection) {
                    setState(() {
                      filter = newSelection.first;
                      context.read<MapBloc>().add(MapChangeTimetableMode(filter));
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
