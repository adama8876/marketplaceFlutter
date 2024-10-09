import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/cartItem.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/CartItemdesign.dart';

class Pagepanier extends StatefulWidget {
  final String userId;
  const Pagepanier({super.key, required this.userId});

  @override
  _PagepanierState createState() => _PagepanierState();
}

class _PagepanierState extends State<Pagepanier> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer le panier de l'utilisateur
  Stream<DocumentSnapshot> _getUserCart() {
    return _firestore.collection('carts').doc(widget.userId).snapshots();
  }

  // Méthode pour mettre à jour la quantité dans Firestore
Future<void> _updateQuantity(CartItem cartItem, int newQuantity) async {
  // Récupère le panier de l'utilisateur
  final cartSnapshot = await _firestore.collection('carts').doc(widget.userId).get();

  if (!cartSnapshot.exists) return;

  // Récupère la liste d'items actuelle
  final cartData = cartSnapshot.data() as Map<String, dynamic>;
  List items = cartData['items'];

  // Trouver l'article dans le panier et le retirer
  items.removeWhere((item) => item['productId'] == cartItem.productId);

  // Si la nouvelle quantité est > 0, on ajoute l'article mis à jour
  if (newQuantity > 0) {
    final updatedItem = cartItem.toFirestore();
    updatedItem['quantity'] = newQuantity; // Met à jour la quantité
    items.add(updatedItem); // Ajoute l'article mis à jour
  }

  // Mettre à jour le panier dans Firestore
  await _firestore.collection('carts').doc(widget.userId).update({
    'items': items, // Met à jour avec la nouvelle liste d'items
  });
}


  // Méthode pour supprimer un article du panier
Future<void> _removeFromCart(String productId) async {
  // Récupère le panier actuel de l'utilisateur
  final cartSnapshot = await _firestore.collection('carts').doc(widget.userId).get();

  if (!cartSnapshot.exists) return;

  // Récupère les items du panier
  final cartData = cartSnapshot.data() as Map<String, dynamic>;
  List items = cartData['items'];

  // Supprime l'élément correspondant au productId
  items.removeWhere((item) => item['productId'] == productId);

  // Mettre à jour Firestore avec la nouvelle liste d'items
  await _firestore.collection('carts').doc(widget.userId).update({
    'items': items, // Met à jour avec la liste sans l'élément supprimé
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Panier',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Votre panier est vide"));
          }

          // Vérifie si le document existe et si les données sont sous la forme attendue
          final data = snapshot.data!.data();
          if (data == null) {
            return Center(child: Text("Erreur: Données introuvables"));
          }

          final cartData = data as Map<String, dynamic>;

          // Vérifie si 'items' existe et est une liste
          if (cartData.containsKey('items') && cartData['items'] is List) {
            final List items = cartData['items'];

            // Utilise une vérification pour chaque élément de la liste 'items'
            final cartItems = items.map((item) {
              if (item is Map<String, dynamic>) {
                return CartItem.fromFirestore(item); // Crée des CartItem à partir des données Firestore
              } else {
                print('Erreur: Element incorrect dans items -> $item');
                throw TypeError();
              }
            }).toList();

            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length, // Nombre d'éléments dans le panier
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index]; // Récupère l'élément courant

                        // Assurez-vous que les valeurs sont bien récupérées du modèle CartItem
                        return CartItemdesign(
                          productName: cartItem.name,
                          mainImageUrl: cartItem.mainImageUrl,
                          price: cartItem.price, 
                          quantity: cartItem.quantity, 
                          onRemove: () => _removeFromCart(cartItem.productId), 
                          onIncreaseQuantity: () =>
                              _updateQuantity(cartItem, cartItem.quantity + 1), 
                          onDecreaseQuantity: () =>
                              _updateQuantity(cartItem, cartItem.quantity - 1), 
                        );
                      },
                    ),
                  ),

                _buildTotalSection(cartItems), // Section pour afficher le total
              ],
            );
          } else {
            return Center(child: Text("Aucun article dans le panier."));
          }
        },
      ),
    );
  }

  // Méthode pour afficher le total du panier
  Widget _buildTotalSection(List<CartItem> cartItems) {
    int total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Panier:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  "$total F CFA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2F3E50),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Action pour passer la commande
              },
              icon: Icon(Icons.shopping_bag, color: Colors.white),
              label: Text(
                "Commander",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: Color(0xFF2F3E50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
