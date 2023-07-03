import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../domain/estonia_public_transport/estonia_public_transport.dart';
import '../../../map/bloc/map_bloc.dart';
import '../../stop_marker_filter_text_button.dart';

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
                padding: const EdgeInsets.only(left: 30),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    onTapOutside: (event) {
                      focusNode.unfocus();
                    },
                    focusNode: focusNode,
                    controller: _typeAheadController,
                  ),
                  suggestionsCallback: (pattern) async {
                    final matches = <Stop>[...widget.mapBloc.state.presentStopsInForwardDirection];

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
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 5),
              child: Chip(
                label: BlocBuilder<MapBloc, MapState>(
                  bloc: widget.mapBloc,
                  builder: (context, state) {
                    return state.tripStatus == TripStatus.loading
                        ? const Text('  ')
                        : Text(state.filteredByUserTrips.length.toString());
                  },
                ),
              ),
            ),
            Column(
              children: [
                BlocBuilder<MapBloc, MapState>(
                  bloc: widget.mapBloc,
                  builder: (context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
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
                    );
                  },
                ),
              ],
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
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.directionChars.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: BlocBuilder<MapBloc, MapState>(
                              bloc: widget.mapBloc,
                              builder: (context, state) {
                                return IconButton.outlined(
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
                                    backgroundColor: backgroundColorForDirectionButton(
                                      widget.mapBloc,
                                      index,
                                    ),
                                    disabledBackgroundColor: backgroundColorForDirectionButton(
                                      widget.mapBloc,
                                      index,
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
                                  leading: pickAppropriateCircleAvatar(
                                    state.presentRoutes[upIndex]!.routeType,
                                  ),
                                  title: Center(
                                    child: Text(
                                      '${state.presentStopStopTimeList[upIndex]!.departureTime.substring(0, state.presentStopStopTimeList[upIndex]!.departureTime.length - 3)}'
                                      ' - ${state.presentTripEndStopTimes[upIndex]!.departureTime.substring(0, state.presentTripEndStopTimes[upIndex]!.departureTime.length - 3)}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                        'Start Stop: ${state.presentTripStartStopTimes[upIndex]!.stopId} ${state.presentTripStartStop[upIndex]!.name}'
                                        ' - ${state.presentTripStartStopTimes[upIndex]!.departureTime.substring(0, state.presentTripStartStopTimes[upIndex]!.departureTime.length - 3)}',
                                      ),
                                      Text(
                                        'End Stop: ${state.presentTripEndStopTimes[upIndex]!.stopId} ${state.presentTripEndStop[upIndex]!.name}'
                                        ' - ${state.presentTripEndStopTimes[upIndex]!.departureTime.substring(0, state.presentTripEndStopTimes[upIndex]!.departureTime.length - 3)}',
                                      ),
                                      Text(state.presentRoutes[upIndex]!.routeColor),
                                      Text(state.filteredByUserTrips[upIndex].tripId),
                                      Text('${state.presentTripCalendar[upIndex]}'),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.mapBloc.add(MapPressTheTripButton(upIndex));
                                          });
                                        },
                                        child: const Text('Press to see stoptimes'),
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
                                                        child: Text(
                                                            '${stopTime.departureTime.substring(0, stopTime.departureTime.length - 3)}'
                                                            '- ${state.presentStopListOnlyFilter[upIndex]![state.presentStopStopTimeListOnlyFilter[upIndex]!.indexOf(stopTime)].name}'),
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
                                  trailing: CircleAvatar(
                                    child: Text(
                                      '${upIndex + 1}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                );
            }
          },
        )
      ],
    );
  }

  CircleAvatar pickAppropriateCircleAvatar(int routeType) {
    if (routeType == 0) {
      return CircleAvatar(
        child: Image.asset('assets/public_transport/tram.png'),
      );
    } else if (routeType == 2) {
      return CircleAvatar(
        child: Image.asset('assets/public_transport/train.png'),
      );
    } else if (routeType == 3) {
      return CircleAvatar(
        child: Image.asset('assets/public_transport/county_bus.png'),
      );
    } else if (routeType == 4) {
      return CircleAvatar(
        child: Image.asset('assets/public_transport/ferry.png'),
      );
    } else if (routeType == 800) {
      return CircleAvatar(
        child: Image.asset('assets/public_transport/trolleybus.png'),
      );
    }
    return CircleAvatar(
      child: Image.asset('assets/county_bus.png'),
    );
  }

  Color? backgroundColorForDirectionButton(MapBloc mapBloc, int index) {
    if (mapBloc.state.directionChars[index].values.first) {
      return Theme.of(context).primaryColor;
    }
    return null;
  }
}
