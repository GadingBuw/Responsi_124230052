import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi_124230052/screens/detail_page.dart';
import '../services/api_service.dart';
import '../models/restoran_model.dart';
import 'login_page.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  void _logout(BuildContext context) {
    Hive.box('sessionBox').clear(); // Hapus Sesi
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai Gading"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => _logout(context), icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<Restaurants>>(
        future: ApiService().getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cat = snapshot.data![index];
              return Card(
                color: Colors.orange[50],
                margin: const EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPage(id: cat.id)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.network(cat.pictureId),
                        Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(cat.description, maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}