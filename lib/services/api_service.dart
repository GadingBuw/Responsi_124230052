import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['restaurants'] as List)
          .map((json) => Restaurant.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal memuat list restaurant');
    }
  }

  Future<List<Restaurant>> search(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['restaurants'] as List)
          .map((json) => Restaurant.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mencari restaurant');
    }
  }

  Future<RestaurantDetail> getDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RestaurantDetail.fromJson(data['restaurant']);
    } else {
      throw Exception('Gagal memuat detail restaurant');
    }
  }
}