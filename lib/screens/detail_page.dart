import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/restaurant_detail.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;
  const DetailPage({super.key, required this.restaurantId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  final Box _favoriteBox = Hive.box('favoriteBox');
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = _favoriteBox.containsKey(widget.restaurantId);
  }

  void _toggleFavorite(RestaurantDetail detail) {
    setState(() {
      if (_isFavorite) {
        _favoriteBox.delete(detail.id);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari Favorit'), backgroundColor: Colors.red));
      } else {
        _favoriteBox.put(detail.id, {
          'id': detail.id,
          'name': detail.name,
          'city': detail.city,
          'rating': detail.rating,
          'pictureId': detail.pictureId,
        });
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke Favorit'), backgroundColor: Colors.green));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RestaurantDetail>(
        future: _apiService.getDetail(widget.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text("Error memuat detail"));
          
          final detail = snapshot.data!;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: Colors.orange.shade800,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(detail.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, shadows: [const Shadow(color: Colors.black45, blurRadius: 10)])),
                  background: Hero(
                    tag: detail.id,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/large/${detail.pictureId}",
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                    child: IconButton(
                      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                      color: _isFavorite ? Colors.redAccent : Colors.white,
                      onPressed: () => _toggleFavorite(detail),
                    ),
                  )
                ],
              ),
              
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Efek sheet rounded
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.orange.shade800),
                          const SizedBox(width: 8),
                          Expanded(child: Text("${detail.address}, ${detail.city}", style: GoogleFonts.poppins(color: Colors.grey.shade700))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.orange, size: 28),
                          const SizedBox(width: 8),
                          Text("${detail.rating}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(" / 5.0", style: GoogleFonts.poppins(color: Colors.grey)),
                        ],
                      ),
                      
                      const Divider(height: 40),

                      Text("Kategori", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: detail.categories.map((c) => Chip(
                          label: Text(c, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange.shade400,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        )).toList(),
                      ),
                      
                      const SizedBox(height: 24),

                      Text("Tentang", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(detail.description, style: GoogleFonts.poppins(height: 1.6, color: Colors.black87), textAlign: TextAlign.justify),
                      
                      const SizedBox(height: 24),

                      Text("Menu Makanan", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: detail.foods.map((f) => Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade100)
                            ),
                            child: Center(child: Text(f, style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w600))),
                          )).toList(),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}