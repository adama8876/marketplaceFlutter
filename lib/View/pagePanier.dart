// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/cartItem.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/CommandeDetails.dart';
import 'package:marketplace_app/View/component/CartItemdesign.dart';

class Pagepanier extends StatefulWidget {
  final String userId;
  const Pagepanier({super.key, required this.userId, });

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
    final cartSnapshot = await _firestore.collection('carts').doc(widget.userId).get();

    if (!cartSnapshot.exists) return;

    final cartData = cartSnapshot.data() as Map<String, dynamic>;
    List items = cartData['items'];

    items.removeWhere((item) => item['productId'] == cartItem.productId);

    if (newQuantity > 0) {
      final updatedItem = cartItem.toFirestore();
      updatedItem['quantity'] = newQuantity;
      items.add(updatedItem);
    }

    await _firestore.collection('carts').doc(widget.userId).update({
      'items': items,
    });
  }

  // Méthode pour supprimer un article du panier
  Future<void> _removeFromCart(String productId) async {
    final cartSnapshot = await _firestore.collection('carts').doc(widget.userId).get();

    if (!cartSnapshot.exists) return;

    final cartData = cartSnapshot.data() as Map<String, dynamic>;
    List items = cartData['items'];

    items.removeWhere((item) => item['productId'] == productId);

    await _firestore.collection('carts').doc(widget.userId).update({
      'items': items,
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
            return _buildEmptyCart(); // Affiche l'image du panier vide
          }

          final data = snapshot.data!.data();
          if (data == null) {
            return _buildEmptyCart(); // Affiche l'image du panier vide
          }

          final cartData = data as Map<String, dynamic>;

          if (cartData.containsKey('items') && cartData['items'] is List) {
            final List items = cartData['items'];

            if (items.isEmpty) {
              return _buildEmptyCart(); 
            }

            final cartItems = items.map((item) {
              return CartItem.fromFirestore(item);
            }).toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
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
                _buildTotalSection(cartItems),
              ],
            );
          } else {
            return _buildEmptyCart(); 
          }
        },
      ),
    );
  }

  
  Widget _buildEmptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 20),
        Text(
          "OUPS !!!!",
          style: GoogleFonts.poppins(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red,
          ),
            ),
             Text(
          "Votre panier est vide",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.primaryColor,
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/empttyy.png',
            fit: BoxFit.cover,
            height: 330,
          ),
        ),
        SizedBox(height: 20),
        
      ],
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
              onPressed: () async {
                final cartSnapshot = await _firestore.collection('carts').doc(widget.userId).get();
                final cartData = cartSnapshot.data() as Map<String, dynamic>;
                List items = cartData['items'];

                final articles = items.map((item) => {
                  'productId': item['productId'],
                  'image': item['mainImageUrl'],
                  'name': item['name'],
                  'price': item['price'],
                  'quantity': item['quantity'],
                  'variant': item['variant'],

                }).toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommandeDetails(articles: articles, ),
                  ),
                );
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
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
