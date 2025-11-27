import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_page.dart';
import 'screens/restaurant_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Hive
  await Hive.initFlutter();
  await Hive.openBox('usersBox');   // Untuk simpan user
  await Hive.openBox('sessionBox'); // Untuk simpan status login

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi Restoran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const CheckAuth(),
    );
  }
}

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBox = Hive.box('sessionBox');
    bool isLoggedIn = sessionBox.get('isLoggedIn', defaultValue: false);
    
    // Cek Login [cite: 40]
    return isLoggedIn ? const RestaurantsPage() : const LoginPage();
  }
}