import 'package:flutter/material.dart';
import 'package:socialmedia/api/api_service.dart';
import 'package:socialmedia/models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;
  final ApiService apiService = ApiService();

  UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: const Color.fromARGB(255, 95, 154, 255),
      ),
      body: FutureBuilder<UserModel>(
        future: apiService.fetchUsers(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry logic can be added here if needed
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade50,
                      Colors.white,
                    ],
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 8),
                      UserInfoRow(icon: Icons.account_circle, text: user.username),
                      UserInfoRow(icon: Icons.email, text: user.email),
                      UserInfoRow(icon: Icons.phone, text: user.phone),
                      UserInfoRow(icon: Icons.web, text: user.website ?? "N/A"),
                      const SizedBox(height: 16),
                      const Divider(thickness: 2, height: 20),
                      const Text(
                        'Address:',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${user.street}, ${user.suite ?? "N/A"}, ${user.city}, ${user.zipcode}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Geo Location:',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latitude: ${user.lat}, Longitude: ${user.lng}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Divider(thickness: 2, height: 20),
                      const Text(
                        'Company:',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Name: ${user.companyName}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Catchphrase: ${user.companyCatchPhrase}',
                        style: const TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Business: ${user.companyBs}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const UserInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
