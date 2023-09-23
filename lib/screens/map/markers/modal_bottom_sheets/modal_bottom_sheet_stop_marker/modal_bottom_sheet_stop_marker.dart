import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:yggert_nu/screens/map/markers/modal_bottom_sheets/modal_bottom_sheet_stop_marker/pick_appropriate_circle_avatar.dart';

import '../../../../../data/models/estonia_public_transport.dart';
import '../../../bloc/map_bloc.dart';
import 'stop_marker_filter_text_button.dart';

/// Class defines modal bottom sheet content of stop marker.
class ModalBottomSheetTimeTable extends StatefulWidget {
  /// Constructor for [ModalBottomSheetTimeTable].
  const ModalBottomSheetTimeTable({required this.mapBloc, required this.stop, super.key});

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  /// [Stop] object, defines current picked stop.
  final Stop stop;

  @override
  State<ModalBottomSheetTimeTable> createState() => _ModalBottomSheetTimeTableState();
}

class _ModalBottomSheetTimeTableState extends State<ModalBottomSheetTimeTable> {
  final TextEditingController _typeAheadController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              widget.stop.name,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration:
                        InputDecoration(hintText: AppLocalizations.of(context)!.stopSearchHintText),
                    onTapOutside: (event) {
                      focusNode.unfocus();
                    },
                    focusNode: focusNode,
                    controller: _typeAheadController,
                  ),
                  suggestionsCallback: (pattern) async {
                    //final matches = <Stop>[...widget.mapBloc.state.presentStopsInForwardDirection];
                    final matches = <Stop>[...widget.mapBloc.state.currentStops];

                    final startsWithMatches = matches
                        .where((s) => s.name.toLowerCase().startsWith(pattern.toLowerCase()))
                        .toList();

                    final containsMatches = matches
                        .where((s) => s.name.toLowerCase().contains(pattern.toLowerCase()))
                        .toList();

                    startsWithMatches.addAll(containsMatches);
                    return startsWithMatches.toSet().toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    widget.mapBloc.add(MapSearchByTheQuery(suggestion.name));
                    _typeAheadController.text = suggestion.name;
                  },
                ),
              ),
            ),
            BlocBuilder<MapBloc, MapState>(
              bloc: widget.mapBloc,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: state.tripStatus == TripStatus.loading
                          ? null
                          : () {
                              widget.mapBloc.add(
                                const MapPressFilterButton(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.mapBloc.state.showTripsForToday == ShowTripsForToday.today
                                ? Colors.amber
                                : null,
                      ),
                      child: BlocProvider<MapBloc>.value(
                        value: widget.mapBloc,
                        child: const StopMarkerFilterTextButton(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        BlocBuilder<MapBloc, MapState>(
          buildWhen: (previous, current) {
            return previous.directionChars != current.directionChars ||
                previous.tripStatus != current.tripStatus;
          },
          bloc: widget.mapBloc,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (kDebugMode)
                  Chip(
                    label: BlocBuilder<MapBloc, MapState>(
                      bloc: widget.mapBloc,
                      builder: (context, state) {
                        return state.tripStatus == TripStatus.loading
                            ? const Text('  ')
                            : Text(state.filteredByUserTrips.length.toString());
                      },
                    ),
                  )
                else
                  const SizedBox.shrink(),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.directionChars.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: IconButton.outlined(
                          onPressed: widget.mapBloc.state.tripStatus == TripStatus.loading
                              ? null
                              : () {
                                  widget.mapBloc.add(
                                    MapPressFilterByDirectionButton(
                                      state.directionChars[index].keys.first,
                                    ),
                                  );
                                },
                          icon: Text(
                            state.directionChars[index].keys.first,
                            style: const TextStyle(fontSize: 20),
                          ),
                          visualDensity: VisualDensity.comfortable,
                          style: IconButton.styleFrom(
                            backgroundColor: state.directionChars[index].values.first
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        BlocBuilder<MapBloc, MapState>(
          bloc: widget.mapBloc,
          builder: (context, state) {
            switch (state.tripStatus) {
              case TripStatus.initial:
                return const SizedBox.shrink();
              case TripStatus.loading:
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              case TripStatus.success:
                return Expanded(
                  child: ListView.builder(
                    itemCount: widget.mapBloc.state.filteredByUserTrips.length,
                    itemBuilder: (context, upIndex) {
                      //log('shapeId ${state.filteredByUserTrips[index].shapeId} tripId ${state.filteredByUserTrips[index].tripId}');
                      return state.presentRoutes[upIndex] == null
                          ? const SizedBox.shrink()
                          : Card(
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Color(
                                        int.parse(
                                          'FF${state.presentRoutes[upIndex]!.routeColor.replaceFirst('#', '')}',
                                          radix: 16,
                                        ),
                                      ),
                                      width: 8,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: PickAppropriateCircleAvatar(
                                    routeType: state.presentRoutes[upIndex]!.routeType,
                                  ),
                                  title: Center(
                                    child: Text(
                                      '${state.presentStopStopTimeList[upIndex]!.departureTime}'
                                      ' - ${state.presentTripEndStopTimes[upIndex]!.departureTime}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                        '${state.presentTripStartStopTimes[upIndex]!.departureTime} - ${state.presentTripStartStop[upIndex]!.name}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${state.presentTripEndStopTimes[upIndex]!.departureTime} - ${state.presentTripEndStop[upIndex]!.name}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(localizeDays(context, state.presentTripCalendar[upIndex]!)),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.mapBloc.add(MapPressTheTripButton(upIndex));
                                          });
                                        },
                                        child: Text(AppLocalizations.of(context)!
                                            .stopMarkerShowAllForwardStoptimesButton,textAlign: TextAlign.center,),
                                      ),
                                      if (state.pressedButtonOnTrip[upIndex])
                                        ColoredBox(
                                          color: Colors.white70,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(maxHeight: 200),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: state
                                                    .presentStopStopTimeListOnlyFilter[upIndex]!
                                                    .map((stopTime) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Text('${stopTime.departureTime}'
                                                            ' - ${state.presentStopListOnlyFilter[upIndex]![state.presentStopStopTimeListOnlyFilter[upIndex]!.indexOf(stopTime)].name}'),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        const SizedBox.shrink(),
                                    ],
                                  ),
                                  trailing: kDebugMode
                                      ? CircleAvatar(
                                          child: Text(
                                            '${upIndex + 1}',
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            );
                    },
                  ),
                );
            }
          },
        ),
      ],
    );
  }
  String localizeDays(BuildContext context, String days) {
    // Split the input string by comma and space
    final dayList = days.split(', ');

    // Replace each day with its translation
    final localizedDays = dayList.map((day) {
      switch (day) {
        case 'Mon': return AppLocalizations.of(context)!.mon;
        case 'Tue': return AppLocalizations.of(context)!.tue;
        case 'Wed': return AppLocalizations.of(context)!.wed;
        case 'Thu': return AppLocalizations.of(context)!.thu;
        case 'Fri': return AppLocalizations.of(context)!.fri;
        case 'Sat': return AppLocalizations.of(context)!.sat;
        case 'Sun': return AppLocalizations.of(context)!.sun;
        default: throw ArgumentError('Unsupported day: $day');
      }
    }).toList();

    // Join the translated days back into a string
    return localizedDays.join(', ');
  }
}
