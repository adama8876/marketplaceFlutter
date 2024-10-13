// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Services/PanierService.dart';
import 'package:marketplace_app/Models/cartItem.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/variant_options.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final CartService _cartService = CartService(); // Instancier le CartService
  Map<String, String?> _selectedVariants = {}; // Stocker les variantes sélectionnées par type de variante

  // Fonction pour ajouter le produit au panier
  Future<void> _addToCart(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez vous connecter pour ajouter au panier")),
      );
      return;
    }

    // Vérifier si le produit a des variantes
    bool hasVariants = widget.product.variantData.isNotEmpty;

    // Si le produit a des variantes et qu'une variante obligatoire n'a pas été sélectionnée
    if (hasVariants) {
      bool allVariantsSelected = widget.product.variantData.every((variantType) {
        return _selectedVariants[variantType['type']] != null;
      });

      if (!allVariantsSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Veuillez sélectionner une variante pour chaque type.")),
        );
        return;
      }
    }

    // Création de l'élément de panier avec les variantes sélectionnées
    CartItem cartItem = CartItem.fromProduct(
      widget.product,
      quantity: 1,
      variant: _selectedVariants.isNotEmpty ? _selectedVariants.toString() : null,
    );

    String resultMessage = await _cartService.addToCart(user.uid, cartItem);

    // Message de confirmation d'ajout au panier
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resultMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Infos sur le produit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primaryColor, // AppColors.primaryColor
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
          // Contenu défilant
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 15.0, left: 12, right: 12, bottom: 100), // Marge en bas pour le bouton
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image du produit
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
                        ),
                        child: Image.network(
                          widget.product.mainImageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                    );
                  },
                ),
                // Titre et prix du produit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      '${widget.product.price} FCFA',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 16.0),

                // Gestion des variantes
                VariantOptions(
                  variantData: widget.product.variantData,
                  onSelected: (variantType, variant) {
                    setState(() {
                      _selectedVariants[variantType] = variant;
                    });
                  },
                  selectedVariants: _selectedVariants,
                ),
                // Description
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 80.0), // Extra space to avoid content being hidden behind the button
              ],
            ),
          ),

          // Bouton Ajouter au Panier
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addToCart(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: AppColors.primaryColor, // AppColors.primaryColor
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
                        style: TextStyle(
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
}
