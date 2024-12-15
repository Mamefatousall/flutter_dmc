import 'package:flutter/material.dart';
import 'package:dmc/pages/woocommerce_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WooCommerceService wooService = WooCommerceService();
  List<dynamic> categories = [];
  List<dynamic> products = [];
  String selectedCategory = 'Toutes';

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndProducts();
  }

  // Fonction pour récupérer les catégories et produits
  Future<void> fetchCategoriesAndProducts() async {
    try {
      List<dynamic> fetchedCategories = await wooService.getCategories();
      List<dynamic> fetchedProducts = await wooService.getProducts();

      setState(() {
        categories = fetchedCategories;
        products = fetchedProducts;
      });
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

  // Fonction pour filtrer les produits par catégorie
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      List<dynamic> fetchedProducts = await wooService.getProducts(categoryId: categoryId);
      setState(() {
        products = fetchedProducts;
        selectedCategory = categoryId.isEmpty ? 'Toutes' : categoryId;
      });
    } catch (e) {
      print("Erreur lors du chargement des produits : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DMComputer.sn'),
        backgroundColor: Color(0xFF006400),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoriesSection(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  // Section pour afficher les catégories
  Widget _buildCategoriesSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _categoryButton('Toutes', ''),
          ...categories.map((category) {
            return _categoryButton(category['name'], category['id'].toString());
          }).toList(),
        ],
      ),
    );
  }

  Widget _categoryButton(String label, String categoryId) {
    bool isSelected = selectedCategory == categoryId || (categoryId.isEmpty && selectedCategory == 'Toutes');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF006400) : Colors.grey[200],
        ),
        onPressed: () {
          fetchProductsByCategory(categoryId);
        },
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Section pour afficher les produits
  Widget _buildProductGrid() {
    if (products.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _productCard(
          product['images'] != null && product['images'].isNotEmpty
              ? product['images'][0]['src']
              : 'https://via.placeholder.com/150',
          product['name'] ?? 'Produit',
          product['price'] != null ? "${product['price']} FCFA" : 'Prix non défini',
        );
      },
    );
  }

  // Carte individuelle pour afficher chaque produit
  Widget _productCard(String imageUrl, String title, String price) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
