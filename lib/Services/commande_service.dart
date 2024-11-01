import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/commande_model.dart';

class CommandeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCommande(Commande commande) async {
    try {
      await _firestore.collection('orders').add(commande.toMap());
    } on FirebaseException catch (e) {
      // Gestion d'erreur spécifique pour Firebase
      throw Exception("Erreur de Firebase lors de la création de la commande: ${e.message}");
    } catch (e) {
      // Gestion d'autres types d'erreurs
      throw Exception("Erreur lors de la création de la commande: $e");
    }
  }

  // Méthode pour récupérer les commandes d'un utilisateur
  Stream<List<Commande>> getUserCommandes(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Commande.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        }).handleError((error) {
          // Gérer les erreurs lors de la récupération des données
          print("Erreur lors de la récupération des commandes: $error");
        });
  }
}
