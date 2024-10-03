import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/subcategory_model.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in method
  Future<User?> signIn(UserModel user) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      User? loggedInUser = result.user;

      if (loggedInUser != null) {
        // Check if the user has the 'client' role in Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(loggedInUser.uid).get();
        
        if (userDoc.exists) {
          String role = userDoc.get('role');

          if (role == 'client') {
            return loggedInUser;
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

  // Sign up method (optional)
  Future<User?> signUp(UserModel user) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      User? newUser = result.user;

      if (newUser != null) {
        // Create a user document in Firestore with the 'client' role
        await _firestore.collection('users').doc(newUser.uid).set({
          'email': user.email,
          'role': 'client',
        });
        return newUser;
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
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