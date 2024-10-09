import 'package:flutter/material.dart';
import 'package:marketplace_app/Utils/themes.dart';

class CartItemdesign extends StatelessWidget {
  final String productName;
  final String mainImageUrl;
  final int price;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;

  const CartItemdesign({
    Key? key,
    required this.productName,
    required this.mainImageUrl,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(181, 255, 255, 255),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                mainImageUrl, // Utilisation de l'image dynamique
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Détails du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName, // Utilisation du nom du produit dynamique
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Catégorie", // Tu peux ajouter une catégorie dynamique ici si tu en as une
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$price FCFA", // Utilisation du prix dynamique
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Boutons pour quantité et supprimer
            Column(
              children: [
                // Bouton supprimer
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onRemove,
                ),
                Row(
                  children: [
                    // Bouton diminuer la quantité
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: onDecreaseQuantity,
                    ),
                    Text(
                      '$quantity', // Affiche la quantité dynamique
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Bouton augmenter la quantité
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onIncreaseQuantity,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
