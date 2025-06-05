import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/models/data/user.dart';
import 'package:flutter/foundation.dart';
import 'package:ale_okaz/services/user_service.dart';

class CommentsListViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  List<Comment> _comments = [];
  List<Comment> get sortedComments => _sortedComments;
  List<Comment> _sortedComments = [];

  Map<String, User> get usersMap => _usersMap;
  Map<String, User> _usersMap = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CommentsListViewModel(List<Comment> comments) {
    updateComments(comments);
  }

  Future<void> updateComments(List<Comment> comments) async {
    _comments = comments;
    _sortedComments = List.from(_comments)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    await _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ids = _sortedComments.map((c) => c.authorId).toSet();
      final usersList =
          await Future.wait(ids.map((id) => _userService.getUserInfo(id)));
      _usersMap = Map.fromIterables(ids, usersList);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
