import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:marketplace_app/Models/user_model.dart'; // Ajoutez cette ligne

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Instance de FirebaseStorage

  Future<String?> uploadProfileImage(String imagePath) async {
    try {
      // Créez une référence au stockage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + imagePath.split('/').last;
      Reference reference = _storage.ref().child('profileImages/$fileName');

      // Téléchargez l'image
      UploadTask uploadTask = reference.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;

      // Obtenez l'URL de l'image téléchargée
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Retournez l'URL de l'image
    } catch (e) {
      print("Erreur lors de l'upload de l'image: $e");
      return null; // Retournez null en cas d'erreur
    }
  }

  Future<bool> createVendor({
    required String email,
    required String password,
    required String telephone,
    required String boutiqueNom,
    required String description,
    required String profileImage, // Assurez-vous que ce paramètre est requis
  }) async {
    // Validation des données
    if (email.isEmpty || password.isEmpty || telephone.isEmpty || boutiqueNom.isEmpty || description.isEmpty) {
      print("Erreur: Tous les champs doivent être remplis.");
      return false; // Retourner false en cas de données invalides
    }

    try {
      // Création de l'utilisateur
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Téléchargez l'image de profil et obtenez son URL
      String? profileImageUrl = await uploadProfileImage(profileImage);

      // Création d'un nouvel utilisateur
      UserModel newVendor = UserModel(
        email: email,
        password: password,
        role: "vendeur",
        telephone: telephone,
        profileImage: profileImageUrl, // Utilisez l'URL téléchargée
        isActive: false,
        boutiqueNom: boutiqueNom,
        description: description,
      );

      // Ajoute le vendeur à la collection 'users' dans Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set(newVendor.toMap()); // Assurez-vous que votre modèle a une méthode toMap()

      return true; // Retourner true si la création est réussie
    } catch (e) {
      print("Erreur lors de la création de l'utilisateur vendeur: $e");
      return false; // Retourner false en cas d'erreur
    }
  }
}
