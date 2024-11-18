import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const LoginPage());

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLink Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginSignupScreen(),
      routes: {
        '/main.dart': (context) => const MainScreen(), // Route for the main page
      },
    );
  }
}

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;
  bool _isLoading = false; // Add a loading indicator

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final url = isLogin ? 'https://autolink.fun/AppOP/login.php' : 'https://autolink.fun/AppOP/signup.php';

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        // Store user email in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);

        Navigator.pushReplacementNamed(context, '/main.dart'); // Navigate to the main screen
      } else {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Error occurred')),
        );
      }
    } catch (error) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login to AutoLink' : 'Sign Up for AutoLink'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/logo.png', // Replace with your logo path
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // Password Field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Login/Sign Up Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit, // Disable button if loading
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                isLogin ? 'Login' : 'Sign Up',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            // Toggle Login/Sign Up
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin ? 'Create a new account' : 'Already have an account? Login',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for the main screen
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AutoLink Main Page')),
      body: const Center(
        child: Text('Welcome to AutoLink!'),
      ),
    );
  }
}
