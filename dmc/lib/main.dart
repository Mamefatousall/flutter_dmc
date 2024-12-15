import 'package:dmc/pages/favoris_page.dart';
import 'package:dmc/pages/mon_compte_page.dart';
import 'package:dmc/pages/panier_page.dart';
import 'package:dmc/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmc/pages/api_service.dart';

void main() {
  runApp(DMCApp());
}

class DMCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DMC',
      theme: ThemeData(
        primaryColor: Color(0xFF006400),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String selectedCategory = 'Toutes';
  List<dynamic> categories = [];
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
  }

  void _fetchCategories() async {
    try {
      final data = await ApiService.fetchCategories();
      setState(() {
        categories = data;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _fetchProducts({int? categoryId}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.fetchProducts(categoryId: categoryId);
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006400),
        title: Text('DMComputer.sn', style: TextStyle(fontSize: 18)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF006400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DMC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Darou Mouhty Computer',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined, color: Colors.black),
              title: Text('Accueil'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.favorite_outline, color: Colors.black),
              title: Text('Favoris'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavorisPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.black),
              title: Text('Recherche'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined, color: Colors.black),
              title: Text('Panier'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PanierPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined, color: Colors.black),
              title: Text('Partager'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.black),
              title: Text('Mon compte'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonCompte()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.black),
              title: Text('À propos'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock_outline, color: Colors.black),
              title: Text('Politique de confidentialité'),
              onTap: () {},
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF006400),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Action de déconnexion
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Déconnexion'),
                        content: Text('Etes-vous sûr de vouloir vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fermer le dialogue
                            },
                            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF006400),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Fermer le dialogue
                            },
                            child: Text('Confirmer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Carrousel
          CarouselSlider(
            items: [
              Image.asset('images/computer.jpg', fit: BoxFit.cover),
              Image.asset('images/mac.jpg', fit: BoxFit.cover),
              Image.asset('images/dell.jpg', fit: BoxFit.cover),
            ],
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
            ),
          ),
          SizedBox(height: 10),
          // Catégories dynamiques
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoryButton('Toutes', null),
                ...categories.map((category) {
                  return categoryButton(category['name'], category['id']);
                }).toList(),
              ],
            ),
          ),
          // Produits dynamiques
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? Center(child: Text('Aucun produit trouvé'))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: productCard(
                    product['image'] ?? 'https://via.placeholder.com/150',
                    product['name'],
                    '${product['price']} FCFA',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF006400),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailScreen(
                product: {
                  'id': 1,
                  'name': 'Produit Exemple',
                  'price': 50000,
                  'description': 'Description exemple pour un produit.',
                  'image': 'https://via.placeholder.com/150',
                },
              )),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PanierPage()),
            );
          } else if (index == 3) {
            // Redirige vers la page "Mon compte"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MonCompte()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            label: 'Mon compte',
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String label, int? categoryId) {
    bool isSelected = selectedCategory == label;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF006400) : Colors.grey[200],
          side: BorderSide(color: isSelected ? Color(0xFF006400) : Colors.grey),
        ),
        onPressed: () {
          setState(() {
            selectedCategory = label;
          });
          _fetchProducts(categoryId: categoryId);
        },
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF006400),
          ),
        ),
      ),
    );
  }

  Widget productCard(String imageUrl, String title, String price) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
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
        ),
      ],
    );
  }
}

// Page de détail produit
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1; // Quantité initiale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Détails du produit'),
        backgroundColor: Color(0xFF006400),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product['image'] ?? 'https://via.placeholder.com/500',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.product['price']} FCFA',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.product['description'] ?? 'Aucune description disponible.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text('Quantité:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                      Spacer(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Gérer l'ajout au panier ici
                          print('Produit ajouté au panier: ${widget.product['name']} (Quantité: $quantity)');
                          // Implémentez votre logique d'ajout au panier ici
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF006400), // Couleur verte pour le bouton
                        ),
                        child: Text('Ajouter au panier',style: TextStyle( color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${widget.product['price']} FCFA',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
