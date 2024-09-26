import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/api/api_service.dart';
import 'package:socialmedia/models/post_model.dart';
import 'package:socialmedia/screens/post_details.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController =
      Get.put(PostController(apiService: ApiService()));

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 154, 255),
        title:
            const Text('Posts', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            final post = postController.posts[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => PostDetailsScreen(postId: post.id));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.article, color: Colors.blueAccent),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward, color: Colors.blueAccent),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Create New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Post Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Post Content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              int nextId = postController.posts.length + 1;

              postController.createNewPost({
                'id': nextId,
                'title': titleController.text,
                'body': bodyController.text,
                'userId': 1,
              });

              Get.back(); // Close the dialog after creating the post
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class PostController extends GetxController {
  var posts = <PostModel>[].obs;
  var isLoading = true.obs;

  final ApiService apiService;

  PostController({required this.apiService});

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void fetchPosts() async {
    try {
      isLoading(true);
      final postList = await apiService.fetchPosts();
      posts.assignAll(postList.map((e) => PostModel.fromJson(e)).toList());
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void createNewPost(Map<String, dynamic> newPost) async {
    try {
      isLoading(true);
      final createdPost = await apiService.createPost(newPost);
      posts.insert(0, PostModel.fromJson(createdPost));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
