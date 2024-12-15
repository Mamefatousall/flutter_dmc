import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceService {
  final String baseUrl = 'https://dmcomputer.sn/wp-json/wc/v3';
  final String consumerKey = 'ck_ce2175287f13be3edb8c8bb884e2e9051cfe08ad';
  final String consumerSecret = 'cs_c95c5bb6027fd918466dd18823a78a227a2d0b35';

  // Fonction pour récupérer les catégories de produits
  Future<List<dynamic>> getCategories() async {
    final String url = '$baseUrl/products/categories?consumer_key=$consumerKey&consumer_secret=$consumerSecret';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Impossible de récupérer les catégories');
    }
  }

  // Fonction pour récupérer les produits
  Future<List<dynamic>> getProducts({String categoryId = ''}) async {
    final String url = '$baseUrl/products?category=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Impossible de récupérer les produits');
    }
  }

  // Fonction d'authentification client
  Future<Map<String, dynamic>> authenticate(String username, String password) async {
    final String url = 'https://dmcomputer.sn/wp-json/jwt-auth/v1/token';
    final response = await http.post(
      Uri.parse(url),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec de l\'authentification');
    }
  }
}
