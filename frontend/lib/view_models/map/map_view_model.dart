import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends GetxController {
  var currentPosition = const LatLng(52.4517, 21.0419).obs; // Default position

  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;

  void addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(125), 
      infoWindow: const InfoWindow(title: 'Pinned Location'),
    );
    markers.clear(); 
    markers.add(marker);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    addMarker(currentPosition.value);
  }

  void moveToPosition(LatLng newPosition) {
    currentPosition.value = newPosition;
    googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));

  }
}
