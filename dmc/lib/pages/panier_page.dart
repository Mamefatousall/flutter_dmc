import 'package:flutter/material.dart';
import 'api_service.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Charger les articles du panier
  Future<void> _loadCart() async {
    setState(() => isLoading = true);
    try {
      final items = await ApiService.fetchCart();
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement du panier: $e');
      setState(() => isLoading = false);
    }
  }

  // Supprimer un article
  Future<void> _removeItem(String cartItemKey) async {
    try {
      await ApiService.removeFromCart(cartItemKey);
      _loadCart(); // Recharger le panier après suppression
    } catch (e) {
      print('Erreur suppression: $e');
      // Affiche une notification ou message d'erreur à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006400),
        title: Text('Mon Panier', style: TextStyle(fontSize: 18)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: Image.network(item['image'] ?? '', width: 50, height: 50),
            title: Text(item['name'] ?? 'Produit'),
            subtitle: Text('${item['price']} FCFA'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeItem(item['key']), // Utilise la clé de l'article
            ),
          );
        },
      ),
      bottomNavigationBar: _buildTotalFooter(),
    );
  }

  // Afficher le total
  Widget _buildTotalFooter() {
    double total = cartItems.fold(0, (sum, item) {
      return sum + double.parse(item['price'].toString());
    });

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ${total.toStringAsFixed(2)} FCFA',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF006400),
            ),
            onPressed: () {
              // Logique pour finaliser la commande
            },
            child: Text('Commander'),
          ),
        ],
      ),
    );
  }
}
