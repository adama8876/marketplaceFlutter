import 'package:marketplace_app/Models/product_model.dart';

class CartItem {
  final String productId;
  final String name;
  final String mainImageUrl;
  final int price;
  int quantity;
  final String? variant;

  CartItem({
    required this.productId,
    required this.name,
    required this.mainImageUrl,
    required this.price,
    this.quantity = 1,
    this.variant,
  });

  // Crée un CartItem à partir d'un Product
  factory CartItem.fromProduct(Product product, {int quantity = 1, String? variant}) {
    return CartItem(
      productId: product.id,
      name: product.name,
      mainImageUrl: product.mainImageUrl,
      price: product.price,
      quantity: quantity,
      variant: variant,
    );
  }

  // Convertir CartItem en une map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'name': name,
      'mainImageUrl': mainImageUrl,
      'price': price,
      'quantity': quantity,
      'variant': variant,
    };
  }

  // Convertir une map de Firestore en CartItem
  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'],
      name: data['name'],
      mainImageUrl: data['mainImageUrl'],
      price: data['price'],
      quantity: data['quantity'],
      variant: data['variant'],
    );
  }
}
