import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importez firebase_core
import 'package:marketplace_app/View/Accueil.dart';
import 'package:marketplace_app/View/connectionpage.dart';
import 'package:marketplace_app/View/registerPage.dart';
// import 'package:marketplace_app/View/Homepage.dart';
import 'firebase_options.dart'; // Importez le fichier généré par flutterfire configure
// import 'package:marketplace_app/View/connectionpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour l'initialisation asynchrone
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utilise les options générées pour la configuration Firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConnectionPage(),
    );
  }
}
