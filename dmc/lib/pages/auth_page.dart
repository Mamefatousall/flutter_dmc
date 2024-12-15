import 'package:flutter/material.dart';
import 'package:dmc/pages/woocommerce_service.dart';
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final WooCommerceService wooCommerceService = WooCommerceService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void authenticateUser() async {
    try {
      final response = await wooCommerceService.authenticate(
        usernameController.text,
        passwordController.text,
      );
      print('Token : ${response['token']}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connexion réussie')));
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de connexion')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentification')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Nom d’utilisateur')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: authenticateUser, child: Text('Se connecter')),
          ],
        ),
      ),
    );
  }
}

