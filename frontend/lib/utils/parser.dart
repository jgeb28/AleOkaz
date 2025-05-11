import 'package:ale_okaz/utils/ip.dart';
import 'package:timeago/timeago.dart' as timeago;

class Parser {
  String getImageUrl(String imageUrl) {
    List<String> splittedImageUrl = imageUrl.split('/');
    return '$ip/${splittedImageUrl[splittedImageUrl.length - 2]}/${splittedImageUrl[splittedImageUrl.length - 1]}';
  }

  String getDateInPL(DateTime datetime) {
    final DateTime createdAt = datetime;
    final full = timeago.format(createdAt, locale: 'pl');

    return full;
  }
}
