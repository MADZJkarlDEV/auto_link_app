import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const AutoLinkShop());

class AutoLinkShop extends StatelessWidget {
  const AutoLinkShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLink Shop',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> publishedPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPublishedPosts();
  }

  Future<void> _fetchPublishedPosts() async {
    final url = 'https://your-api-endpoint.com/getPublishedPosts'; // Replace with your endpoint
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          publishedPosts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle errors
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoLink Shop'),
        backgroundColor: const Color(0xFF2A2D33),
        actions: [
          // Add user login/logout button based on state
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to login/signup or user profile
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: publishedPosts.length,
          itemBuilder: (ctx, index) {
            final post = publishedPosts[index];
            return GestureDetector(
              onTap: () => _showPostDetails(context, post),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    Image.network(post['img'], fit: BoxFit.cover, height: 150),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post['title'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Price: ${post['price']}',
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post['tag'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPostDetails(BuildContext context, dynamic post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(20),
        title: Text(post['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(post['img'], fit: BoxFit.cover, height: 200),
            const SizedBox(height: 10),
            Text('Price: ${post['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(post['description']),
            const SizedBox(height: 10),
            Text('Tags: ${post['tag']}'),
            const SizedBox(height: 10),
            Text('Address: ${post['address']}'),
            const SizedBox(height: 10),
            // Optionally, include a map or a link for Google Maps here
            // For example: Google Map iframe or static image of map
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
