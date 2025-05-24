import 'package:ale_okaz/consts/flutter_api_consts.dart';
import 'package:timeago/timeago.dart' as timeago;

class Parser {
  String getImageUrl(String imageUrl) {
    List<String> splittedImageUrl = imageUrl.split('/');
    print(imageUrl);
    return '${FlutterApiConsts.baseUrl}/${splittedImageUrl[splittedImageUrl.length - 2]}/${splittedImageUrl[splittedImageUrl.length - 1]}';
  }

  String getDateInPL(DateTime datetime) {
    final DateTime createdAt = datetime;
    final full = timeago.format(createdAt, locale: 'pl');

    return full;
  }
}
