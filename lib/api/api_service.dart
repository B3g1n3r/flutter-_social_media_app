import 'package:dio/dio.dart';
import 'package:socialmedia/models/post_model.dart';
import 'package:socialmedia/models/user_model.dart';

class ApiService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await _dio.get('/posts');
      return response.data;
    } on DioException catch (e) {
      print(e);
    }
    return [];
  }

  Future<PostModel> fetchPostDetails(int postId) async {
    final response = await ApiService().fetchPosts();
    return PostModel.fromJson(
        response.firstWhere((post) => post['id'] == postId));
  }

  Future<List<dynamic>> fetchComments(int postId) async {
    try {
      final response = await _dio.get('/comments?postId=$postId');
      return response.data;
    } on DioException catch (e) {
      print(e);
    }
    return [];
  }

  Future<UserModel> fetchUsers(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw Exception('Failed to load user details');
    }
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> newPost) async {
    final response = await _dio.post('/posts', data: newPost);
    print('Create post response: $response');
    return response.data;
  }
}

