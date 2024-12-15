import 'package:flutter/material.dart';

class FavorisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006400),
        title: Text('Mes Favoris', style: TextStyle(fontSize: 18)),
      ),
      body: Center(
        child: Text('Aucun produit favori', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
