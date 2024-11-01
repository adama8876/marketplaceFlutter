import 'package:marketplace_app/Models/favoriteItem.dart';

class Favorite {
  final String userId;
  final List<FavoriteItem> items;

  Favorite({
    required this.userId,
    this.items = const [],
  });

  // Ajouter un produit aux favoris
  void addItem(FavoriteItem item) {
    int index = items.indexWhere((existingItem) => existingItem.id == item.id);
    
    if (index == -1) {
      items.add(item);
    }
  }

  // Convertir Favorite en une map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toFirestore()).toList(),
    };
  }

  // Convertir une map de Firestore en Favorite
  factory Favorite.fromFirestore(Map<String, dynamic> data) {
    return Favorite(
      userId: data['userId'],
      items: (data['items'] as List).map((item) => FavoriteItem.fromFirestore(item)).toList(),
    );
  }
}
