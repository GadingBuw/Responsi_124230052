import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/detail_restoran_model.dart';

class DetailPage extends StatelessWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants Detail"), backgroundColor: Colors.brown, foregroundColor: Colors.white),
      body: FutureBuilder<DetailRestaurants>(
        future: ApiService().getDetailRestaurants(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error"));

          final meal = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(meal.pictureId, width: double.infinity, height: 250, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text(meal.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      const Divider(height: 30),
                      
                      const SizedBox(height: 20),
                      const Text("Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(meal.description, textAlign: TextAlign.justify),
                      
                      const SizedBox(height: 30),
      
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}