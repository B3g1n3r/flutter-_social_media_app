import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/api/api_service.dart';
import 'package:socialmedia/models/post_model.dart';
import 'package:socialmedia/screens/user_profile.dart';

class PostDetailsScreen extends StatelessWidget {
  final int postId;
  final ApiService apiService = ApiService();
  final Rx<PostModel?> post = Rx<PostModel?>(null);
  final RxList<dynamic> comments = <dynamic>[].obs;
  final RxBool isLoading = true.obs;

  PostDetailsScreen({super.key, required this.postId}) {
    fetchPostDetails();
    fetchComments();
  }

  Future<void> fetchPostDetails() async {
    try {
      isLoading(true);
      post.value = await apiService.fetchPostDetails(postId);
    } catch (e) {
      post.value = null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await apiService.fetchComments(postId);
      comments.assignAll(response);
    } catch (e) {
      comments.clear();
    }
  }

  Future<String> getUserName(int userId) async {
    final response = await apiService.fetchUsers(userId);
    return response.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: const Color.fromARGB(255, 95, 154, 255),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (post.value == null) {
            return const Center(child: Text('Error loading post.'));
          }
          final currentPost = post.value!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserProfileScreen(userId: currentPost.userId));
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          FutureBuilder<String>(
                            future: getUserName(currentPost.userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 50),
                          const Icon(Icons.arrow_forward, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPost.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentPost.body,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (comments.isEmpty) {
                    return const Center(child: Text('No comments found.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Container(
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
                          title: Text(
                            '${comments[index]['name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          subtitle: Text(comments[index]['body']),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
