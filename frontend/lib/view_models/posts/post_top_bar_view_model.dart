import 'package:get/get.dart';
import 'package:ale_okaz/models/data/user.dart';
import 'package:ale_okaz/services/user_service.dart';

class PostTopBarViewModel extends GetxController {
  final String userId;
  final UserService _service = UserService();

  /// Reactive state
  final user = Rxn<User>();
  final isLoading = true.obs;
  final error = RxnString();

  PostTopBarViewModel(this.userId);

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      isLoading.value = true;
      error.value = null;
      final fetched = await _service.getUserInfo(userId);
      user.value = fetched;
    } catch (e) {
      print(e);
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
