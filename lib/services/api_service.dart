import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/detail_restoran_model.dart';
import '../models/restoran_model.dart';

class ApiService {
  final String baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<List<Restaurants>> getRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/#/?id=get-list-of-restaurant'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> list = data['restaurants'];
      return list.map((e) => Restaurants.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  Future<DetailRestaurants> getDetailRestaurants(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/#/?id=get-detail-of-restaurant'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DetailRestaurants.fromJson(data['detail'][0]);
    } else {
      throw Exception("Failed to load detail");
    }
  }
}