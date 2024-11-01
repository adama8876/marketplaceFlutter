import 'package:marketplace_app/Models/product_model.dart';

class FavoriteItem {
  final String id; // ID de l'élément favori
  final String userId; // ID de l'utilisateur
  final String name; // Nom du produit
  final String mainImageUrl; // URL de l'image principale
  final String description; // Description du produit
  final int price; // Prix du produit
  final int quantity; // Quantité du produit
  final String categoryId; // ID de la catégorie
  final String subcategoryId; // ID de la sous-catégorie
  final List<Map<String, dynamic>> variantData; // Données de variante

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.mainImageUrl,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.subcategoryId,
    required this.variantData,
  });

  // Factory method to create a FavoriteItem from Firestore
  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(
      id: data['id'],
      userId: data['userId'],
      name: data['name'],
      mainImageUrl: data['mainImageUrl'],
      description: data['description'],
      price: data['price'],
      quantity: data['quantity'],
      categoryId: data['categoryId'],
      subcategoryId: data['subcategoryId'],
      variantData: (data['variantData'] as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  // Convertir FavoriteItem en une map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'mainImageUrl': mainImageUrl,
      'description': description,
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'variantData': variantData,
    };
  }
}
