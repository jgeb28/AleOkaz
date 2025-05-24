import 'package:get/get.dart';

class CommentsCountController extends GetxController {
  var count = 0.obs;

  void initCount(int initial) => count = initial.obs;

  void increment() => count++;

  void updateCommentCounts(int newCount) => count = newCount.obs;
}
