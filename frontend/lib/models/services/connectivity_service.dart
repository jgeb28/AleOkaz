import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(netStatus);
  }

  Future<void> _checkInitialConnection() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    netStatus(result);
  }

  void netStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      // Navigate to NoConnectionPage
      Get.offAllNamed('/no-connection');
    } else {
      // If already on NoConnectionPage, go back to HomeScreen
      if (Get.currentRoute == '/no-connection') {
        Get.offAllNamed('/');
      }
    }
  }
}