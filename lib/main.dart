// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:capstone_app/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const AutoLinkApp());
}

class AutoLinkApp extends StatelessWidget {
  const AutoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLink - Automotive Services',
      theme: ThemeData(
        primaryColor: const Color(0xFFF27A21),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: const AutoLinkHomePage(),
      routes: {
        '/login': (context) => const LoginPage(), // Add route for login
      },
    );
  }
}

class SessionManager {
  final String baseUrl = 'https://autolink.fun/AppOP/session_manager.php';

  Future<Map<String, dynamic>> checkSession() async {
    try {
      // Send request to session_manager.php
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // If the response is successful, parse the JSON data
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to get session data'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }
}

class AutoLinkHomePage extends StatefulWidget {
  const AutoLinkHomePage({super.key});

  @override
  _AutoLinkHomePageState createState() => _AutoLinkHomePageState();
}

class _AutoLinkHomePageState extends State<AutoLinkHomePage> {
  late Future<Map<String, dynamic>> sessionData;

  @override
  void initState() {
    super.initState();
    sessionData = SessionManager().checkSession(); // Check session when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2D33),
        title: const Text('AutoLink', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Cart functionality placeholder
            },
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: sessionData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data?['status'] == 'error') {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF27A21), // Match Explore button style
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    // Navigate to login page when the user is not logged in
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle navigation based on value (Account, Settings, Logout)
                    if (value == 'logout') {
                      // Handle logout functionality
                      Navigator.pushNamed(context, '/login'); // Redirect to login after logout
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'account', child: Text('Account')),
                    const PopupMenuItem(value: 'settings', child: Text('Settings')),
                    const PopupMenuItem(value: 'logout', child: Text('Logout')),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'AutoLink',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF27A21),
                    ),
                  ),
                  const Text(
                    'Find and support Local Shops for Your Automotive Needs\nShop Local Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF27A21),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      // Explore functionality placeholder
                    },
                    child: const Text(
                      'Explore',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Services Section
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Auto Services',
                    style: TextStyle(fontSize: 36, color: Color(0xFFF27A21)),
                    textAlign: TextAlign.center, // Center text
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ServiceCard(
                        title: 'Local Repair Shops',
                        description: 'Find trusted local repair shops near you.',
                        image: 'assets/repair1.jpg', // Random image on reload
                      ),
                      ServiceCard(
                        title: 'Quality Parts',
                        description: 'Shop for quality automotive parts and accessories.',
                        image: 'assets/shop1.jpg',
                      ),
                      ServiceCard(
                        title: 'Towing Services',
                        description: 'Reliable towing services available in your area.',
                        image: 'assets/towing1.jpg',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2A2D33),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            '© 2024 AutoLink. All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const ServiceCard({super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, height: 100, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center text
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center, // Center text
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF27A21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // Navigate to detailed service view
              },
              child: const Text('Explore'),
            ),
          ],
        ),
      ),
    );
  }
}
