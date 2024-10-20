import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String password; // À ne pas stocker en clair
  final String? prenom;
  final String? nom;
  final String? role; // Peut être 'client' ou 'vendeur'
  final String? telephone;
  final String? profileImage;
  final bool isActive; // Nouveau champ pour les vendeurs
  final String? boutiqueNom; // Nouveau champ pour le nom de la boutique
  final String? description; // Nouveau champ pour la description de la boutique

  UserModel({
    required this.email,
    required this.password,
    this.prenom,
    this.nom,
    this.role,
    this.telephone,
    this.profileImage,
    this.isActive = false, // Défaut à false lors de la création d'une boutique
    this.boutiqueNom,
    this.description,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      email: data['email'] ?? '',
      password: '', // Éviter de stocker les mots de passe
      prenom: data['prenom'] ?? '',
      nom: data['nom'] ?? '',
      role: data['role'] ?? '',
      telephone: data['telephone'] ?? '',
      profileImage: data['profileImage'] ?? '',
      isActive: data['isActive'] ?? false, // Valeur par défaut
      boutiqueNom: data['boutiqueNom'], // Peut être null
      description: data['description'], // Peut être null
    );
  }

  // Convert a UserModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'prenom': prenom,
      'nom': nom,
      'role': role,
      'telephone': telephone,
      'profileImage': profileImage,
      'isActive': isActive,
      'boutiqueNom': boutiqueNom,
      'description': description,
      // Avoid storing the password in Firestore
    };
  }
}
