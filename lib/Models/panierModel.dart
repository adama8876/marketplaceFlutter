import 'package:marketplace_app/Models/cartItem.dart';



class Cart {
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.userId,
    this.items = const [],
  });

  // Ajouter un produit au panier
  void addItem(CartItem item) {
    int index = items.indexWhere((existingItem) => existingItem.productId == item.productId);
    
    if (index >= 0) {
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }
  }

  // Convertir Cart en une map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toFirestore()).toList(),
    };
  }

  // Convertir une map de Firestore en Cart
  factory Cart.fromFirestore(Map<String, dynamic> data) {
    return Cart(
      userId: data['userId'],
      items: (data['items'] as List).map((item) => CartItem.fromFirestore(item)).toList(),
    );
  }
}
