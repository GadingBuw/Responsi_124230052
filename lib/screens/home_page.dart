import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Restaurant>> _restaurantList;
  final List<String> _categories = ["Semua", "Italia", "Modern", "Sunda", "Jawa", "Bali"];
  String _selectedCategory = "Semua";

  @override
  void initState() {
    super.initState();
    _restaurantList = _apiService.getList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _restaurantList = (category == "Semua") ? _apiService.getList() : _apiService.search(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, ${widget.username}!", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage())),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: Colors.white,
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => _onCategorySelected(cat),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.orange.shade100,
                    checkmarkColor: Colors.orange.shade800,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.orange.shade900 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? Colors.orange : Colors.transparent),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<Restaurant>>(
              future: _restaurantList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return const Center(child: Text("Gagal memuat data."));
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Data tidak ditemukan."));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final restaurant = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(restaurantId: restaurant.id))),
                          child: Row(
                            children: [
                              Hero(
                                tag: restaurant.id,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                                  child: Image.network(
                                    "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                                    width: 120, height: 100, fit: BoxFit.cover,
                                    errorBuilder: (_,__,___) => Container(width: 120, height: 100, color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Info Text
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(restaurant.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(restaurant.city, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 18, color: Colors.orange),
                                          const SizedBox(width: 4),
                                          Text(restaurant.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}