import 'package:ale_okaz/services/rest_service.dart';
import 'package:get/get.dart';

class FishingSpotsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  var currentSortOption = 'alphabetical'.obs;
  final fishingSpots = <Map<String, dynamic>>[].obs;


   Map<String, String> sortOptions = {
    'default': 'Domyślnie',
    'alphabetical': 'Alfabetycznie'
  };

  Future<void> fetchFishingSpots() async {
    try {
      final spots =
          await _restService.sendGETRequest<List<Map<String, dynamic>>>(
        'api/fishingspots/postedIn',
        (json) {
          if (json is List) {
            return json.cast<Map<String, dynamic>>();
          } else {
            throw Exception("Invalid response format");
          }
        },
      );
      fishingSpots.assignAll(spots);
    } catch (e) {
      print("Error fetching fishing spots: $e");
    }
  }

}