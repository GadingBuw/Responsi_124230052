import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final Box _userBox = Hive.box('userBox');

  void _register() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      if (_userBox.containsKey(username)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username sudah ada!'), backgroundColor: Colors.red));
      } else {
        _userBox.put(username, password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi Berhasil!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi semua data!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Buat Akun Baru"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username Baru', prefixIcon: Icon(Icons.person_add_outlined)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password Baru', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _register,
                child: const Text('REGISTER SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}