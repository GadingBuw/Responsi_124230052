import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'restaurant_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final Box _usersBox = Hive.box('usersBox');     // Database User
  final Box _sessionBox = Hive.box('sessionBox'); // Penyimpanan Sesi Login

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (_usersBox.containsKey(username)) {
      if (_usersBox.get(username) == password) {
        // Login Berhasil -> Simpan Sesi
        _sessionBox.put('isLoggedIn', true);
        _sessionBox.put('username', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RestaurantsPage()),
        );
      } else {
        _showMsg("Password Salah!");
      }
    } else {
      _showMsg("Username tidak ditemukan!");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 80, color: Colors.brown),
            const SizedBox(height: 20),
            const Text("Meal App Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.brown, foregroundColor: Colors.white),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterPage())),
              child: const Text("Belum punya akun? Register"),
            )
          ],
        ),
      ),
    );
  }
}