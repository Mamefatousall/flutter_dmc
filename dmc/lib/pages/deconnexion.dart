import 'package:flutter/material.dart';

class DeconnexionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title: Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    'Êtes-vous sûr de vouloir vous déconnecter ?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue
                        // Ajoutez ici la logique de déconnexion
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006400), // Vert
                      ),
                      child: Text('Déconnexion'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF006400), // Bouton vert
          ),
          child: Text(
            'Déconnexion',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
