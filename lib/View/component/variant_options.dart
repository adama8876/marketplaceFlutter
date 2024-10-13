import 'package:flutter/material.dart';
import 'package:marketplace_app/Utils/themes.dart';

class VariantOptions extends StatelessWidget {
  final List<dynamic> variantData;
  final Map<String, String?> selectedVariants;
  final Function(String variantType, String variant) onSelected;

  VariantOptions({
    required this.variantData,
    required this.onSelected,
    required this.selectedVariants,
  });

  // Fonction pour convertir les noms de couleurs en valeur Color
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'rouge':
        return Colors.red;
      case 'noire':
        return Colors.black;
      case 'jaune':
        return Colors.yellow;
      case 'bleu':
        return Colors.blue;
      case 'vert':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'violet':
        return Colors.purple;
      case 'blanc':
        return Colors.white;
      case 'gris':
        return Colors.grey;
      default:
        return Colors.transparent; // Si la couleur n'est pas reconnue
    }
  }

  // Fonction pour construire les options des variantes (couleurs ou autres)
  Widget _buildVariantOption(String variantType, String option, bool isSelected, {bool isColor = false}) {
    return GestureDetector(
      onTap: () {
        onSelected(variantType, option); // Appelle la fonction pour gérer la sélection de l'utilisateur
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
        padding: isColor
            ? const EdgeInsets.all(0) // Pas de padding pour les couleurs
            : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding pour les textes
        width: isColor ? 40 : null, // Largeur fixe pour les couleurs, largeur flexible pour les textes
        height: isColor ? 40 : null, // Hauteur fixe pour les couleurs
        decoration: BoxDecoration(
          color: isColor ? _getColorFromName(option) : (isSelected ? Colors.grey[300] : Colors.white), // Couleurs pour les options
          shape: isColor ? BoxShape.circle : BoxShape.rectangle, // Cercle pour les couleurs, rectangle pour les textes
          border: isSelected ? Border.all(width: 4.0, color: AppColors.primaryColor) : Border.all(width: 1.0, color: Colors.grey),
          borderRadius: isColor ? null : BorderRadius.circular(8.0), // Bordure arrondie pour les variantes texte
        ),
        child: !isColor ? Text(option) : null, // Affichage du texte pour les options non colorées
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: variantData.map((variant) {
        String variantType = variant['type'] ?? '';
        List<String> options = (variant['options'] as List<dynamic>).cast<String>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              variantType, // Affiche le type de variante (Couleurs, Tailles, etc.)
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0, // Espace entre les lignes
              children: options.map<Widget>((option) {
                // Si le type est 'Couleurs', afficher des boutons colorés
                bool isSelected = selectedVariants[variantType] == option;
                if (variantType == 'Couleurs') {
                  return _buildVariantOption(variantType, option, isSelected, isColor: true);
                } else {
                  // Autres variantes (texte simple)
                  return _buildVariantOption(variantType, option, isSelected, isColor: false);
                }
              }).toList(),
            ),
            const SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    );
  }
}
