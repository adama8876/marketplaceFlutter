import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/cartItem.dart';
import 'package:marketplace_app/Models/panierModel.dart';


class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer le panier de l'utilisateur
  Future<Cart?> getCartByUserId(String userId) async {
    DocumentSnapshot cartDoc = await _firestore.collection('carts').doc(userId).get();

    if (cartDoc.exists) {
      return Cart.fromFirestore(cartDoc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<String> addToCart(String userId, CartItem item) async {
  // Récupère le panier de l'utilisateur
  Cart? cart = await getCartByUserId(userId);

  // Si le panier n'existe pas, créer un nouveau panier
  if (cart == null) {
    cart = Cart(userId: userId, items: [item]);
  } else {
    // Vérifie si le produit est déjà dans le panier
    bool productExists = cart.items.any((cartItem) => cartItem.productId == item.productId);

    if (productExists) {
      // Si le produit existe déjà dans le panier, retourne un message
      return "Ce produit existe déjà dans le panier";
    } else {
      // Si le produit n'existe pas, l'ajoute au panier
      cart.addItem(item);
    }
  }

  // Met à jour Firestore en s'assurant que chaque item est bien un objet complet
  final itemsData = cart.items.map((item) => item.toFirestore()).toList();

  await _firestore.collection('carts').doc(userId).set({
    'userId': userId,
    'items': itemsData, // Ajoute chaque élément correctement formaté
  });

  return "Produit ajouté au panier";
}


  // Supprimer un produit du panier
  Future<void> removeFromCart(String userId, String productId) async {
    Cart? cart = await getCartByUserId(userId);

    if (cart != null) {
      cart.items.removeWhere((item) => item.productId == productId);
      await _firestore.collection('carts').doc(userId).set(cart.toFirestore());
    }
  }

  // Vider le panier
  Future<void> clearCart(String userId) async {
    await _firestore.collection('carts').doc(userId).delete();
  }
}
