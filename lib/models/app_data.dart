import 'package:socialmedia/models/comment_model.dart';
import 'package:socialmedia/models/post_model.dart';
import 'package:socialmedia/models/user_model.dart';

class AppData {
  AppData._privateConstructor();

  static final AppData _instance = AppData._privateConstructor();

  factory AppData() {
    return _instance;
  }

  List<PostModel> _posts = [];
  List<CommentModel> _comments = [];
  List<UserModel> _users = [];

  List<PostModel> get posts => _posts;
  set posts(List<PostModel> newPosts) {
    _posts = newPosts;
  }

  List<CommentModel> get comments => _comments;
  set comments(List<CommentModel> newComments) {
    _comments = newComments;
  }

  List<UserModel> get users => _users;
  set users(List<UserModel> newUsers) {
    _users = newUsers;
  }

  void clearData() {
    _posts.clear();
    _comments.clear();
    _users.clear();
  }
}
