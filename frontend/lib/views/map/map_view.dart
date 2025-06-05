import 'package:ale_okaz/view_models/map/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapViewModel viewModel = Get.put(MapViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Obx(() => GoogleMap(
              onMapCreated: viewModel.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: viewModel.currentPosition.value,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(viewModel.markers),
            )),
        Obx(() {
          final spot = viewModel.selectedFishingSpot.value;
          if (spot == null) return SizedBox.shrink();

          return Positioned(
            top: 60,
            left: 20,
            right: 20,
            height: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot['name'] ?? 'Fishing Spot',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${spot['latitude']?.toStringAsFixed(5) ?? 'N/A'}, '
                    ' ${spot['longitude']?.toStringAsFixed(5) ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Colors.green, // or your `buttonBackgroundColor`
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Get.toNamed('/home/${spot['id']}');
                      },
                      child: const Text(
                        'Przejdź do postów',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ]),
    );
  }
}
