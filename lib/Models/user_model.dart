


import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String password;
  final String? prenom;
  final String? nom;
  final String? role;
  final String? telephone;
  final String? profileImage; // Ajouter ce champ


  UserModel({
    required this.email,
    required this.password,
    this.prenom,
    this.nom,
    this.role,
    this.telephone,
    this.profileImage, // Ajouter ce champ
  });

 factory UserModel.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return UserModel(
    email: data['email'] ?? '',
    password: '', // Avoid storing passwords
    prenom: data['prenom'] ?? '',
    nom: data['nom'] ?? '',
    role: data['role'] ?? '',
    telephone: data['telephone'] ?? '',
    profileImage: data['profileImage'] ?? '', 
  );
}

}
