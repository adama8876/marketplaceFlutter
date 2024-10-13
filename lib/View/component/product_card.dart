// product_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int price;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.isFavorite,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Image section
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Container(
              height: 150, // Adjusted height to fit content better
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Product name section
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 5), // Adjusted spacing

          // Price and favorite icon section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '$price FCFA',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
