import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Box favoriteBox = Hive.box('favoriteBox');

    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Favorit")),
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("Belum ada favorit", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/${item['pictureId']}",
                      width: 80, height: 80, fit: BoxFit.cover,
                      errorBuilder: (_,__,_) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(item['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['city'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.orange),
                          Text(" ${item['rating']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => box.deleteAt(index),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(restaurantId: item['id']))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}