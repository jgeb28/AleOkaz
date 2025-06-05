import 'dart:async';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapViewModel extends GetxController {
  var currentPosition = const LatLng(52.4517, 21.0419).obs;
  late GoogleMapController googleMapController;
  final markers = <Marker>{}.obs;
  StreamSubscription<Position>? positionStream;
  final _restService = RestService();
  final fishingSpots = <Map<String, dynamic>>[].obs;

  // Custom marker icons
  BitmapDescriptor? currentLocationIcon;
  BitmapDescriptor? fishingSpotIcon;

  @override
  void onInit() {
    super.onInit();
    _createMarkerIcons();
    _getCurrentLocation();
    fetchFishingSpots();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  // Create custom marker icons
  Future<void> _createMarkerIcons() async {
    currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/current_location.png', // Your custom icon
    );

    fishingSpotIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/fishing_spot.png', // Your custom icon
    );
  }

  void addMarker(LatLng position,
      {String? id, String title = 'Your Location'}) {
    markers.add(Marker(
      markerId: MarkerId(id ?? position.toString()),
      position: position,
      icon: currentLocationIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: title),
    ));
  }

  // Add fishing spot markers
  void addFishingSpotMarkers() {
    for (final spot in fishingSpots) {
      final lat = spot['latitude'] as double?;
      final lng = spot['longitude'] as double?;
      final name = spot['name'] as String? ?? 'Fishing Spot';

      if (lat == null || lng == null) continue;
      markers.add(Marker(
        markerId: MarkerId('fishing-spot-${spot['id']}'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: name),
        onTap: () => _onFishingSpotTap(spot),
      ));
    }
  }

  void _onFishingSpotTap(Map<String, dynamic> spot) {
    // Handle spot tap (show details, navigate, etc.)
    Get.snackbar('Fishing Spot', spot['name']?.toString() ?? 'Fishing Spot');
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _updatePosition(LatLng(position.latitude, position.longitude));

      positionStream = Geolocator.getPositionStream().listen((position) {
        if (position != null) {
          _updatePosition(LatLng(position.latitude, position.longitude));
        }
      });
    } catch (e) {
      print("Location error: $e");
    }
  }

  void _updatePosition(LatLng newPosition) {
    currentPosition.value = newPosition;
    markers.removeWhere((m) => m.markerId.value == 'current-location');
    addMarker(newPosition, id: 'current-location', title: 'Your Location');
    googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  void moveToPosition(LatLng newPosition) {
    currentPosition.value = newPosition;
    googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  Future<void> fetchFishingSpots() async {
    try {
      final spots =
          await _restService.sendGETRequest<List<Map<String, dynamic>>>(
        'api/fishingspots/all',
        (json) {
          if (json is List) {
            return json.cast<Map<String, dynamic>>();
          } else {
            throw Exception("Invalid response format");
          }
        },
      );

      fishingSpots.assignAll(spots);
      addFishingSpotMarkers(); // Add markers after fetching
    } catch (e) {
      print("Error fetching fishing spots: $e");
    }
  }
}
