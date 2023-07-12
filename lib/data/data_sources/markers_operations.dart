import '../../screens/map/markers/map_marker.dart';

/// Class which defines operations with markers.
class MarkersOperations {
  /// Filters [allMarkers] so that only Stop markers left.
  List<MapMarker> getOnlyStopsMarkers (List<MapMarker> allMarkers) {
    final itemsToRemove = <MapMarker>[];
    final stateMarkers = allMarkers;
    for (final marker in stateMarkers) {
      if (marker.markerType != MarkerType.stop) {
        itemsToRemove.add(marker);
      }
    }
    for (final item in itemsToRemove) {
      stateMarkers.remove(item);
    }
    return stateMarkers;
  }
}
