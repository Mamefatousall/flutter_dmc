import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL et clés d'authentification
  static const String baseUrl = 'https://dmcomputer.sn/wp-json/wc/v3/';
  static const String consumerKey = 'ck_ce2175287f13be3edb8c8bb884e2e9051cfe08ad';
  static const String consumerSecret = 'cs_c95c5bb6027fd918466dd18823a78a227a2d0b35';

  // Méthode privée pour l'authentification Basic
  static String _auth() {
    return base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
  }

  // =================== AUTHENTIFICATION ===================
  // Connexion utilisateur
  static Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de connexion: ${response.statusCode} - ${response.body}');
    }
  }

  // =================== CATEGORIES ===================
  // Récupérer toutes les catégories
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${baseUrl}products/categories'),
      headers: {'Authorization': 'Basic ${_auth()}'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      _handleError(response);
      return [];
    }
  }

  // =================== PRODUITS ===================
  // Récupérer tous les produits, optionnellement filtrés par catégorie
  static Future<List<dynamic>> fetchProducts({int? categoryId}) async {
    String url = '${baseUrl}products';
    if (categoryId != null) {
      url += '?category=$categoryId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Basic ${_auth()}'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      _handleError(response);
      return [];
    }
  }

  // Récupérer un produit unique par ID
  static Future<dynamic> fetchProduct(int productId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}products/$productId'),
      headers: {'Authorization': 'Basic ${_auth()}'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      return null;
    }
  }

  // =================== PANIER ===================
  // Récupérer les articles du panier
  static Future<List<dynamic>> fetchCart() async {
    final response = await http.get(
      Uri.parse('${baseUrl}cart/items'),
      headers: {'Authorization': 'Basic ${_auth()}'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      _handleError(response);
      return [];
    }
  }

  // Ajouter un produit au panier
  static Future<dynamic> addToCart(int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('${baseUrl}cart/add'),
      headers: {
        'Authorization': 'Basic ${_auth()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      return null;
    }
  }

  // Mettre à jour un article dans le panier
  static Future<dynamic> updateCartItem(String cartItemKey, int quantity) async {
    final response = await http.post(
      Uri.parse('${baseUrl}cart/update'),
      headers: {
        'Authorization': 'Basic ${_auth()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'cart_item_key': cartItemKey,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      return null;
    }
  }

  // Supprimer un article du panier
  static Future<dynamic> removeFromCart(String cartItemKey) async {
    final response = await http.post(
      Uri.parse('${baseUrl}cart/remove'),
      headers: {
        'Authorization': 'Basic ${_auth()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'cart_item_key': cartItemKey}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      return null;
    }
  }

  // =================== COUPONS ===================
  // Récupérer les coupons
  static Future<List<dynamic>> fetchCoupons() async {
    final response = await http.get(
      Uri.parse('${baseUrl}coupons'),
      headers: {'Authorization': 'Basic ${_auth()}'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      _handleError(response);
      return [];
    }
  }

  // Créer un coupon
  static Future<dynamic> createCoupon(Map<String, dynamic> couponData) async {
    final response = await http.post(
      Uri.parse('${baseUrl}coupons'),
      headers: {
        'Authorization': 'Basic ${_auth()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(couponData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      return null;
    }
  }

  // =================== GESTION DES ERREURS ===================
  static void _handleError(http.Response response) {
    throw Exception('Erreur ${response.statusCode}: ${response.body}');
  }
}
