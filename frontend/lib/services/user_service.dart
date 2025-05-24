import 'package:ale_okaz/models/data/user.dart';
import 'package:ale_okaz/services/rest_service.dart';

class UserService {
  Future<User> getUserInfo(String userId) async {
    return RestService().sendGETRequest(
        'api/users/info/$userId', (decodedJson) => User.fromJson(decodedJson));
  }
}
