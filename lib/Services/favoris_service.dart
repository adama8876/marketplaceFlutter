import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/product_model.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Product>> getFavoritesByUserId(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('favorites') // Assurez-vous que c'est la bonne collection
          .where('userId', isEqualTo: userId)
          .get();

      // Debug: Afficher le nombre de documents récupérés
      print('Nombre de favoris récupérés : ${snapshot.docs.length}');

      // Récupérer les produits favoris
      List<Product> favoriteProducts = snapshot.docs.map((doc) {
        // Assurez-vous que votre document contient un ID de produit
        String productId = doc['productId'];
        return Product.fromFirestore(doc);
      }).toList();

      return favoriteProducts;
    } catch (e) {
      print('Erreur lors de la récupération des produits favoris : $e');
      return [];
    }
  }
  // Récupérer les produits favoris
  Future<List<Product>> getFavorites(String userId) async {
    DocumentSnapshot favoriteDoc = await _firestore.collection('favorites').doc(userId).get();

    List<Product> favoriteProducts = [];

    if (favoriteDoc.exists && favoriteDoc.data() != null) {
      List<dynamic> favoriteItems = (favoriteDoc.data() as Map<String, dynamic>)['items'] ?? [];

      for (var item in favoriteItems) {
        // Utiliser un ID de produit pour récupérer le produit de Firestore
        DocumentSnapshot productDoc = await _firestore.collection('products').doc(item['id']).get();

        if (productDoc.exists) {
          favoriteProducts.add(Product.fromFirestore(productDoc));
        }
      }
    }

    return favoriteProducts;
  }




  // Ajouter un produit aux favoris
  Future<void> addToFavorites(String userId, Product product) async {
    DocumentSnapshot favoriteDoc = await _firestore.collection('favorites').doc(userId).get();

    List<dynamic> favoriteItems = [];
    if (favoriteDoc.exists && favoriteDoc.data() != null) {
      favoriteItems = (favoriteDoc.data() as Map<String, dynamic>)['items'] ?? [];
    }

    // Vérifie si le produit est déjà dans les favoris
    bool productExists = favoriteItems.any((item) => item['id'] == product.id);
    if (!productExists) {
      favoriteItems.add({
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'mainImageUrl': product.mainImageUrl,
        'secondImageUrl': product.secondImageUrl,
        'thirdImageUrl': product.thirdImageUrl,
        'fourthImageUrl': product.fourthImageUrl,
        'price': product.price,
        'quantity': product.quantity,
        'categoryId': product.categoryId,
        'subcategoryId': product.subcategoryId,
        'createdAt': Timestamp.fromDate(product.createdAt),
        'variantData': product.variantData,
      });

      await _firestore.collection('favorites').doc(userId).set({
        'userId': userId,
        'items': favoriteItems,
      });
    }
  }

  // Retirer un produit des favoris
  Future<void> removeFromFavorites(String userId, String productId) async {
    DocumentSnapshot favoriteDoc = await _firestore.collection('favorites').doc(userId).get();

    if (favoriteDoc.exists && favoriteDoc.data() != null) {
      List<dynamic> favoriteItems = (favoriteDoc.data() as Map<String, dynamic>)['items'] ?? [];

      favoriteItems.removeWhere((item) => item['id'] == productId);
      await _firestore.collection('favorites').doc(userId).set({
        'userId': userId,
        'items': favoriteItems,
      });
    }
  }

  // Vérifier si un produit est dans les favoris
  Future<bool> isFavorite(String userId, String productId) async {
    DocumentSnapshot favoriteDoc = await _firestore.collection('favorites').doc(userId).get();

    if (favoriteDoc.exists && favoriteDoc.data() != null) {
      List<dynamic> favoriteItems = (favoriteDoc.data() as Map<String, dynamic>)['items'] ?? [];
      return favoriteItems.any((item) => item['id'] == productId);
    }
    return false;
  }

  // Obtenir le nombre de favoris en temps réel
  Stream<int> getFavoriteCount(String userId) {
    return _firestore.collection('favorites').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final favoriteData = snapshot.data() as Map<String, dynamic>;
        final items = favoriteData['items'] as List<dynamic>? ?? [];
        return items.length;
      }
      return 0;
    });
  }
}
