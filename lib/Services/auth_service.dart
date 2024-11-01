import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace_app/Models/subcategory_model.dart';
import 'package:marketplace_app/models/user_model.dart';
// import 'package:marketplace_app/Models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

// import '../models/user_model.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;







  
  // Sign in method with role and isActive check
Future<User?> signIn(UserModel user) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    User? loggedInUser = result.user;

    if (loggedInUser != null) {
      // Récupère le document utilisateur dans Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(loggedInUser.uid).get();

      if (userDoc.exists) {
        String role = userDoc.get('role');
        bool isActive = userDoc.get('isActive');

        if (role == 'client' && isActive) {
          return loggedInUser;
        } else if (!isActive) {
          print("Votre compte n'est pas activé. Veuillez contacter l'administrateur.");
          return null;
        } else {
          print('User does not have the client role.');
          return null;
        }
      } else {
        print('User document does not exist in Firestore.');
        return null;
      }
    }
    return null;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


  Future<UserModel?> getUserData() async {
  try {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        print('User document data: ${userDoc.data()}'); // Add this line to see the data fetched
        return UserModel.fromFirestore(userDoc);
      } else {
        print('User document does not exist in Firestore.');
        return null;
      }
    } else {
      print('No user is currently signed in.');
      return null;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}


// Méthode pour créer un compte client
  Future<bool> signUp(String prenom, String nom, String email, String telephone, String password) async {
    try {
      // Crée un utilisateur avec Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? newUser = result.user;

      if (newUser != null) {
        // Créer un document dans Firestore pour l'utilisateur
        UserModel userModel = UserModel(
          email: email,
          password: password, // N'oublie pas que nous ne stockons pas le mot de passe en clair
          prenom: prenom,
          nom: nom,
          role: 'client',
          telephone: telephone,
          profileImage: '', // On peut ajouter une image de profil plus tard
          isActive: true, // Par défaut, le compte est actif lors de la création
        );

        await _firestore.collection('users').doc(newUser.uid).set(userModel.toMap());
        print('Compte client créé avec succès');
        return true;
      }

      return false;
    } catch (e) {
      print('Erreur lors de la création du compte client: $e');
      return false;
    }
  }




  

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ------------------------------------------------------------------------------------------------


   // Méthode pour réauthentifier l'utilisateur
  Future<bool> reauthenticateUser(UserModel user) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email,
          password: user.password,
        );

        // Tente de réauthentifier l'utilisateur
        await currentUser.reauthenticateWithCredential(credential);
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la réauthentification : $e');
      return false;
    }
  }
  
  // Méthode pour télécharger l'image de profil et récupérer l'URL
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Crée un chemin unique pour l'image dans Firebase Storage
        String filePath = 'profile_images/${currentUser.uid}.jpg';
        Reference ref = _storage.ref().child(filePath);
        
        // Télécharge l'image
        await ref.putFile(imageFile);

        // Récupère l'URL de l'image téléchargée
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      }
      return null;
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
      return null;
    }
  }

  // Méthode pour mettre à jour les données de l'utilisateur, y compris l'URL de l'image
  Future<void> updateUserData(String email, String prenom, String nom, String telephone, {String? profileImageUrl}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Crée un map des données à mettre à jour
        Map<String, dynamic> updatedData = {
          'prenom': prenom,
          'nom': nom,
          'telephone': telephone,
        };

        // Ajoute l'URL de l'image si elle existe
        if (profileImageUrl != null) {
          updatedData['profileImage'] = profileImageUrl;
        }

        // Mise à jour des données dans Firestore
        await _firestore.collection('users').doc(currentUser.uid).update(updatedData);
        print('Les données utilisateur ont été mises à jour.');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour des données de l\'utilisateur : $e');
    }
  }



}











class SubcategoryService {
  final CollectionReference _subcategoryCollection =
      FirebaseFirestore.instance.collection('subcategories');
  

  // Fetch subcategories from Firestore
  Future<List<Subcategory>> fetchSubcategories() async {
    try {
      QuerySnapshot snapshot = await _subcategoryCollection.get();
      return snapshot.docs
          .map((doc) => Subcategory.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  
  
}