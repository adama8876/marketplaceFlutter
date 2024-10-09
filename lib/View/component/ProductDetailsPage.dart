// product_details_page.dart
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Services/PanierService.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/Models/cartItem.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final CartService _cartService = CartService();  // Instancier le CartService

   ProductDetailsPage({Key? key, required this.product}) : super(key: key);

   // Fonction pour ajouter le produit au panier
  Future<void> _addToCart(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez vous connecter pour ajouter au panier")),
      );
      return;
    }

    
    CartItem cartItem = CartItem.fromProduct(product, quantity: 1);

    
    String resultMessage = await _cartService.addToCart(user.uid, cartItem);

   
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Container(
        padding: EdgeInsets.all(16),
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular( 20))
        ),
        child: Text(resultMessage, style: TextStyle(
          fontWeight: FontWeight.w500
          
        ),),
      ),behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Infos sur le produit', 
          style: GoogleFonts.poppins(
            color: Colors.white, 
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          
        ),
        
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 15.0, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double screenHeight = MediaQuery.of(context).size.height;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        width: double.infinity,
                        height: screenHeight * 0.40, 
                        decoration: BoxDecoration(
                          color: Color.fromARGB(113, 217, 217, 217),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Image.network(
                          product.mainImageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                    );
                  },
                ),
                // Product Title and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      '${product.price} FCFA',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Description
                Text(
                  'Description:',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Colors (dummy example, replace with actual color variants if needed)
                const Text(
                  'COULEURS:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    _buildColorOption(Colors.red),
                    _buildColorOption(Colors.orange),
                    _buildColorOption(Colors.green),
                    _buildColorOption(Colors.blue),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Sizes (dummy example, can be expanded to show actual sizes)
                const Text(
                  'TAILLES:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 80.0), // Extra space to avoid content being hidden behind the button
              ],
            ),
          ),
          // Add to Cart Button fixed at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addToCart(context), // Appelle la fonction d'ajout au panier
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(width: 50), // Adjust the width to your desired space
                      Text(
                        'Ajouter au Panier',
                        style: GoogleFonts.poppins(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build color options
  Widget _buildColorOption(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
