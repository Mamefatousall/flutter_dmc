import 'package:flutter/material.dart';
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
      home: LoginPage(),  // Lancer la LoginPage ici
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Méthode de connexion (avec validation simple)
  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Exemple de validation simple pour l'email et le mot de passe
    if (email == "test@example.com" && password == "password") {
      // Si la connexion réussit, naviguer vers l'écran principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Remplacez par votre page d'accueil
      );
    } else {
      // Si la connexion échoue, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("E-mail ou mot de passe incorrect"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
        backgroundColor: Color(0xFF006400),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour l'email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Champ pour le mot de passe
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,  // Cacher le mot de passe
            ),
            SizedBox(height: 20),

            // Bouton de connexion
            ElevatedButton(
              onPressed: _login, // Appel de la méthode de connexion
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006400),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Se connecter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Lien pour s'inscrire (optionnel)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pas encore inscrit ? "),
                TextButton(
                  onPressed: () {
                    // Ajouter la logique pour rediriger vers l'écran d'inscription
                    print("Rediriger vers l'écran d'inscription");
                  },
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(color: Color(0xFF006400)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'accueil"),
        backgroundColor: Color(0xFF006400),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page d\'accueil!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
