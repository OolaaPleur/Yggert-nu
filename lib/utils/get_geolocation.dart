import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/map_marker.dart';

class GetGeolocation {

  List<MapMarker> deleteUserMarkerIfAlreadyInMarkers(List<MapMarker> markers) {

    var itemsToRemove = [];
    for (final marker in markers) {
      if (marker.markerType == MarkerType.person) {
        itemsToRemove.add(marker);
      }
    }

    for (var item in itemsToRemove) {
      markers.remove(item);
    }
    return markers;
}
  Future<LatLng?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      LatLng latLng = LatLng(position.latitude, position.longitude);
      return latLng;
    }
    else if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Handle the case where the user denies the permission
      return null;
    }
    return null;
  }
}